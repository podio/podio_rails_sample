class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :ensure_login

  protected

    def ensure_login
      if session[:podio_access_token]
        init_podio_client
      else
        redirect_to new_session_path
      end
    end

    def init_podio_client
      Podio.setup(
        :api_url => 'https://api.podio.com',
        :api_key => ENV['PODIO_CLIENT_ID'],
        :api_secret => ENV['PODIO_CLIENT_SECRET'],
        :oauth_token => Podio::OAuthToken.new('access_token' => session[:podio_access_token], 'refresh_token' => session[:podio_refresh_token])
      )
    end
end
