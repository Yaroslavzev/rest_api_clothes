# frozen_string_literal: true

require "dry/system/container"

class AppContainer < Dry::System::Container
  configure do |config|
    config.root = Rails.root.join("app").to_s.freeze
    config.inflector = ActiveSupport::Inflector
    config.auto_register = %w[concepts services serializers]
  end

  load_paths!("concepts", "services", "serializers")
end

AppImport = AppContainer.injector

AppContainer.finalize!
