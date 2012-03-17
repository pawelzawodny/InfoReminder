class SetupController < ApplicationController
  def prepare
    @app = Application.create_for_user(current_user)
    
    # Start generating personalised installer in new thread
    Thread.new do 
      SetupManagerInstance.build_setup @app
    end

    respond_to do |format|
      format.html
    end
  end

  def status
    app = Application.user_app(current_user, params[:id])

    render( json: app )
  end

  def download
    app = Application.user_app(current_user, params[:id])
    
    if(app.status == 'ready')
      send_file(
        app.setup_file, 
        :type => 'application/octet-stream',
        :filename => 'info-reminder-setup.exe'
      )
    end
  end
end
