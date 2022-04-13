module ControllerHelpers
  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end

  def do_request(request_params)
    send request_params.dig(:method),
         request_params.dig(:action),
         params: request_params.dig(:options),
         format: request_params.dig(:format)
  end

  # def json
  #   @json ||= JSON.parse(response.body)
  # end
end
