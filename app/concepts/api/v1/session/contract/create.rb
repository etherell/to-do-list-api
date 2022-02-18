# frozen_string_literal: true

module Api::V1::Session::Contract
  Create = Dry::Validation.Schema do
    configure { config.namespace = :user }

    required(:username).filled(:str?, size?: Constants::Shared::USERNAME_SIZE_RANGE)
    required(:password).filled(:str?, format?: Constants::Shared::PASSWORD_REGEXP)
  end
end
