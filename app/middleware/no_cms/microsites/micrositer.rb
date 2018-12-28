class NoCms::Microsites::Micrositer
  def initialize(app)
    @app = app
    @default_host = Settings.host_without_protocol
  end

  def call(env)
    request = Rack::Request.new(env)

    if request.host != @default_host
      # If request host is not the default one, we have to treat this request
      Rails.logger.info(">>> request host is #{request.host} and default host is #{@default_host}")
      Rails.logger.info("Looking for microsite #{request.host}")
      microsite = NoCms::Microsites::Microsite.find_by_domain(request.host)
      env["MICROSITE_KEY"] = microsite.internal_name if microsite && microsite.internal_name.present?
      env["MICROSITE_ID"] = microsite.id if microsite

      # If request starts by assets or locale/assets, do not change path
      unless microsite.nil? || request.path.match("#{not_redirected_routes.join('|')}")
        Rails.logger.info(">>> We have to replace the route, the path is #{request.path}")
        replace_route_for request, env, microsite
      end
    else
      # Es un microsite fake para la pagina principal
      env["MICROSITE_ID"] = NoCms::Microsites::Microsite.where(domain: @default_host).pluck(:id).first
    end
    status, headers, response = @app.call(env)
    unless microsite.blank?
      replace_host_for response, request, microsite, headers, status
    end
    [status, headers, response]
  end

  private

  # Searches a microsite by domain and calls to remap request
  # with microsite root path
  def replace_route_for request, env, microsite
    unless microsite.blank?
      Rails.logger.info(">>> Previous request path was #{env["PATH_INFO"]} and microsite root path is #{microsite.root_path}")
      env["PATH_INFO"] = remap_paths_with_locales(microsite, env["PATH_INFO"])
    end
  end

  # Gets roots of not redirected routes to form a regex
  def not_redirected_routes
    routes = ["(\/assets\/)"]
    I18n.available_locales.each do |locale|
      routes << "^(\/#{locale.to_s}\/assets\/)"
    end
    routes
  end

  # Changes requests to fit microsite path
  def remap_paths_with_locales(microsite, request_path)
    locales = []
    request_path = request_path[1..-1]
    I18n.available_locales.each do |locale|
      locales << "^(\/#{locale.to_s}\/)"
    end

    # if request comes with locale, we maintain it in new request
    if request_path.match(locales.join('|'))
      locale = request_path.at(0..3)
      I18n.locale = locale

      path = "#{locale}#{microsite.root_path}#{request_path.remove(locale)}"
    else
      path = "#{microsite.root_path}#{request_path}"
    end

    Rails.logger.info(">>>> Returning new path for request #{path}")

    path
  end

  # Changes response to fit new microsite url
  def replace_host_for response, request, microsite, headers, status
    length = 0
    response.each do |body|
      Rails.logger.info(">>>> Removing root path from response, searching #{Settings.host}")
      body.gsub!(/#{Settings.host}\/#{microsite.root_path}/, '/')
      body.gsub!(/#{Settings.host}\//, '/')
      Rails.logger.info(">>>> Removing microsite root path #{microsite.root_path} from response")
      body.gsub!(/#{microsite.root_path}/, '/')
      body.gsub!("href=\"'#{microsite.root_path}\"", '/')

      # If last char from root_path is '/' we have to replace links without this char too
      root_path_last_char = microsite.root_path[-1, 1]
      if root_path_last_char == '/'
        root_path_without_last_slash = microsite.root_path[0...-1]
        Rails.logger.info(">>>> Removing microsite root path without last slash #{root_path_without_last_slash} from response")
        body.gsub!("href=\"#{root_path_without_last_slash}\"", 'href="/"')
      end

      length += body.length
    end
    # If we are redirecting, we need to remove root path from redirection url too
    if status == 302
      new_location = headers["Location"].gsub!("#{request.host}#{microsite.root_path}", "#{request.host}/")
      headers["Location"] = new_location unless new_location.blank?
    end
    if response.respond_to? :header
      response.header["Content-Length"] = length.to_s
    end
  end

end
