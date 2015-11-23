module NoCms::Microsites
  class Microsite < ActiveRecord::Base

    # Root needs to be translated because routes are different in each language
    translates :root_path

  end
end