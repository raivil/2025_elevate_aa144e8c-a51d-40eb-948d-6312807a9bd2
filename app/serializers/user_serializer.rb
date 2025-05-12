# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :stats, :subscription_status

  delegate :stats, to: :object

  delegate :subscription_status, to: :object
end
