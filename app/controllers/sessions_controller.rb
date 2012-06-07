class SessionsController < ApplicationController
  skip_before_filter :ensure_login

  def new
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["info"]["user_id"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    session[:podio_access_token] = auth["credentials"]["token"]
    session[:podio_refresh_token] = auth["credentials"]["refresh_token"]
    redirect_to root_url, :notice => "Signed in!"
  end

  def create_from_app_auth
    Podio.setup(
      :api_url => 'https://api.podio.com',
      :api_key => ENV['PODIO_CLIENT_ID'],
      :api_secret => ENV['PODIO_CLIENT_SECRET']
    )

    Podio.client.authenticate_with_app(params[:app_id], params[:app_token])

    session[:podio_access_token] = Podio.client.oauth_token.access_token
    session[:podio_refresh_token] = Podio.client.oauth_token.refresh_token

    redirect_to root_url, :notice => "Signed in!"
  end

  def destroy
    session.clear
    redirect_to root_url, :notice => "Logged out!"
  end

end
