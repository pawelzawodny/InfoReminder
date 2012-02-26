class Configuration < ActiveRecord::Base
  has_many :configuration_values
  belongs_to :configuration_type

  attr_accessor :configuration_value

  def self.get_configuration
    @config ||= Configuration.joins(:configuration_type).all
  end

  def self.get_configuration_for_user(user)
    values = ConfigurationValue.where('user_id = ?', user.id).all
    user_config = Hash.new
    Configuration.get_configuration.each do |k|
      val = values.find do |v|
        v.configuration_id == k.id
      end
      val ||= ConfigurationValue.new(user_id: user.id, configuration_id: k.id) 

      config = k.clone
      config.configuration_value = val
      user_config[config.name] = config
    end
    user_config
  end

  def modified?
    self.configuration_value.changed?
  end

  def modified
    modified?
  end
 
  def value=(val)
    self.configuration_value.value = val
  end

  def value
    self.configuration_value.value
  end
end
