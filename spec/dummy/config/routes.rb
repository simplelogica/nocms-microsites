Rails.application.routes.draw do

  mount NoCms::Microsites::Engine => "/nocms-microsites"
end
