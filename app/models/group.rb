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
    Group.includes(:memberships).
    where('groups.user_id = ? OR memberships.user_id = ?', user.id, user.id)
  end

  # Finds groups which are readable for specified user
  def self.find_readable_user_groups(user)
    Group.find_user_groups(user).select do |g|
      g.user_id == user.id || g.membership.read || g.public
    end
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
