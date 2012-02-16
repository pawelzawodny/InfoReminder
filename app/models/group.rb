class Group < ActiveRecord::Base
  has_many :events
  has_many :categories, :through => :group_categories
  has_many :group_categories

  def self.find_user_groups(user)
    Group.where(user_id: user.id).all
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
end
