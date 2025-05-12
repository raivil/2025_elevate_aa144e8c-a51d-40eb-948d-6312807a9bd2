# frozen_string_literal: true

class Api::Auth::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        status: { code: 201, message: "Signed up successfully." },
        data: UserSerializer.new(resource).as_json
      }
    else
      render json: {
        status: { message: "User couldn't be created. #{resource.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end

  protected

  def set_flash_message!(*args)
    # no flash in API mode
  end
end
