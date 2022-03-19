# frozen_string_literal: true

module Helpers
  module SessionsHelper
    def create_token(entity:, token_type:)
      entity_type = entity.class.to_s.underscore
      payload = { "#{entity_type}_id".to_sym => entity.id }
      JWTSessions::Session.new(payload: payload, refresh_payload: payload).login[token_type]
    end
  end
end
