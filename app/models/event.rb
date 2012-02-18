class Event < ActiveRecord::Base
  belongs_to :group
  belongs_to :category

  # Returns query used to find events available to specified user
  def self.find_user_events(user) 
    groups = Group.find_readable_user_groups(user)

    group_ids = groups.map do |g|
      g.id
    end 

    Event.where(group_id: group_ids).order('date DESC') 
  end
end
