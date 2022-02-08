require 'sinatra'

# v1 curl "localhost:4567/?firstname=erik&what=modest"
# v2 curl "localhost:4567/?first_name=erik&what=modest" (firstname -> first_name)
# v3 curl "localhost:4567/?first_name=erik&what=modest" (what -> is)
get '/' do
  updated_request = versioned_request(request)

  response_body = "#{updated_request.params['first_name']} is #{updated_request.params['what']}"

  versioned_response_body(response_body)
end

def versioned_request(request)
  Changes::BY_ENDPOINT['GET_/'].reduce(request) do |_, change_class|
    change_class.new(request).call
  end
end

def versioned_response_body(response_body)
  response_body
end

module Changes
  # Implement me in subclasses
  class AbstractRequest
    def initialize(request)
      @request = request
    end

    def call
      raise NotImplementedError
    end

    private

    attr_reader :request
  end

  # RenameRequestParamFromFirstnameToFirstName
  class RenameRequestParamFromFirstnameToFirstName < AbstractRequest
    def call
      request.params.merge('first_name' => request.params['firstname'])
      request.params.delete('firstname')
      request
    end
  end

  BY_ENDPOINT = {
    'GET_/' => [
      RenameRequestParamFromFirstnameToFirstName
      # RenameRequestParamFromWhatToIs
    ]
  }
end
