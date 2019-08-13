class UsersController < ApplicationController
  skip_before_action :authorize_request,
                     only: %i[signup login social_session_create]

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

  def social_session_create
    @user = User.find_or_create_from_auth_hash(env['omniauth.auth'])
    self.current_user = @user
    token = JsonWebToken.encode(user_id: @user.id)
    json_response(message: 'Login successful!', auth_token: token)
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def auth_params
    params.permit(:email, :password)
  end
end
