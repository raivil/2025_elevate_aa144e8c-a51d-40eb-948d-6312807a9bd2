# frozen_string_literal: true

class BaseService
  class ServiceError < StandardError; end

  private

  def success(data = nil)
    Result.new(true, data)
  end

  def failure(error)
    Result.new(false, nil, error)
  end

  # FIXME: handles the first raised error, which is not ideal and may hide other errors.
  def handle_service_error(error, message, error_class = ServiceError)
    Rails.logger.error("#{message}: #{error.message}")
    raise error_class, message
  end
end
