# frozen_string_literal: true

module Api::V1::User::Serializer
  class Create < ApplicationSerializer
    attributes :username
    set_type :user_account
  end
end
