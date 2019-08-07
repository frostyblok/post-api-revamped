module ExceptionHandler
	extend ActiveSupport::Concern

	class AuthenticationError < StandardError; end

	included do
		rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized
		rescue_from ActiveRecord::RecordInvalid, with: :unprocessable
	end

	private

	def unauthorized(e)
		render json: e.message, status: 401
	end

	def unprocessable(e)
		render json: e.message, status: 422
	end
end
