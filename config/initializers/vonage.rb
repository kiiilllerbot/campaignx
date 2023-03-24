require 'vonage'

Vonage.configure do |config|
  config.api_key = ENV['VONAGE_API_KEY']
  config.api_secret = ENV['VONAGE_API_SECRET']
  config.signature_secret = ENV['VONAGE_SIGNATURE_SECRET']
  config.signature_method = ENV['VONAGE_SIGNATURE_METHOD']
end
