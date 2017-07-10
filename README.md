# NoCMS Microsites

## What's this?

Gem to add NoCMS support for many domains sharing the same routes or with sub-sets of them. As it's a middleware and it doesn't need any NoCMS feature, you can use it in any Rails application.

## How do I install it?

Just include in your Gemfile:

```ruby
gem "nocms-microsites", git: 'git@github.com:simplelogica/nocms-microsites.git', branch: 'master'
```

Once the gem is installed you can import all the migrations:

```
rake no_cms_microsites:install:migrations
```

Set your default domain with key ```host```, for example for your ```myapplication.com```, set in your ```config/production.yml```:

```host: http://myapplication.com```

Configure your accepted "microsites" or alternative domains for your app. You can see several examples in next section.

## How does it works?

Each request is treated by ```Micrositer``` middleware. If request comes from an existing ```Iberostar::Cms::Microsite``` domain, it generates the response as if it had been called the default host with current locale ```root_path``` chosen for that microsite.

After create the response, it changes all links to fit new microsite root path, so it changes all root path occurrences in code with '/'.

# Examples

## Domain for german specific application

If we want to offer a german version of our application and return myapplication.com/de responses, we have to create a new microsite:

```ruby
microsite = Iberostar::Cms::Microsite.new
microsite.title = "German domain"
microsite.domain = "deutchapplication.com"
I18n.available_locale.each do |locale|
  I18n.with_locale(locale) do
    microsite.root_path = '/de/'
  end
end

microsite.save
```

When we receive a request for ```deutchapplication.com``` our application will return the response from ```http://myapplication.com/de/``` but changing all ```/de/``` ocurrences with '/'.

## Domain for '/specific-content/'

If we want to offer specific content from a path inside of our application :

```ruby
microsite = Iberostar::Cms::Microsite.new
microsite.title = "Specific content domain"
microsite.domain = "myappspecificcontent.com"
I18n.with_locale(:en) do
  microsite.root_path('/specific-content/')
end

I18n.with_locale(:es) do
  microsite.root_path('/contenido-especifico/')
end

microsite.save
```

When we receive a request for ```myappspecificcontent.com``` in english our application will return the response from ```http://myapplication.com/specific-content/``` but changing all ```/specific-content/``` ocurrences with '/'. If we call ```myappspecificcontent.com/es/``` it will return ```http://myapplication.com/es/contenido-especifico/```
