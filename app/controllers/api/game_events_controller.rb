# frozen_string_literal: true

class Api::GameEventsController < Api::BaseController
  before_action :authenticate_user!

  def create
    @game_event = current_user.game_events.new(game_event_params.except(:type))

    # Handle the 'type' parameter specially since it's a reserved word in Rails
    @game_event.event_type = game_event_params[:type] if game_event_params[:type].present?

    if @game_event.save
      render json: @game_event, status: 201
    else
      render json: { errors: @game_event.errors }, status: :unprocessable_entity
    end
  end

  private

  def game_event_params
    params.require(:game_event).permit(:game_name, :type, :occurred_at)
  end
end
