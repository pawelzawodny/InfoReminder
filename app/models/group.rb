class Group < ActiveRecord::Base
  has_many :events

  def self.find_user_groups(user)
    Group.where(user_id: user.id).all
  end
end
