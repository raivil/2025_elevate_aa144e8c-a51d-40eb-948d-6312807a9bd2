# frozen_string_literal: true

RSpec.shared_examples 'a valid serializer' do |expected_attributes|
  it 'has the expected attributes' do
    serialization = ActiveModelSerializers::Adapter.create(serializer).as_json
    expect(serialization.keys).to match_array(expected_attributes)
  end
end
