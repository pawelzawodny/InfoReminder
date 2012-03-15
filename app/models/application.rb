class Application < ActiveRecord::Base
  belongs_to :auth_token

  # Creates application in database along with auth token
  def self.create_for_user(user)
    auth_token = AuthToken.create_for_user(user)
    app = Application.create({ auth_token_id: auth_token.id })
  end
end
