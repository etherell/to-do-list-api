# frozen_string_literal: true

module Graphql::Session::Operation
  class Create < ApplicationOperation
    step Macro::Contract::Schema(Graphql::Session::Contract::Create)
    step Contract::Validate()
    fail Subprocess(Graphql::Lib::Operation::UnprocessableEntityError), fail_fast: true
    step :set_model_name
    step :set_model
    fail Subprocess(Graphql::Lib::Operation::NotFoundError), fail_fast: true
    step :authenticate
    fail :set_error_message
    fail Subprocess(Graphql::Lib::Operation::UnauthorizedError), fail_fast: true
    step :set_session
    pass :set_result

    def set_model_name(ctx, **)
      ctx[:model_name] = User.to_s
    end

    def set_model(ctx, params:, **)
      ctx[:model] = User.find_by(username: params[:username])
    end

    def authenticate(ctx, model:, **)
      model.authenticate(ctx['contract.default'].password)
    end

    def set_error_message(ctx, **)
      ctx[:error_message] = I18n.t('errors.session.wrong_credentials')
    end

    def set_session(ctx, model:, **)
      ctx[:session] = JWTSessions::Session.new(payload: { user_id: model.id }).login
    end

    def set_result(ctx, session:, **)
      ctx[:result] = { session: session, errors: [] }
    end
  end
end
