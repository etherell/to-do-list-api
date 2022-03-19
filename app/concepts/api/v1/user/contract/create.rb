# frozen_string_literal: true

module Api::V1::User::Contract
  class Create < ApplicationContract
    property :username
    property :password
    property :password_confirmation, virtual: true

    validation :default do
      configure { config.namespace = :user }

      required(:username).filled(:str?)
      required(:password).filled(:str?)
      required(:password_confirmation).filled(:str?)
    end

    validation :size_and_format, if: :default do
      configure { config.namespace = :user }

      required(:username).filled(:str?, size?: Constants::Shared::USERNAME_SIZE_RANGE)
      required(:password).filled(:str?, format?: Constants::Shared::PASSWORD_REGEXP).confirmation
      required(:password_confirmation).filled(:str?)
    end

    validation :uniqueness, if: :size_and_format do
      configure do
        option :form
        config.namespace = :user

        def username_unique?(value)
          !User.where.not(id: form.model.id).exists?(username: value)
        end
      end

      required(:username, &:username_unique?)
    end
  end
end
