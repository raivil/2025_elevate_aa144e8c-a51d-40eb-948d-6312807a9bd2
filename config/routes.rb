Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users,
             controllers: {
               sessions: 'api/auth/sessions',
               registrations: 'api/auth/registrations'
             },
             path: 'api',
             path_names: {
               sign_in: 'sessions',
               sign_out: 'logout',
               registration: 'user'
             }

  namespace :api do
    namespace :v1 do
      get 'users/me', to: 'users#me'

      resources :notifications do
        member do
          patch :mark_as_read
        end
      end
    end
  end
end