module SettingsHelper
  def text_configuration_field(config)
    text_field_tag(
      config.name, 
      config.value, 
      { 'data-tooltip' => t(config.description)}
    )
  end

  def configuration_field(config)
    method = config.configuration_type.helper_method 
    send(method.to_sym, config)
  end
end
