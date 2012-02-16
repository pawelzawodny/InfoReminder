class ApplicationController < ActionController::Base
  protect_from_forgery

  # Fetches group object from database and makes it accessible in views through @group
  def fetch_group
    @group = Group.find params[:group_id] unless params[:group_id].nil?
  end

end
