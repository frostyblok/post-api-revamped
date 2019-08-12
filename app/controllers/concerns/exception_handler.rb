module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class InvalidToken < StandardError; end

  included do
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  end

  private

  def unauthorized(entity)
    render json: entity.message, status: 401
  end

  def unprocessable_entity(entity)
    render json: entity.message, status: 422
  end
end
