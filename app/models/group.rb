class Group < ActiveRecord::Base
  has_many :events
  has_many :categories, :through => :group_categories
  has_many :group_categories
  has_many :users, :through => :membership, :as => :members
  has_many :memberships

  # Finds groups which were created by user (only created by!)
  # See also find_user_groups
  def self.find_owned_user_groups(user)
    Group.where(user_id: user.id)
  end

  # Finds groups which were created by user or user has joined as member
  def self.find_user_groups(user)
    groups = Group.includes(:memberships).
    where('groups.user_id = ? OR memberships.user_id = ?', user.id, user.id)
    
  end

  # Finds user groups categorised by membership type (groups in which user is member and owner)
  def self.find_user_groups_categorised_by_membership(user)
    groups = Group.find_user_groups(user).group_by do |g|
      g.user_id == user.id ? :owner : :member 
    end
    groups[:owner] ||= Hash.new
    groups[:member] ||= Hash.new

    groups
  end

  # Finds groups which are readable for specified user
  def self.find_readable_user_groups(user)
    Group.find_user_groups(user).select do |g|
      g.user_id == user.id || g.membership(user).read || g.public
    end
  end

  # Returns membership object associated with user
  def membership(user)
    memberships.find do |m|
      m.user_id == user.id
    end
  end

  # Checks whether user is owner of this group
  def is_owner?(user)
    self.user_id == user.id 
  end

  # Alias for is_owner?
  def is_owner(user)
    is_owner? user
  end

  # Checks whether user is member of this group
  def is_member?(user)
    (m = membership(user)) && m.user_id == user.id
  end

  # Alias for is_member?
  def is_member(user) 
    is_member? user
  end

  # Checks whether user can read events within this group
  def can_read?(user)
    self.public || is_owner?(user) || (is_member?(user) && membership(user).read)
  end

  # alias for can_read?
  def can_read(user)
    can_read? user
  end

  # Checks whether user can write to this group
  def can_write?(user)
    is_owner?(user) || (is_member?(user) && membership(user).write)
  end

  # alias for can_write?
  def can_write(user)
    can_write? user
  end

  # Checks whether user can post events within this group
  def can_post_events?(user)
    can_write? user
  end

  # alias for can_post_events?
  def can_post_events(user)
    can_post_events? user
  end

  # checks whether user can join this group
  def can_join?(user) 
    self.public && membership(user).nil?
  end

  # alias for can_join?
  def can_join(user)
    can_join? user
  end

  # Checks whether user can leave this group
  def can_leave?(user)
    !membership(user).nil?
  end

  # Adds events category
  def add_category(category)
    GroupCategory.transaction do
      if category.save 
        GroupCategory.create({
          category_id: category.id,
          group_id: id
        })
      end
    end
  end

  # Adds user membership to group (Only if it's public group or user has invitation)
  def add_member(user)
    if self.public 
      m = Membership.public({ 
        group_id: id,
        user_id: user.id
      })
      m.save
    else
      false
    end
  end
end
