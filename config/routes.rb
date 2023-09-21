Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq' do 
    use Rack::Protection, use: :authenticity_token
  end
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'


  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end

  # Add app APIs below
  get '/current_user', to: 'current_user#index'
  resources :users, only: %i[create index destroy] do
    collection do
      post 'accept_invite'
    end
  end

  resources :schools, only: %i[create index destroy]
  resources :students, only: %i[create index destroy] do
    post '/bulk_upload', action: :bulk_upload, on: :collection
  end

  resources :roles, only: %i[index]
  resources :branches, only: %i[index create destroy]
  resources :districts, only: %i[index create destroy] do
    get 'list', on: :collection
  end
  resources :exams, only: %i[index create update show destroy] do
    get 'generate_qr_codes/:id/:district_id', action: :generate_qr_codes, on: :collection
    get 'in_progress', action: :in_progress, on: :collection
  end
  resources :cheat_cases, only: %i[index create]

  devise_for :users,
             path: 'users',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout'
             },
             controllers: {
               sessions: 'users/sessions'
             },
             defaults: { format: :json }


  namespace :external do
    get '/exam' => 'exams_service#exam'
    get '/today_exams' => 'exams_service#today_exams'
  end
end
