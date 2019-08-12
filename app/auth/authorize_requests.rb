class AuthorizeRequests
  attr_reader :headers

  def initialize(headers = {})
    @headers = headers
  end

  def call
    {
      user: user
    }
  end

  private

  def user
    @user ||= User.find(decoded_token[:user_id]) if decoded_token
  end

  def decoded_token
    @decoded_token ||= JsonWebToken.decode(auth_header)
  end

  def auth_header
    if headers['Authorization'].present?
      headers['Authorization'].split(' ').last
    end
  end
end
