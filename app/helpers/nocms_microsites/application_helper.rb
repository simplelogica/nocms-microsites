module NoCms::Microsites
  module ApplicationHelper
    # Method used to clean urls if we are drawing a url from a microsite host
    # so we can draw urls removing "microsite root"
    def clean_for_microsites url
      host = request.host
      microsite = NoCms::Microsites::Microsite.find_by_domain(host)
      unless microsite.blank?
        url = url.gsub(microsite.root_path, "")
      end
      url
    end

  end
end
