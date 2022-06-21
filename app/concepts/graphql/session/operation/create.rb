# frozen_string_literal: true

module Graphql::Session::Operation
  class Create < ApplicationOperation
    step Macro::Contract::Schema(Graphql::Session::Contract::Create)
    step Contract::Validate()
    fail Macro::RaiseError(status: :unprocessable_entity), fail_fast: true
    step :set_model
    fail :set_not_found_error_message
    fail Macro::RaiseError(status: :not_found, message: :not_found_error), fail_fast: true
    step :authenticate
    fail :set_unauthorized_error_message
    fail Macro::RaiseError(status: :unauthorized, message: :unauthorized_error)
    step :set_session
    pass :set_result

    def set_model(ctx, params:, **)
      ctx[:model] = User.find_by(username: params[:username])
    end

    def set_not_found_error_message(ctx, **)
      ctx[:not_found_error] = I18n.t('errors.not_found', model_name: User.to_s)
    end

    def authenticate(ctx, model:, **)
      model.authenticate(ctx['contract.default'].password)
    end

    def set_unauthorized_error_message(ctx, **)
      ctx[:unauthorized_error] = I18n.t('errors.session.wrong_credentials')
    end

    def set_session(ctx, model:, **)
      ctx[:session] = JWTSessions::Session.new(payload: { user_id: model.id }).login
    end

    def set_result(ctx, session:, **)
      ctx[:result] = { session: session, errors: [] }
    end
  end
end
