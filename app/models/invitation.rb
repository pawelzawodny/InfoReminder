include Digest

class Invitation < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  # Creates invitation for specific app user
  def self.invite_user(group, user)
    invitation = group.invitations.new({ user_id: user.id })
    invitation.save
    invitation 
  end

  # Creates invitation with activation code which can be used by any user (even without account in application) 
  def self.invite_anonymous(group, lifetime)
    invitation = group.invitations.new({ lifetime_valid: lifetime })
    invitation.generate_activation_code
    invitation.save
    invitation
  end

  # Generates new activation code (MD5)
  def generate_activation_code
    self.activation_code = MD5.hexdigest(Time.now.to_s)
  end

  # Deletes invitation from database
  def accepted=(val)
    if(!self.lifetime_valid)
      self.destroy 
    end
  end

  # Checks whether it's anonymous invitation or invitation for specific user
  def is_anonymous?
    self.user_id.nil?
  end
end
