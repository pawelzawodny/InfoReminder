class SettingsController < ApplicationController
  before_filter :authenticate_user!

  def show
    respond_to do |format|
      format.html
    end
  end

  def save
        
  end
end
