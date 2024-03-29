class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  has_many :auth_tokens
  has_many :configuration_values
  has_many :invitations
  has_many :groups
  has_many :events

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
    Event.find_user_events_within_period(self, Time.now, days_to_event.days.from_now)
  end

  def events_with_unaccepted_notifications
    days_to_event = configuration['events.notification_interval'].value.to_i
    Event.find_user_events_within_period_without_accepted_notifications(self, Time.now, days_to_event.days.from_now)
  end

  def readable_groups
    Group.find_readable_user_groups(self)
  end

  def accept_notifications_for_events(event_ids)
    events = Event.find_user_events(self).where('events.id' => event_ids) 
    events.each do |e|
      e.accept_notification_as(self)
    end
  end

  def configuration
    @config ||= Configuration.get_configuration_for_user(self)
  end
end
