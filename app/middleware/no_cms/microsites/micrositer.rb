class NoCms::Microsites::Micrositer
  def initialize(app)
    @app = app
    @default_host = Settings.default_host
  end
  
  def call(env)
    request = Rack::Request.new(env)

    if request.host != @default_host
      # If request host is not the default one, we have to treat this request
      Rails.logger.info(">>> request host is #{request.host} and default host is #{@default_host}")

      # If request starts by assets or locale/assets, do not change path
      unless request.path.match("#{not_redirected_routes.join('|')}")
        Rails.logger.info(">>> We have to replace the route, the path is #{request.path}")
        replace_route_for request, env
      end
    end
    status, headers, response = @app.call(env)
    [status, headers, response]
  end
  
  private

  # Searches a microsite by domain and calls to remap request
  # with microsite root path
  def replace_route_for request, env
    microsite = NoCms::Microsites::Microsite.find_by_domain(request.host)
    
    unless microsite.blank?
      Rails.logger.info(">>> Previous request path was #{env["PATH_INFO"]} and microsite root path is #{microsite.root_path}")
      env["PATH_INFO"] = remap_paths_with_locales(microsite.root_path, env["PATH_INFO"],)
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
  def remap_paths_with_locales(root_path, request_path)
    locales = []
    I18n.available_locales.each do |locale|
      locales << "^(\/#{locale.to_s}\/)"
    end

    # if request comes with locale, we maintain it in new request
    if request_path.match(locales.join('|'))
      locale = request_path.at(0..3)
      path = "#{locale}#{root_path}/#{request_path.remove(locale)}"
    else
      path = "#{root_path}#{request_path}"
    end

    path
  end
  
end