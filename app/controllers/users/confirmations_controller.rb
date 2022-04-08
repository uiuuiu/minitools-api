class Users::ConfirmationsController < Devise::ConfirmationsController
  respond_to :json

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      render_blank_with_message meta: {
        message: 'Your account was actived sucessfully.'
      }
    else
      render_blank_with_message meta: {
        message: resource.errors.full_messages,
        status: 422
      }
    end
  end
end
