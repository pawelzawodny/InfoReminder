class Category < ActiveRecord::Base
  has_many :groups, :through => :group_categories
end
