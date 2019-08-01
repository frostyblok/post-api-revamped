class ApplicationController < ActionController::API
  include ExceptionHandler
  include Response
  before_action :authorize_request
  attr_reader :current_user

  private

  def authorize_request
    @current_user = AuthorizeRequests.new(request.headers).call[:user]
  end
end
