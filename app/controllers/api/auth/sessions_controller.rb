# frozen_string_literal: true

class Api::Auth::SessionsController < Devise::SessionsController
    respond_to :json

    private

    def respond_with(resource, _opts = {})
      render json: {
        status: { code: 200, message: "Logged in successfully." },
        data: UserSerializer.new(resource).as_json
      }
    end

    def respond_to_on_destroy
      jwt_payload = JWT.decode(request.headers["Authorization"].split[1],
                               Rails.application.credentials.fetch(:secret_key_base)).first
      current_user = User.find(jwt_payload["sub"])

      if current_user
        render json: {
          status: 200,
          token: jwt_payload,
        }
      else
        render json: {
          status: 401,
          message: "Couldn't find an active session."
        }, status: 401
      end
    end
end
