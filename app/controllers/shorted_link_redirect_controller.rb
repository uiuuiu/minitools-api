class ShortedLinkRedirectController < ApplicationController

  def show
    link = ShortedLink.active.fetch_with_token(token: params[:token])[:shortened_url]
    if link
      render_data link, options: { serializer: ShortedLinks::RedirectSerializer }, meta: {}
    else
      render_blank_with_message meta: {
        message: 'No url found!',
        status: 404
      }
    end
  end
end