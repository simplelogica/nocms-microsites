require 'config'

module NoCms
  module Microsites
    class Engine < ::Rails::Engine
      isolate_namespace NoCms::Microsites

      initializer "microsites.middleware" do |app|
        app.config.app_middleware.use NoCms::Microsites::Micrositer
      end
    end
  end
end
