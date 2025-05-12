# frozen_string_literal: true

class Api::UsersController < Api::BaseController
  before_action :authenticate_user!
  def show
    render json: { user: UserSerializer.new(current_user) }
  end
end
