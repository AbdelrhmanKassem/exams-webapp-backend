# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins AppConfig.client_url

    resource '*',
             headers: :any,
             methods: %i[get post put patch delete options head],
             expose: %w[Authorization]
  end

  allow do
    origins AppConfig.exams_service_url

    resource '/external/exam',
             headers: :any,
             methods: %i[get],
             expose: %w[X-API-KEY]
    resource '/external/today_exams',
             headers: :any,
             methods: %i[get],
             expose: %w[X-API-KEY]
  end
end
