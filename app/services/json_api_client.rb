# frozen_string_literal: true

class JsonApiClient
  class RequestError < Faraday::Error; end

  def initialize(url, default_headers = {}, debug: false)
    @connection = Faraday.new(url: url, headers: default_headers.merge({ "Accept" => "application/json" })) do |f|
      f.request :json
      # This middleware is used to raise an exception when the response is not a 2xx
      # and needs to be before the json middleware so the error response can be parsed
      f.response :raise_error
      f.response :json
      f.adapter :net_http
      f.response :logger, Rails.logger, bodies: true, log_level: :debug if debug.present?
    end
  end

  %i(get post patch put delete).each do |verb|
    define_method(:"raw_#{verb}") do |*args, &block|
      @connection.public_send(verb, *args, &block)
    rescue Faraday::Error => e
      raise RequestError.new(e, e.response)
    end

    define_method(verb) do |*args, &block|
      process(public_send(:"raw_#{verb}", *args, &block))
    end
  end

  def process(response)
    if ok?(response) && response.body.present?
      response.body
    elsif ok?(response)
      response.status
    end
  end

  def ok?(response)
    (200..299).cover?(response.status)
  end
end
