Rails.application.config.middleware.use OmniAuth::Builder do
  provider :podio, ENV['PODIO_CLIENT_ID'], ENV['PODIO_CLIENT_SECRET']
end