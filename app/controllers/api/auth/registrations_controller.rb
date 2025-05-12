# frozen_string_literal: true

class Api::Auth::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  # Override sign_up_params to handle flat params (no 'user' key)
  def sign_up_params
    params.permit(:email, :password)
  end

  # Override create to match the response format from UsersController
  def create # rubocop:disable Metrics/AbcSize
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      render json: resource, status: 201
    else
      clean_up_passwords resource
      set_minimum_password_length
      render json: { errors: resource.errors }, status: :unprocessable_entity
    end
  end

  protected

  def set_flash_message!(*args)
    # no flash in API mode
  end
end
