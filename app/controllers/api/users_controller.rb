# frozen_string_literal: true

class Api::UsersController < Api::BaseController
    skip_before_action :authenticate_user!, only: [ :create ]

    # GET /api/users/me
    def me
      render json: current_user
    end

    # POST /api/users
    def create
      @user = User.new(user_params)

      if @user.save
        render json: @user, status: 201
      else
        render json: { errors: @user.errors }, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name)
    end
end
