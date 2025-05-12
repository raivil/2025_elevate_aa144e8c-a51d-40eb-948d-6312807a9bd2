# frozen_string_literal: true

class AddCounterCacheToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :count_of_game_events, :integer, default: 0, null: false
  end
end
