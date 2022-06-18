# frozen_string_literal: true

class GraphqlController < ApplicationController
  include JWTSessions::RailsAuthorization

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = { current_user: current_user, access_token: access_token, refresh_token: refresh_token }
    result = ToDoListApiSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development(e)
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: :internal_server_error
  end

  def refresh_token
    request.headers['X-Refresh-Token']
  end

  def access_token
    request.headers['Authorization']
  end

  def current_user
    payload = JWT.decode(access_token, Constants::Shared::HMAC_SECRET)&.first
    @current_user ||= User.find(payload['user_id'])
  rescue StandardError => _e
    nil
  end
end
