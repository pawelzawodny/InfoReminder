class ClientController < ApplicationController
  before_filter :authenticate_by_token, :except => :prepare_download
  before_filter :authenticate_user!, :only => :prepare_download

  def authenticate_by_token
    @current_user ||= session[:current_user]
    if(!params[:auth_token].nil? && !params[:user_id].nil?)
      @current_user = User.verify_auth_token(params[:user_id], params[:auth_token])
    end 

    if(!@current_user.nil?)
      session[:current_user] = @current_user
      true
    else
      redirect_to 'unauthorized'
    end
  end

  def prepare_download
    @token = AuthToken.create_for_user(current_user)
    respond_to do |format|
      format.html
    end
  end

  def upcoming_events
    events = @current_user.upcoming_events

    respond_to do |format|
      format.json { render json: events, include: [ :group, :category ] }
    end
  end

  def groups
    groups = Group.find_readable_user_groups(@current_user)

    respond_to do |format|
      format.json { render json: groups }
    end
  end
end
