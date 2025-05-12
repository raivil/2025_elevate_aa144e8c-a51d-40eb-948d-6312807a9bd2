# frozen_string_literal: true

class Api::BaseController < ApplicationController
    before_action :authenticate_user!

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    private

    def not_found
      render json: { error: "Record not found" }, status: 404
    end
end
