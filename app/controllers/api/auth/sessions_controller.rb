# frozen_string_literal: true

class Api::Auth::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    self.resource = User.find_by(email: params[:email])

    if resource&.valid_password?(params[:password])
      # For API, don't use sessions - just generate and return a token
      token = generate_jwt_token(resource)
      render json: { token: token }, status: 200
    else
      render json: { error: "Invalid email or password" }, status: 401
    end
  end

  # Override the parent method to handle JSON errors
  def respond_to_on_destroy
    head 204
  end

  private

  def generate_jwt_token(user)
    JWT.encode(
      { sub: user.id, exp: 24.hours.from_now.to_i },
      Rails.application.credentials.devise_jwt_secret_key!
    )
  end
end
