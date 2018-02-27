module NoCms
  module Microsites
    include ActiveSupport::Configurable

    config_accessor :default_host

    self.default_host ||= ""

  end
end
