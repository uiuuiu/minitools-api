class Users::SessionsController < Devise::SessionsController
  respond_to :json

  skip_before_action :verify_signed_out_user, only: :destroy

  private

  def respond_with(resource, _opts = {})
    # render_blank_with_message meta: {
    #   message: 'Registered sucessfully! Please check email for verification.'
    # }
    render_data resource, options: { serializer: AccessTokenSerializer }, meta: { message: 'Login sucessfully.' }
  end

  def respond_to_on_destroy
    log_out_success
  end

  def log_out_success
    render_blank_with_message meta: {
      message: 'Logged out.'
    }
  end
end
