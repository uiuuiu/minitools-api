module Api
  module V1
    class ShortedLinksController < PrivateController
      def index
        links = current_user.shorted_links.order(id: :desc).page(page_param).per(limit_param)
        render_paginate_data links, options: {each_serializer: ShortedLinks::ShowSerializer}, meta: {}
      end

      def show
        link = current_user.shorted_links.find(params[:id])
        render_data link, options: {serializer: ShortedLinks::CreateSerializer}, meta: {}
      end

      def create
        link = ShortedLink.generate!(params[:url], owner: current_user, title: params[:title], description: params[:description], category: params[:tag], fresh: true)
        if link.errors.present?
          render_errors(link)
        else
          render_data link, options: {serializer: ShortedLinks::CreateSerializer}, meta: {}
        end
      end
    end
  end
end