require 'net/http'

module VendoStoreFront
    class CartApi
        def create_new_cart
            
            response = ApiClient.new.call_api("cart", "POST")
            
            return response
        end

        def retrieve_cart(cart_token, include_line_items = false)
            # verify the required parameter 'cart_token' is set
            fail ArgumentError, "Missing the required parameter 'cart_token' when calling CartApi.retrieve_cart" if cart_token.nil?
            # verify 'cart_token' length is correct
            fail ArgumentError, "Invalid cart_token length when calling CartApi.retrieve_cart" if cart_token.length != 35
            
            if include_line_items
                response = ApiClient.new.call_api("cart?include=line_items", "GET", {:cart_token => cart_token})
            else
                response = ApiClient.new.call_api("cart", "GET", {:cart_token => cart_token})
            end

            return response
        end

        def add_item_to_cart(cart_token, variant_id, quantity = 1)
            # verify the required parameter 'cart_token' is set
            fail ArgumentError, "Missing the required parameter 'cart_token' when calling CartApi.add_item_to_cart" if cart_token.nil?
            # verify 'cart_token' length is correct
            fail ArgumentError, "Invalid cart_token length when calling CartApi.add_item_to_cart" if cart_token.length != 35

            # verify the required parameter 'variant_id' is set
            fail ArgumentError, "Missing the required parameter 'variant_id' when calling CartApi.add_item_to_cart" if variant_id.nil?
            # verify 'variant_id' length is correct
            fail ArgumentError, "Invalid variant_id length when calling CartApi.add_item_to_cart" if variant_id.length != 36

            response = ApiClient.new.call_api("cart/add_item", "POST", {:cart_token => cart_token, :variant_id => variant_id, :quantity => quantity})
            
            return response
        end
    end
end