require 'net/http'

module VendoStoreFront
  class CartApi
    def create_new_cart
      ApiClient.new.call_api('cart', 'POST')
    end

    def retrieve_cart(cart_token, include_line_items = false)
      # verify the required parameter 'cart_token' is set
      raise ArgumentError, "Missing the required parameter 'cart_token' when calling CartApi.retrieve_cart" if cart_token.nil?
      
      # verify 'cart_token' length is correct
      raise ArgumentError, 'Invalid cart_token length when calling CartApi.retrieve_cart' if cart_token.length != 35

      if include_line_items
        ApiClient.new.call_api('cart?include=line_items', 'GET', { cart_token: cart_token })
      else
        ApiClient.new.call_api('cart', 'GET', { cart_token: cart_token })
      end
    end

    def add_item_to_cart(cart_token, variant_id, quantity = 1)
      # verify the required parameter 'cart_token' is set
      raise ArgumentError, "Missing the required parameter 'cart_token' when calling CartApi.add_item_to_cart" if cart_token.nil?
      
      # verify 'cart_token' length is correct
      raise ArgumentError, 'Invalid cart_token length when calling CartApi.add_item_to_cart' if cart_token.length != 35

      # verify the required parameter 'variant_id' is set
      raise ArgumentError, "Missing the required parameter 'variant_id' when calling CartApi.add_item_to_cart" if variant_id.nil?

      # verify 'variant_id' length is correct
      raise ArgumentError, 'Invalid variant_id length when calling CartApi.add_item_to_cart' if variant_id.length != 36

      ApiClient.new.call_api('cart/add_item', 'POST', { cart_token: cart_token, variant_id: variant_id, quantity: quantity })
    end

    def change_item_quantity(cart_token, line_item_id, quantity = 1)
      # verify the required parameter 'cart_token' is set
      raise ArgumentError, "Missing the required parameter 'cart_token' when calling CartApi.change_item_quantity" if cart_token.nil?
      
      # verify 'cart_token' length is correct
      raise ArgumentError, 'Invalid cart_token length when calling CartApi.change_item_quantity' if cart_token.length != 35

      # verify the required parameter 'line_item_id' is set
      raise ArgumentError, "Missing the required parameter 'line_item_id' when calling CartApi.change_item_quantity" if line_item_id.nil?
      
      # verify 'line_item_id' length is correct
      if line_item_id.length != 36
        raise ArgumentError, 'Invalid line_item_id length when calling CartApi.change_item_quantity'
      end

      ApiClient.new.call_api('cart/set_quantity', 'PATCH', { cart_token: cart_token, line_item_id: line_item_id, quantity: quantity })
    end

    def remove_item_from_cart(cart_token, line_item_id)
      # verify the required parameter 'cart_token' is set
      raise ArgumentError, "Missing the required parameter 'cart_token' when calling CartApi.remove_item_from_cart" if cart_token.nil?
      
      # verify 'cart_token' length is correct
      raise ArgumentError, 'Invalid cart_token length when calling CartApi.remove_item_from_cart' if cart_token.length != 35

      # verify the required parameter 'line_item_id' is set
      raise ArgumentError, "Missing the required parameter 'line_item_id' when calling CartApi.remove_item_from_cart" if line_item_id.nil?
      
      # verify 'line_item_id' length is correct
      raise ArgumentError, 'Invalid line_item_id length when calling CartApi.remove_item_from_cart' if line_item_id.length != 36

      ApiClient.new.call_api("cart/remove_line_item/#{line_item_id}", 'DELETE', { cart_token: cart_token })
    end

    def apply_coupon_code(cart_token, coupon_code)
      # verify the required parameter 'cart_token' is set
      raise ArgumentError, "Missing the required parameter 'cart_token' when calling CartApi.apply_coupon_code" if cart_token.nil?
      
      # verify 'cart_token' length is correct
      raise ArgumentError, 'Invalid cart_token length when calling CartApi.apply_coupon_code' if cart_token.length != 35

      # verify the required parameter 'coupon_code' is set
      raise ArgumentError, "Missing the required parameter 'cart_token' when calling CartApi.apply_coupon_code" if coupon_code.nil?
      

      ApiClient.new.call_api('cart/apply_coupon_code', 'PATCH', { cart_token: cart_token, coupon_code: coupon_code })
    end
  end
end
