module Spina
  module News
    class Engine < ::Rails::Engine
      isolate_namespace Spina::News

      initializer "register plugin" do
        ::Spina::Plugin.register do |plugin|
          plugin.name = "news"
          plugin.namespace = 'news'
        end
      end

      config.generators do |g|
        g.test_framework :rspec, fixture: false
        g.fixture_replacement :factory_girl, dir: 'spec/factories'
        g.assets false
        g.helper false
      end

    end
  end
end
