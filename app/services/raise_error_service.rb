# frozen_string_literal: true

class RaiseErrorService
  RESPONSE_CODES = {
    unauthorized: 401,
    forbidden: 403,
    not_found: 404,
    unprocessable_entity: 422
  }.freeze

  STANDARD_ERRORS = {
    unauthorized: I18n.t('errors.not_authorized'),
    forbidden: I18n.t('errors.forbidden'),
    not_found: I18n.t('errors.not_found', model_name: 'Record'),
    unprocessable_entity: I18n.t('errors.unprocessable')
  }.freeze

  def initialize(status, message)
    @status = status
    @message = message
  end

  def self.call(status, message)
    new(status, message).call
  end

  def call
    error_message = message || STANDARD_ERRORS[status]
    response_code = RESPONSE_CODES[status]
    raise GraphQL::ExecutionError.new(error_message, options: { status: status, code: response_code })
  end

  private

  attr_reader :status, :message
end
