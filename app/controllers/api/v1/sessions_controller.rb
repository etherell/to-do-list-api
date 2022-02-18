# frozen_string_literal: true

class Api::V1::SessionsController < ApiController
  rescue_from JWTSessions::Errors::Unauthorized, with: :forbidden

  def create
    endpoint operation: Api::V1::Session::Operation::Create
  end

  def destroy
    authorize_refresh_request!
    endpoint operation: Api::V1::Session::Operation::Destroy, options: { found_token: found_token, payload: payload }
  end

  private

  def forbidden
    head(:forbidden)
  end
end
