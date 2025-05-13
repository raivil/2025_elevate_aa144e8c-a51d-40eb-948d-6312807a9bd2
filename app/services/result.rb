# frozen_string_literal: true

class Result
  attr_reader :success, :data, :error

  def initialize(success, data = nil, error = nil)
    @success = success
    @data = data
    @error = error
  end

  def success?
    @success
  end

  def failure?
    !@success
  end
end
