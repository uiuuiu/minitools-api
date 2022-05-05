module Api
  module V1
    class PublicShortedLinksController < ApplicationController
      before_action :set_link, only: [:show, :update]

      def create
        link = ShortedLink.generate!(
          params[:url],
          # owner: current_user,
          title: params[:title],
          description: params[:description],
          category: params[:tag],
          status: :active,
          fresh: true
        )

        if link.errors.present?
          render_errors(link)
        else
          render_data link, options: {serializer: ShortedLinks::CreateSerializer}, meta: {}
        end
      end
    end
  end
end