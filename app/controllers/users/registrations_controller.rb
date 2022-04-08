class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    resource.persisted? ? register_success : register_failed
  end

  def register_success
    # render json: { message: 'Signed up.' }
    render_blank_with_message meta: {
      message: 'Registered sucessfully! Please check email for verification.'
    }
  end
  
  def register_failed
    # render json: { message: "Signed up failure." }
    render_blank_with_message meta: {
      message: resource.errors.full_messages,
      status: 422
    }
  end
end
