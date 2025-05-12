# frozen_string_literal: true

class AddSubscriptionStatusToUsers < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_column :users, :subscription_status, :string, default: nil
    add_column :users, :subscription_status_last_updated_at, :datetime, default: nil
    add_index :users, :subscription_status, algorithm: :concurrently
  end
end