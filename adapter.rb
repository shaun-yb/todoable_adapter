# todo: add a gemfile
require "pry"
require "httparty"

class Adapter
    include HTTParty

    attr_accessor :base_uri, :username
    attr_writer :password

    def initialize(username:, password:, base_uri:)
        @username = username
        @password = password
        @base_uri = base_uri
    end

    # POST /api/authenticate
    def authenticate
        return if !@expires_at.nil? && @expires_at >= DateTime.now 

        basic_auth = { "username": username, "password": @password }
        headers = { "Accept": "application/json", "Content-Type": "application/json" }
        
        response = self.class.post(base_uri + "/authenticate",
            basic_auth: basic_auth,
            headers: headers
        )

        @token = response["token"]
        @expires_at = DateTime.parse(response["expires_at"])
    end
        
    # GET /list
    def get_lists
    end

    # POST /lists
    def post_lists
    end

    # GET /lists/:list_id
    def get_list_by_id(list_id)
    end

    # PATCH /lists/:list_id
    def patch_list(list_id)
    end

    # DELETE /lists/:list_id
    def delete_list(list_id)
    end

    # POST /lists/:list_id/items
    def post_list_item(list_item_id,list_id)
    end

    # PUT /lists/:list_id/items/:item_id/finish
    def put_list_item_finished(list_item_id,list_id)
    end

    # /lists/:list_id/items/
    def delete_list_item
    end

#    private
end


## COMMANDS
a = Adapter.new(username: "shauncarland@gmail.com", password: "todoable", base_uri: "https://todoable.teachable.tech/api")

a.authenticate
a.authenticate