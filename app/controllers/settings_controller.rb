class SettingsController < ApplicationController
  before_filter :authenticate_user!

  def show
    respond_to do |format|
      format.html
    end
  end

  def save
    params.each do |name, value|
      if current_user.configuration.has_key?(name)
        config = current_user.configuration[name]
        config.value = value

        if(config.modified?)
          config.configuration_value.save
        end
      end
    end

    redirect_to action: 'show'
  end
end
