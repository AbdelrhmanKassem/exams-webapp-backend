Rails.application.routes.draw do

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end

  # Add app APIs below
  get '/current_user', to: 'current_user#index'
  resources :users, only: %i[create] do
    collection do
      post 'accept_invite'
    end
  end

  resources :schools, only: %i[create]
  resources :students, only: %i[create]

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
end
