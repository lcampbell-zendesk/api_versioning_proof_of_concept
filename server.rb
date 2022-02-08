require 'sinatra'

# v1 curl "localhost:4567/?firstname=erik"
# v2 curl "localhost:4567/?first_name=erik"
get '/' do
  updated_request = versioned_request(request)

  response_body = updated_request.params["first_name"].to_s + " is awesome"

  versioned_response_body(response_body)
end

def versioned_request(request)
  request.params.merge("first_name" => request.params["firstname"])
  request.params.delete("firstname")
  request
end

def versioned_response_body(response_body)
  response_body
end
