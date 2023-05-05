Rails.application.routes.draw do

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end

  # Add app APIs below
  get '/current_user', to: 'current_user#index'
  resources :users, only: %i[create index] do
    collection do
      post 'accept_invite'
    end
  end

  resources :schools, only: %i[create index]
  resources :students, only: %i[create index]
  resources :roles, only: %i[index]
  resources :branches, only: %i[index]
  resources :districts, only: %i[index create]
  resources :exams, only: %i[index create update show] do
    member do
      get 'generate_qr_codes'
    end
  end

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
    get '/exam' => 'exam_service#exam'
  end
end
