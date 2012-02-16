class Group < ActiveRecord::Base
  has_many :events
  has_many :categories, :through => :group_categories
  has_many :group_categories
  has_many :users, :through => :membership, :as => :members
  has_many :memberships

  def self.find_owned_user_groups(user)
    Group.where(user_id: user.id)
  end

  def self.find_user_groups(user)
    find_owned_user_groups(user).includes(:memberships).where(:or => { 'memberships.user_id' => user.id }) 
  end

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
