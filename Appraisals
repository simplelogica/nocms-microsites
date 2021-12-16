ruby_version = Gem::Version.new(RUBY_VERSION)

ruby_2_5_0 = Gem::Version.new('2.5.0')

if ruby_version < ruby_2_5_0

  appraise "rails-4-2-5" do
    gem "rails", "4.2.5"
  end

  appraise "rails-5-2-3" do
    gem "rails", "5.2.3"
    gem "globalize", '~> 5.2.0'
    gem 'activeresource'
  end
end

appraise "rails-6-1-4-1" do
  gem "rails", "6.1.4.1"
  gem "globalize", '~> 6.0.1'
  gem 'activeresource'
end
