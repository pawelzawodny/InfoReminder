class AuthToken < ActiveRecord::Base
  belongs_to :user

  # Creates authentication token in database and returns object
  def self.create_for_user(user)
    token = Digest::SHA1.new(Time.now + user.id)
    auth_obj = AuthToken.create({ 
      token: token.to_s,
      user_id: user.id
    })
  end
end
