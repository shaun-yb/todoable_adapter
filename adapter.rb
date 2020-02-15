class Adapter
    def initialize
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

    # POST /api/authenticate
    def authenticate
    end

   private
end