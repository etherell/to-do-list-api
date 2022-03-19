# frozen_string_literal: true

module Api::V1::Session::Operation
  class Destroy < ApplicationOperation
    step :destroy_session
    pass Macro::Semantic(success: :destroyed)

    def destroy_session(_ctx, found_token:, payload:, **)
      Api::V1::Lib::Service::Session.destroy(refresh_token: found_token, namespace: payload['namespace'])
    end
  end
end
