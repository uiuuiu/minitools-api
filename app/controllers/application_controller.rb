class ApplicationController < ActionController::API
  include HandleControllerError

  attr_accessor :message
  attr_writer :status

  private

  def render_paginate_data(objects, options:, meta: {})
    meta[:message] ||= ''
    meta[:status]  ||= 200
    options[:root] ||= 'data'

    render json: objects, **options, meta: meta_attributes(objects, extra_meta: meta)
  end

  def render_data(objects, options:, meta:)
    meta[:message] ||= ''
    meta[:status]  ||= 200
    options[:root] ||= 'data'

    render json: objects, **options, meta: meta
  end

  def render_blank_with_message(meta: {})
    meta[:message] ||= ''
    meta[:status]  ||= 200
    render json: { data: {}, meta: meta }
  end

  def render_yaml_data(objects, status: 200)
    render json: objects, adapter: :json, root: 'data', meta: { status: status }
  end

  def render_errors(object)
    render_blank_with_message meta: {
      message: object.errors.full_messages,
      status: 422
    }
  end

  def meta_attributes(collection, extra_meta:)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page, # use collection.previous_page when using will_paginate
      total_pages: collection.total_pages,
      total_count: collection.total_count,
    }.merge(extra_meta)
  end

  def limit_param
    if Const::Paginate::LIMIT.include?(params[:limit].to_i)
      return params[:limit]
    end

    Const::Paginate::DEFAULT
  end

  def page_param
    params[:page] || 1
  end

  def init_message_and_status(object)
    # @message is set in yield block
    yield

    # @status is set here
    @status = object.errors.present? ? :unprocessable_entity : :ok
  end

  # Override status: convert from symbol to number
  def status
    Rack::Utils::SYMBOL_TO_STATUS_CODE[@status]
  end
end
