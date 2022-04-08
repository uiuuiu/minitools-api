module HandleControllerError
  def self.included(klass)
    klass.class_eval do
      rescue_from StandardError do |e|
        new_logger = Logger.new("#{Rails.root}/log/error_#{Rails.env}.log")
        new_logger.info(e.backtrace.join("\n"))
        raise e
      end

      # rescue_from ServiceError do |e|
      #   respond(e.type, 422, e.message)
      # end
    end

    private

    def respond(_error, _status, _message, _data = {})
      render json: {
        data: _data,
        meta: {
          status: _status,
          message: _message,
          error: _error,
        },
      }, status: _status, adapter: :json
    end

    def respond_single(_error, _status, _message)
      render json: {
        data: {},
        meta: {
          status: _status,
          message: _message,
          error: _error,
        },
      }, status: _status, adapter: :json
    end

    def render_unprocessable_entity(exception)
      message = exception.data[:message]
      type = exception.data[:type]
      respond(type, 422, message)
    end
  end
end
