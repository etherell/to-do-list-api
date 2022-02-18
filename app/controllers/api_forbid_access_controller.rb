# frozen_string_literal: true

class ApiForbidAccessController < ApiController
  rescue_from JWTSessions::Errors::Unauthorized, with: :forbidden

  private

  def forbidden
    head(:forbidden)
  end
end
