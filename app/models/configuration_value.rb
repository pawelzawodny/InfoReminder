class ConfigurationValue < ActiveRecord::Base
  belongs_to :configuration
  belongs_to :user
end
