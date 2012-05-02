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
    @app = Application.create_for_user(current_user)
    
    # Start generating personalised installer in new thread
    Thread.new do 
      SetupManagerInstance.build_setup @app
    end

    respond_to do |format|
      format.html
    end
  end

  def get_application_status
    app = Application.where('auth_token.user_id' => current_user.id, :id => params[:id]).first

    respond_to do |format|
      format.json { render json: app }
    end
  end

  def download
    
  end

  def upcoming_events
    events = @current_user.events_with_unaccepted_notificatins

    respond_to do |format|
      format.json { render json: events, include: [ :group, :category ] }
    end
  end

  def accept_notifications
    current_user.accept_notifications_for_events(params[:event_ids])
  end

  def groups
    groups = Group.find_readable_user_groups(@current_user)

    respond_to do |format|
      format.json { render json: groups }
    end
  end
end
