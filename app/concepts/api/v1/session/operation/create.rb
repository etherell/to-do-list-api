# frozen_string_literal: true

module Api::V1::Session::Operation
  class Create < ApplicationOperation
    step Macro::Contract::Schema(Api::V1::Session::Contract::Create)
    step Contract::Validate(), fail_fast: true
    pass :prepare_params
    step :set_model
    step :authenticate
    fail Macro::AddContractError(base: 'errors.session.wrong_credentials')
    fail Macro::Semantic(failure: :unauthorized)
    step :set_session_tokens
    pass :set_serializer
    pass Macro::Semantic(success: :created)

    def prepare_params(_ctx, params:, **)
      params[:username] = params[:username].strip
    end

    def set_model(ctx, params:, **)
      ctx[:model] = User.find_by(username: params[:username])
    end

    def authenticate(ctx, model:, **)
      model.authenticate(ctx['contract.default'].password)
    end

    def set_session_tokens(ctx, model:, **)
      ctx[:session_tokens] = Api::V1::Lib::Service::Session
                             .create(user_id: model.id, namespace_prefix: Constants::TokenNamespace::SESSION)
    end

    def set_serializer(ctx, model:, session_tokens:, **)
      ctx[:serializer] = Api::V1::User::Serializer::Create.new(
        model, meta: session_tokens
      )
    end
  end
end
