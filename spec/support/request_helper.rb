module Requests
  module JsonHelper
    def json
      JSON.parse(response.body)
    end

    def error_message
      json.with_indifferent_access[:error]
    end

    def authen_params(user)
      { username: user.username }
    end
  end
end
