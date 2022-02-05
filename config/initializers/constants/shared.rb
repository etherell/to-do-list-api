# frozen_string_literal: true

module Constants
  module Shared
    HMAC_SECRET = Rails.env.test? ? 'test' : Rails.application.credentials.secret_jwt_encryption_key
    USERNAME_SIZE = 3..50
    PASSWORD_REGEXP = /^[A-Za-z0-9]+$/.freeze
    PASSWORD_SIZE = 8
  end
end
