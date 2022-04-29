module Api
  module V1
    class SocialAuthController < Devise::OmniauthCallbacksController
      def authenticate_social_auth_user
        @user = User.signin_or_create_from_provider(params) # this method add a user who is new or logins an old one
        if @user.persisted?
          sign_in(@user)
          render_data @user, options: { serializer: AccessTokenSerializer }, meta: { message: 'Login sucessfully.' }
        else
          render_blank_with_message meta: {
            message: 'Login failed!',
            status: 401
          }
        end
      end
    end
  end
end
