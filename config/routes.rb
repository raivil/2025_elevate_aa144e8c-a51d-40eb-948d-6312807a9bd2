Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Configure Devise routes with custom controllers
  devise_for :users,
             controllers: {
               sessions: "api/auth/sessions",
               registrations: "api/auth/registrations"
             },
             path: "api",
             path_names: {
               sign_in: "sessions",
               registration: "user"
             },
             # Skip password and other routes we don't need
             skip: [ :passwords ]

  namespace :api do
    # User details and stats
    get "user", to: "users#show"

    # Game events route
    post "user/game_events", to: "game_events#create"
  end
end
