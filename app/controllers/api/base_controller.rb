# frozen_string_literal: true

class Api::BaseController < ApplicationController
    before_action :authenticate_user!

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

  # Override authenticate_user! to provide a JSON response for API requests
  def authenticate_user!
    if request.headers["Authorization"].present?
      authenticate_with_token
    else
      render json: { error: "You need to sign in or sign up before continuing." }, status: 401
    end
  end

  private

    # TODO: This is a temporary solution to authenticate the user. Need to investigate why devise-jwt is not working.
    def authenticate_with_token
      token = request.headers["Authorization"].split(" ").last
      payload = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!, true, algorithm: "HS256")[0]
      @current_user = User.find(payload["sub"])
    rescue JWT::ExpiredSignature
      render json: { error: "Authentication token has expired" }, status: 401
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: "Invalid authentication token" }, status: 401
    end

    def current_user
      @current_user ||= super
    end

    def not_found
      render json: { error: "Record not found" }, status: 404
    end
end
