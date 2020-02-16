# todo: add a gemfile
require "pry"
require "httparty"

class AdapterError < StandardError
end

# todo: see if i can get a config.ru file replacing this
class Adapter
    include HTTParty

    attr_accessor :base_uri, :username
    attr_writer :password

    LIST_URI = "/lists"

    def initialize(username:, password:, base_uri:)
        @username = username
        @password = password
        @base_uri = base_uri
    end

    # POST /api/authenticate
    def authenticate
        return true if !@expires_at.nil? && @expires_at >= DateTime.now 

        basic_auth = { "username": username, "password": @password }
        headers = { "Accept": "application/json", "Content-Type": "application/json" }
        
        begin
            response = self.class.post(base_uri + "/authenticate",
            basic_auth: basic_auth,
            headers: authenticated_headers
        )

            @token = response["token"]
            @expires_at = DateTime.parse(response["expires_at"])
            return true
        rescue
            raise_adapter_error(__method__)
        end
    end
        
    # GET /list
    def get_lists
        # todo: see if i can do a "before action" or something like that?
        authenticate

        response = self.class.get(base_uri + LIST_URI, headers: authenticated_headers)
        response["lists"]
    end

    # GET /lists/:list_id
    def get_list(list_id)
        authenticate
        response = self.class.get(base_uri + LIST_URI + "/#{list_id}", headers: authenticated_headers)

        # todo: add in error handling for when the list is not found
        response
    end

    # POST /lists
    def post_list(name)
        authenticate
        body = { "list": { "name": name } }.to_json
        response = self.class.post(base_uri + LIST_URI, headers: authenticated_headers, body: body)
        # todo: add in error handling when the name already taken and check what should be returned...
    end
    
    # PATCH /lists/:list_id
    def patch_list(list_id, body_params)
        authenticate
        body = body_params.to_json
        url = base_uri + LIST_URI + "/#{list_id}"
        response = self.class.patch(url, headers: authenticated_headers, body: body)
    end

    # DELETE /lists/:list_id
    def delete_list(list_id)
        authenticate
        url = base_uri + LIST_URI + "/#{list_id}"
        response = self.class.delete(url, headers: authenticated_headers)
    end

    # POST /lists/:list_id/items
    def post_list_item(list_id, list_params)
        authenticate
        body = list_params.to_json
        url = base_uri + LIST_URI + "/#{list_id}" +"/items"

        # todo: put in test to ensure name is neccesary
        self.class.post(url, headers: authenticated_headers, body: body)
    end

    # PUT /lists/:list_id/items/:item_id/finish
    def mark_list_item_finished(list_id, list_item_id)
        authenticate
        body = { item: { finished_at: DateTime.now } }.to_json

        url = base_uri + LIST_URI  + "/#{list_id}/items/#{list_item_id}/finish"
        self.class.put(url, headers: authenticated_headers, body: body)
    end

    # /lists/:list_id/items/
    def delete_list_item(list_id, list_item_id)
        authenticate
        url = base_uri + LIST_URI  + "/#{list_id}/items/#{list_item_id}"

        self.class.delete(url, headers: authenticated_headers)
    end

   private

   def raise_adapter_error(method)
        raise AdapterError.new("Error with Adapter.  The called method was \##{method.to_s}")
   end

   def authenticated_headers
    auth_str = "Token token=\"#{@token}\""

    headers = { 
        "Accept": "application/json", 
        "Content-Type": "application/json",
        "Authorization": auth_str
    }
   end
end
