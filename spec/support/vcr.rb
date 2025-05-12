# frozen_string_literal: true

require "vcr"

class VCR::SpecHelper
  CASSETTE_METADATA = %i(erb match_requests_on).freeze
  DEFAULT_METADATA = {
    match_requests_on: %i(method uri)
  }.freeze

  # Hosts need to be an array and metadata is the VCR metadata to be used
  def self.configure_request(hosts, metadata)
    metadata = (metadata || {}).merge(DEFAULT_METADATA) if metadata.nil?

    VCR.configure do |config|
      config.around_http_request(->(req) { req.uri =~ /#{Regexp.union(hosts)}/ }) do |request, _response|
        cassette_name = request.uri.clone
        # Only replace cassette if it is using different name and metadata
        if current_cassette?(cassette_name, metadata)
          request.proceed
        else
          VCR.eject_cassette # Avoid nesting multiple of the same cassette
          VCR.use_cassette(cassette_name, metadata, &request)
        end
      end
    end
  end

  def self.current_cassette?(cassette_name, cassette_metadata)
    VCR&.current_cassette&.name == cassette_name &&
      VCR::SpecHelper::CASSETTE_METADATA.all? { |k| VCR&.current_cassette&.send(k) == cassette_metadata[k] }
  end
end

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = false
  config.configure_rspec_metadata!
  config.cassette_library_dir = File.join(%w(spec fixtures vcr))
  config.hook_into :webmock, :faraday
  # For debugging uncomment this line
  # config.debug_logger = $stdout
  config.default_cassette_options = {
    record: :none, # Change to :once or :new_episodes if you add new end-points that need a cassette to be recorded
    allow_playback_repeats: true,
    decode_compressed_response: true,
    erb: VCR::SpecHelper::DEFAULT_METADATA[:erb]
  }
end
