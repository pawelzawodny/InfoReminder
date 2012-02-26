class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  has_many :auth_tokens
  has_many :configuration_values

  #
  # Class methods
  #

  # Returns User object if token matches specified user_id
  # or it returns nil if there is no such user
  def self.verify_auth_token(user_id, token)
    User.includes(:auth_tokens).
    where(id: user_id, 'auth_tokens.token' => token).
    first
  end

  #
  # Instance methods
  #
  def upcoming_events
    days_to_event = configuration['events.notification_interval'].value.to_i
    Event.find_user_events(self).where(date: days_to_event.days.ago .. Time.now)
  end

  def configuration
    @config ||= Configuration.get_configuration_for_user(self)
  end
end
