module Api
  module V1
    class UsersController < PrivateController
      def index
        render :ok
      end
    end
  end
end