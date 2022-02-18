# frozen_string_literal: true

module Api::V1::Lib::Service
  class Session
    class << self
      def create(user_id:, namespace_prefix: nil)
        namespace = "#{namespace_prefix}-#{user_id}" if namespace_prefix
        payload = { user_id: user_id, namespace: namespace }
        JWTSessions::Session.new(payload: payload, refresh_payload: payload, namespace: namespace).login
      end

      def destroy(refresh_token:, namespace: nil)
        JWTSessions::Session.new(namespace: namespace).flush_by_token(refresh_token)
      end

      def destroy_all(namespace:)
        JWTSessions::Session.new(namespace: namespace).flush_namespaced
      end

      def refresh(refresh_token:, payload:)
        namespace = payload['namespace']
        new_payload = { user_id: payload['user_id'], namespace: namespace }
        new_session = JWTSessions::Session.new(payload: new_payload, refresh_payload: new_payload, namespace: namespace)
        destroy(refresh_token: refresh_token, namespace: namespace)
        new_session.login
      end
    end
  end
end
