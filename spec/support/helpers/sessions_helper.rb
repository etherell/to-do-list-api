# frozen_string_literal: true

module Helpers
  module SessionsHelper
    def create_token(entity:, token_type: nil)
      entity_type = entity.class.to_s.underscore
      payload = { "#{entity_type}_id".to_sym => entity.id }
      tokens = JWTSessions::Session.new(payload: payload, refresh_payload: payload).login
      return tokens[token_type] if token_type

      tokens
    end
  end
end
