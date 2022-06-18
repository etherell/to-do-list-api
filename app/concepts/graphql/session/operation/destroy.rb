# frozen_string_literal: true

module Graphql::Session::Operation
  class Destroy < ApplicationOperation
    step :destroy_session
    fail Subprocess(Graphql::Lib::Operation::UnauthorizedError)
    pass :result

    def destroy_session(ctx, refresh_token:, **)
      JWTSessions::Session.new.flush_by_token(refresh_token)
    rescue JWTSessions::Errors::Unauthorized => e
      ctx[:error_message] = e.message
      false
    end

    def result(ctx, **)
      ctx[:result] = { result: :completed, errors: [] }
    end
  end
end
