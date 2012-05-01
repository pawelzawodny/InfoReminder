class AcceptedNotification < ActiveRecord::Base
  def self.notifications_for_user(user)
    self.where(user_id: user.id, date: 1.days.ago .. Time.now)
  end
end
