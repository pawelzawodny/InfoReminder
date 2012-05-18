class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :pick_layout
  before_filter :set_locale
  
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
  
  private
  def pick_layout
    if params[:nolayout] == 'true'
      false
    else
      'application'
    end
  end
  
  def set_locale
    # jeżeli params[:locale] jest puste, zostanie użyta wartość I18n.default_locale
    if !params[:locale].nil?
      locale = params[:locale]
    elsif session[:locale]
      locale = session[:locale]
    elsif
      locale = I18n.locale
    end 

    I18n.locale = locale
    session[:locale] = locale
  end
end
