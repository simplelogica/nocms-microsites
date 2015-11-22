module NoCms
  module Microsites
    class Engine < ::Rails::Engine
      isolate_namespace NoCms::Microsites
    end
  end
end
