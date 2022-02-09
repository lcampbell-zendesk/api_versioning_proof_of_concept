require 'sinatra'

# curl -H "X-ZendeskAPI-Version: 2020" "localhost:4567/?firstname=Zendesk&what=zen"
# curl -H "X-ZendeskAPI-Version: 2021" "localhost:4567/?first_name=Programming&what=cool" # (firstname -> first_name)
# curl -H "X-ZendeskAPI-Version: 2022" "localhost:4567/?first_name=Teamwork&is=awesome" # (what -> is)
# curl -H "X-ZendeskAPI-Version: 2023" "localhost:4567/?full_name=Teamwork&is=awesome" # (first_name -> full_name)
get '/' do
  updated_request = versioned_request(request)

  # Whatever Business Logic, uses latest version
  response_body = "#{updated_request.params['full_name']} is #{updated_request.params['is']}"

  versioned_response_body(response_body)
end

# VERSIONING LOGIC

def versioned_response_body(response_body)
  response_body # TODO:
end

# @return request, altered as if sent by the latest version
def versioned_request(request)
  relevant_changes(request.env).reduce request do |_, change_class|
    change_class.new(request).call
  end
end

# Changes required to update the request from the user version to the latest
def relevant_changes(headers)
  VersionChanges::VERSIONS.slice(*relevant_versions(headers))
    .sort.flat_map { |_k, v| v }
end

# Versions between the user request and the latest
def relevant_versions(headers)
  request_version = headers['HTTP_X_ZENDESKAPI_VERSION']
  sorted_versions = VersionChanges::VERSIONS.keys.sort
  first_change_index = sorted_versions.index(request_version) + 1
  sorted_versions[first_change_index..-1]
end

module Changes
  class AbstractRequest
    def initialize(request)
      @request = request
    end

    def call
      apply
      request
    end

    private

    def apply
      raise NotImplementedError
    end

    # TODO: use composition instead of shared helper methods
    def rename_request_param(from:, to:)
      request.params.merge!(to => request.params[from])
      request.params.delete(from)
    end

    attr_reader :request
  end

  class RenameRequestParamFromFirstnameToFirstName < AbstractRequest
    def apply
      rename_request_param(from: 'firstname', to: 'first_name')
    end
  end

  class RenameRequestParamFromWhatToIs < AbstractRequest
    def apply
      rename_request_param(from: 'what', to: 'is')
    end
  end

  class RenameRequestParamFromFirstNameToFullName < AbstractRequest
    def apply
      rename_request_param(from: 'first_name', to: 'full_name')
    end
  end
end

class VersionChanges
  # TODO? how to nest verb/path (eg "GET /")
  VERSIONS = {
    '2020' => [],
    '2021' => [Changes::RenameRequestParamFromFirstnameToFirstName],
    '2022' => [Changes::RenameRequestParamFromWhatToIs],
    '2023' => [Changes::RenameRequestParamFromFirstNameToFullName]
  }
end
