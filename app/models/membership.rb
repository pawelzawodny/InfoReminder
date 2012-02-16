class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  def self.public(params)
    membership = Membership.new params
    membership.read = false 
    membership.write = false
    membership.manage = false
    membership
  end

end
