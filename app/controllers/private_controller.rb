class PrivateController < ApplicationController
  before_action :authenticate_request!
  before_action :authenticate_user!

  private

  # Check for auth headers - if present, decode or send unauthorized response (called always to allow current_user)
  def authenticate_request!
    if request.headers['Authorization'].present?
      begin
        jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], ENV['DEVISE_JWT_SECRET_KEY']).first
        @current_user_id = jwt_payload['id']
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        render_unauthenticated
      end
    else
      render_unauthenticated
    end
  end

  # If user has not signed in, return unauthorized response (called only when auth is needed)
  def authenticate_user!(options = {})
    render_unauthenticated unless signed_in?
  end

  # set Devise's current_user using decoded JWT instead of session
  def current_user
    @current_user ||= super || @current_user_id && User.find(@current_user_id)
  end

  # check that authenticate_user has successfully returned @current_user_id (user is authenticated)
  def signed_in?
    @current_user_id.present?
  end

  def render_unauthenticated
    render_blank_with_message meta: {
      message: "Unauthenticated",
      status: 401
    }
  end
end