require 'sinatra'

# v1 curl "localhost:4567/?firstname=erik&what=modest"
# v2 curl "localhost:4567/?first_name=erik&what=modest" (firstname -> first_name)
get '/' do
  updated_request = versioned_request(request)

  response_body = "#{updated_request.params["first_name"]} is #{updated_request.params["what"]}"

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
