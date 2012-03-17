class Application < ActiveRecord::Base
  belongs_to :auth_token

  # Returns path to installation file (escapes dangerous things etc :) )
  def setup_file
    self.setup_path 
  end

  # Finds user application by id
  def self.user_app(user, id)
    Application.includes(:auth_token).where('auth_tokens.user_id' => user.id, :id => id).first
  end

  # Creates application in database along with auth token
  def self.create_for_user(user)
    auth_token = AuthToken.create_for_user(user)
    app = Application.create({ auth_token_id: auth_token.id })
  end
end
