require 'sinatra'

# curl "localhost:4567/?firstname=erik"
get '/' do
  updated_request = versioned_request(request)

  response_body = updated_request.params["firstname"].to_s + " is awesome"

  versioned_response_body(response_body)
end

def versioned_request(request)
  request
end

def versioned_response_body(response_body)
  response_body
end
