class DeviseFailureApp < Devise::FailureApp
  def respond
    self.status = 200 
    self.content_type = 'json'
    self.response_body = {
      data: {},
      meta: {
        message: "Email or password is not correct",
        status: 401
      }
    }.to_json
  end 
end