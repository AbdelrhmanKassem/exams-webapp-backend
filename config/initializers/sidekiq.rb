Sidekiq.configure_server do |config|
  config.redis = { url: Rails.application.config_for(:redis)[:url] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: Rails.application.config_for(:redis)[:url] }
end
