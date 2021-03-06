require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)


module Myflix
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
    config.autoload_paths += %W(#{config.root}/lib)

    config.assets.enabled = true
    config.generators do |g|
      g.orm :active_record
      g.template_engine :haml
      g.stylesheets     false
      g.javascripts     false
      g.helper     false
      g.test_framework :rspec,
      fixtures: true,
      view_specs: false,
      helper_specs: false,
      routing_specs: false,
      controller_specs: true,
      request_specs: false
      g.fixture_replacement :fabrication, dir: "spec/fabricators"
    end
  end
end
