# frozen_string_literal: true

module Constants
  module Shared
    HMAC_SECRET = Rails.env.test? ? 'test' : Rails.application.credentials.secret_jwt_encryption_key
    USERNAME_SIZE_RANGE = 3..50
    PASSWORD_REGEXP = /^[A-Za-z0-9]{8}$/.freeze
    PASSWORD_SIZE = 8
    PROJECT_TITLE_SIZE_RANGE = 3..75
  end
end
