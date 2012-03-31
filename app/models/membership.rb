class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  # Creates read only membership
  def self.new_read_only(params)
    membership = Membership.new params
    membership.read = true 
    membership.write = false
    membership.manage = false
    membership
  end

  # Creates membership with right to read and write
  def self.new_read_write(params)
    membership = Membership.new params
    membership.read = true
    membership.write = true
    membership.manage = true
  end

  # Creates membership with right to read, write and manage
  def self.new_manager(params)
    membership = Membership.new params
    membership.read = true
    membership.write = true
    membership.manage = true
  end
end
