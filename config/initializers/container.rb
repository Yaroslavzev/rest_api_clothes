require 'dry/system/container'

class AppContainer < Dry::System::Container
  configure do |config|
    config.root = Rails.root.join('app').to_s.freeze
    config.inflector = ActiveSupport::Inflector
    config.auto_register = %w(concepts)
  end

  load_paths!('concepts')
end

AppImport = AppContainer.injector

AppContainer.finalize!

