# todo: add a gemfile
require "pry"
require "httparty"

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
        
        response = self.class.post(base_uri + "/authenticate",
            basic_auth: basic_auth,
            headers: authenticated_headers
        )

        @token = response["token"]
        @expires_at = DateTime.parse(response["expires_at"])
        true
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
        
        p = { name: "foo" }
        p2 = { item:  { name: "foo" }  } 
        # todo: put in test to ensure name is neccesary
        self.class.post(url, headers: authenticated_headers, body: body)
    end

    # PUT /lists/:list_id/items/:item_id/finish
    def put_list_item_finished(list_item_id,list_id)
    end

    # /lists/:list_id/items/
    def delete_list_item
    end

   private
   def authenticated_headers
    auth_str = "Token token=\"#{@token}\""

    headers = { 
        "Accept": "application/json", 
        "Content-Type": "application/json",
        "Authorization": auth_str
    }
   end
end

## COMMANDS
a = Adapter.new(username: "shauncarland@gmail.com", password: "todoable", base_uri: "https://todoable.teachable.tech/api")

# a.get_list("1aed547a-5efa-41d6-8dea-1f697ae9a7e9")
# a.patch_list("1aed547a-5efa-41d6-8dea-1f697ae9a7e9", { "list": { "name": "hello goodbye" } }) 

a.post_list_item("f760cc58-23fa-42f5-b9b8-a1ca0d9edd74",{ item:  { name: "foobar" }  } )
binding.pry

# a.post_list("lol fuck dis")