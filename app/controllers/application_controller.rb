class ApplicationController < ActionController::Base
  protect_from_forgery

  # Fetches group object from database and makes it accessible in views through @group
  def fetch_group
    @group = Group.find params[:group_id] unless params[:group_id].nil?
  end

  def authenticate_client
    if !params[:auth_token].nil? && !params[:user_id].nil?
      auth = AuthToken.where(user_id: params[:user_id], token: params[:auth_token]).first
      if(!auth.nil?)
        @current_user = auth.user
      end
    end
  end
end
