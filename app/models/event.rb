class Event < ActiveRecord::Base
  belongs_to :group
  belongs_to :category

  validates_presence_of :title, :date, :group_id

  def is_owner?(user)
    self.user_id == user.id
  end

  def can_write?(user)
    is_owner?(user) || group.can_manage?(user)
  end

  def can_read?(user)
    is_owner?(user) || group.can_read?(user)
  end

  def can_delete?(user)
    is_owner?(user) || group.can_manage?(user)
  end

  # Returns query used to find events available to specified user
  def self.find_user_events(user) 
    groups = Group.find_readable_user_groups(user)

    group_ids = groups.map do |g|
      g.id
    end 

    Event.where(group_id: group_ids).order('date DESC') 
  end

  def self.find_user_events_within_period(user, start_date, end_date) 
    where = self.prepare_period_statement(start_date, end_date)
    query = self.find_user_events(user)

    if where.nil?
      return query
    end

    query.where(
      where, 
      { 
        start_date: start_date, 
        end_date: end_date
      }
    )
  end

  private

  def self.prepare_period_statement(start_date, end_date)
    if !start_date.nil?
      query = "events.date >= :start_date"
    end

    if !end_date.nil?
      query = !query.nil? ? "#{query} AND " : ""
      query += "events.date <= :end_date"
    end

    query
  end
end
