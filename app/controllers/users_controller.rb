class UsersController < ApplicationController
  skip_before_action :authorize_request, only: %i[signup login]

  def signup
    user = User.create!(user_params)
    token = AuthenticateUser.new(user.email, user.password).call
    response = { message: 'User successfully created', token: token }
    render json: response, status: 201
  rescue ActiveRecord::RecordNotFound => e
    raise e.message
  end

  def login
    auth_token = AuthenticateUser.new(auth_params[:email],
                                      auth_params[:password]).call
    json_response(message: 'Login successful!', auth_token: auth_token)
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def auth_params
    params.permit(:email, :password)
  end
end
