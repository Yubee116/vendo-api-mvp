module VendoStoreFront
    class ApiClient
        def call_api(path, http_method, opts = {})
            http, request = build_request(path, http_method, opts)
                 
            begin
                response = http.request(request)

                fail VendoStoreFront::ApiError, response.code + " Error: " + JSON.parse(response.body)["error"] + " Invalid token, variant_id or line_item_id provided." if response.code == '404'
                fail VendoStoreFront::ApiError, response.code + " Error: "  + JSON.parse(response.body)["error"] unless response.is_a?(Net::HTTPSuccess)
    
            rescue Errno::ETIMEDOUT, Errno::ECONNREFUSED, Errno::EACCES, SocketError => e
                puts e.class.to_s + ". Connection Error" 
            end 

            return response
        end

        
        def build_request(path, http_method, opts = {})
            
            url = URI("https://demo.getvendo.com/api/v2/storefront/#{path}")
        
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            
            case http_method
            when "GET"
                request = Net::HTTP::Get.new(url)
            when "POST"
                request = Net::HTTP::Post.new(url)
            when "PATCH"
                request = Net::HTTP::Patch.new(url)
            when "DELETE"
                request = Net::HTTP::Delete.new(url)  
            end  
        
            #configure request headers
            request["Accept"] = 'application/vnd.api+json'
            request["Content-Type"] = 'application/vnd.api+json' if ["POST", "PATCH"].include?(http_method)
            #request["X-Vendo-Order-Token"] header doesn't work for some reason
            request["X-Spree-Order-Token"] = opts[:cart_token] unless opts[:cart_token].nil?
            
            #configure request body
            request_body = {}
            opts.each do |key, value|
                next if key == :cart_token
                request_body[key] = value
            end

            request.set_form_data(request_body)

            return http, request
        end
    end
end