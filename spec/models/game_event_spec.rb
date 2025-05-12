# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameEvent, type: :model do
  let(:user) { create(:user) }

  it 'is valid with valid attributes' do
    game_event = build(:game_event, user: user)
    expect(game_event).to be_valid
  end

  it 'is not valid without a user' do
    game_event = build(:game_event, user: nil)
    expect(game_event).not_to be_valid
  end

  it 'is not valid without a game_name' do
    game_event = build(:game_event, user: user, game_name: nil)
    expect(game_event).not_to be_valid
  end

  it 'is not valid without an event_type' do
    game_event = build(:game_event, user: user, event_type: nil)
    expect(game_event).not_to be_valid
  end

  it 'is not valid with an event_type other than COMPLETED' do
    game_event = build(:game_event, user: user, event_type: 'STARTED')
    expect(game_event).not_to be_valid
  end

  it 'is not valid without occurred_at' do
    game_event = build(:game_event, user: user, occurred_at: nil)
    expect(game_event).not_to be_valid
  end

  it 'belongs to a user' do
    association = described_class.reflect_on_association(:user)
    expect(association.macro).to eq :belongs_to
  end

  describe 'counter cache' do
    it 'increments user counter_cache on create' do
      expect {
        create(:game_event, user: user)
      }.to change { user.reload.count_of_game_events }.by(1)
    end

    it 'decrements user counter_cache on destroy' do
      game_event = create(:game_event, user: user)
      expect {
        game_event.destroy
      }.to change { user.reload.count_of_game_events }.by(-1)
    end

    it 'updates user counter_cache when reassigning to another user' do
      other_user = create(:user)
      game_event = create(:game_event, user: user)

      expect {
        game_event.update(user: other_user)
      }.to change { user.reload.count_of_game_events }.by(-1)
                                                      .and change { other_user.reload.count_of_game_events }.by(1)
    end
  end
end
