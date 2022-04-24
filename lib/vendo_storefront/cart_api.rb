require 'net/http'

module VendoStoreFront
    class CartApi
        def create_new_cart
            url = URI("https://demo.getvendo.com/api/v2/storefront/cart")

            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true

            request = Net::HTTP::Post.new(url)
            request["Accept"] = 'application/vnd.api+json'
            request["Content-Type"] = 'application/vnd.api+json'

            response = http.request(request)
            #puts response.read_body
            return response
        end

        def retrieve_cart(cart_token, include_line_items = false)
            
            if include_line_items
                url = URI("https://demo.getvendo.com/api/v2/storefront/cart?include=line_items")
            else
                url = URI("https://demo.getvendo.com/api/v2/storefront/cart")
            end

            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true

            request = Net::HTTP::Get.new(url)
            request["Accept"] = 'application/vnd.api+json'
            #request["X-Vendo-Order-Token"] header doesn't work for some reason
            request["X-Spree-Order-Token"] = cart_token

            response = http.request(request)
            #puts response.read_body
            return response
        end

        def add_item_to_cart(cart_token, variant_id, quantity = 1)
            
            url = URI("https://demo.getvendo.com/api/v2/storefront/cart/add_item")

            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true

            request = Net::HTTP::Post.new(url)
            request["Accept"] = 'application/vnd.api+json'
            request["Content-Type"] = 'application/vnd.api+json'
            #request["X-Vendo-Order-Token"] header doesn't work for some reason
            request["X-Spree-Order-Token"] = cart_token
            request.body = "{\"variant_id\":\"#{variant_id}\",\"quantity\":#{quantity}}"

            response = http.request(request)
            #puts response.read_body
            return response
        end
    end
end