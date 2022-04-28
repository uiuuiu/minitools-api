module Api
  module V1
    class ShortedLinksController < PrivateController
      before_action :set_link, only: [:show, :update]

      def index
        links = ShortedLink.search(
          search_param,
          match: :word_middle,
          where: {
            owner_id: current_user.id
          },
          order: {_id: :desc}, page: page_param, per_page: limit_param
        )

        render_paginate_data links, options: {each_serializer: ShortedLinks::ShowSerializer}, meta: {}
      end

      def show
        render_data @link, options: {serializer: ShortedLinks::CreateSerializer}, meta: {}
      end

      def create
        link = ShortedLink.generate!(
          params[:url],
          owner: current_user,
          title: params[:title],
          description: params[:description],
          category: params[:tag],
          status: active_param,
          fresh: true
        )

        if link.errors.present?
          render_errors(link)
        else
          render_data link, options: {serializer: ShortedLinks::CreateSerializer}, meta: {}
        end
      end

      def update
        @link.update(permit_params.merge(status: active_param))
        if @link.errors.present?
          render_errors(@link)
        else
          render_data @link, options: {serializer: ShortedLinks::CreateSerializer}, meta: {}
        end
      end
  
      private

      def active_param
        params[:active] ? :active : :deactive
      end
  
      def permit_params
        params.permit(:title, :description)
      end
  
      def set_link
        @link = current_user.shorted_links.find(params[:id])
      end
    end
  end
end