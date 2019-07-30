class UsersController < ApplicationController
	def signup
		user = User.create!(user_params)
		token = AuthenticateUser.new(user.email, user.password).call
		response = { message: 'User successfully created', token: token }
		render json: response, status: 201
	rescue ActiveRecord::RecordNotFound => e
		raise e.message
	end

	private

	def user_params
		params.permit(:name, :email, :password, :password_confirmation)
	end
end
