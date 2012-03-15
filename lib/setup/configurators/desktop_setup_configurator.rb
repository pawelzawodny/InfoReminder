require 'rexml/document'
include REXML

class DesktopSetupConfigurator < AbstractConfigurator
  def configure(setup_path, params)
    config_path = "#{setup_path}/#{options['config_file']}"
    config = load_config_file(config_path)

    update_credentials(config, params[:credentials])
    save_config_file(config, config_path)
  end

  protected 
  def update_credentials(doc, cred)
    cred_elem = XPath.first(doc,"//infoReminder/clientCredentials")
    cred_elem.add_attribute("userId", cred[:user_id])
    cred_elem.add_attribute("username", cred[:username])
    cred_elem.add_attribute("authToken", cred[:auth_token])
  end

  def load_config_file(config_path)
    xml_file = File.open(config_path)
    config = Document.new(xml_file)
    xml_file.close

    config
  end

  def save_config_file(config, config_path)
    xml_file = File.new(config_path, "w")
    Formatters::Default.new.write(config, xml_file)
    xml_file.close
  end
end
