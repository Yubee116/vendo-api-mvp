require 'net/http'
require_relative '../client/api_client'

module VendoStoreFront
    class CartApi
        def create_new_cart
            
            response = ApiClient.new.call_api("cart", "POST")
            
            return response
        end

        def retrieve_cart(cart_token, include_line_items = false)
            
            if include_line_items
                response = ApiClient.new.call_api("cart?include=line_items", "GET", {:cart_token => cart_token})
            else
                response = ApiClient.new.call_api("cart", "GET", {:cart_token => cart_token})
            end

            return response
        end

        def add_item_to_cart(cart_token, variant_id, quantity = 1)
            
            response = ApiClient.new.call_api("cart/add_item", "POST", {:cart_token => cart_token, :variant_id => variant_id, :quantity => quantity})
            
            return response
        end
    end
end