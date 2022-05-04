require 'spec_helper'


describe 'Vendo API SDK Tests - Cart' do
    def create_new_cart
        VCR.use_cassette("cart_api/helper_methods/new-cart") do
            new_cart = VendoStoreFront::ApiClient.new.call_api("cart","POST")
            @token = JSON.parse(new_cart.body)["data"]["attributes"]["token"]
        end
    end

    def get_valid_product_variant_id
        VCR.use_cassette("cart_api/helper_methods/product-variants") do
            products_list = VendoStoreFront::ApiClient.new.call_api("products", "GET")
            @variant_id = JSON.parse(products_list.body)["data"][0]["relationships"]["variants"]["data"][0]["id"]
        end
    end

    def get_valid_line_item_id
        VCR.use_cassette("cart_api/helper_methods/line-item-id") do
            cart_with_line_item = VendoStoreFront::ApiClient.new.call_api("cart/add_item", "POST", {:cart_token => @token, :variant_id => @variant_id, :quantity => 1})
            @line_item_id = JSON.parse(cart_with_line_item.body)["data"]["relationships"]["line_items"]["data"][0]["id"]
        end
    end

    def empty_cart
        VCR.use_cassette("cart_api/helper_methods/empty-cart") do
            VendoStoreFront::ApiClient.new.call_api("cart/empty", "PATCH", {:cart_token => @token})
        end
    end

    before(:all) do
        create_new_cart()
        get_valid_product_variant_id() 
    end

    describe VendoStoreFront::CartApi do
        describe '.create_new_cart' do
            it 'returns new cart data' do
                VCR.use_cassette("cart_api/new-cart") do
                    result = VendoStoreFront::CartApi.new.create_new_cart()
                    
                    expect(result).to be_a(Net::HTTPSuccess)
                    expect(JSON.parse(result.body)["data"]).not_to be(nil)
                end
            end
        end

        describe '.fetch_exisiting_cart' do
            context 'given valid token' do 
                it 'returns cart with the correct token' do
                    VCR.use_cassette("cart_api/fetch-cart-valid-token") do
                    
                        token = @token
                        result = VendoStoreFront::CartApi.new.retrieve_cart(token)
                        
                        expect(result).to be_a(Net::HTTPSuccess)
                        expect(JSON.parse(result.body)["data"]["attributes"]["token"]).to eq(token)
                    end
                end
            end

            context 'given token with invalid length' do 
                it 'raises ArgumentError' do
                    invalid_length_token = 'xxxxxxxxxx'
                    expect{VendoStoreFront::CartApi.new.retrieve_cart(invalid_length_token)}.to raise_error(ArgumentError)
                end
            end

            context 'given invalid token' do 
                it 'raises APIError' do
                    VCR.use_cassette("cart_api/fetch-cart-invalid-token") do
                        invalid_token = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
                        expect{VendoStoreFront::CartApi.new.retrieve_cart(invalid_token)}.to raise_error(VendoStoreFront::ApiError)
                    end
                end
            end

            context 'given no token' do
                it 'raises ArgumentError' do
                    expect{VendoStoreFront::CartApi.new.retrieve_cart()}.to raise_error(ArgumentError)
                end
            end

            context 'given valid token and to include line items' do
                it 'returns cart including line items' do
                    VCR.use_cassette("cart_api/fetch-cart-valid-token-include-line-items") do
                        empty_cart()
                        get_valid_line_item_id()

                        token = @token
                        
                        result = VendoStoreFront::CartApi.new.retrieve_cart(token, true)
                        
                        expect(result).to be_a(Net::HTTPSuccess)
                        expect(JSON.parse(result.body)["included"][0]["type"]).to eq("line_item")
                    end
                end
            end 
        end

        describe '.add_item_to_cart' do
            context 'given valid variant_id' do
                it 'returns new cart data containing the added item' do
                    VCR.use_cassette("cart_api/add-to-cart-valid-product-id") do
                        empty_cart()
                        
                        token = @token
                        variant_id = @variant_id
                        
                        result = VendoStoreFront::CartApi.new.add_item_to_cart(token, variant_id)

                        expect(result).to be_a(Net::HTTPSuccess)
                        expect(JSON.parse(result.body)["data"]["relationships"]["variants"]["data"][0]["id"]).to eq(variant_id)
                    end
                end
            end

            context 'given invalid variant_id' do
                it 'raises APIError' do
                    VCR.use_cassette("cart_api/add-to-cart-invalid-product-id") do
                        token = @token 
                        invalid_variant_id = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
                        
                        expect{VendoStoreFront::CartApi.new.add_item_to_cart(token, invalid_variant_id)}.to raise_error(VendoStoreFront::ApiError)
                    end
                end
            end
        end

        describe '.change_item_quantity' do
            context 'given valid line_item_id with sufficient quantity' do
                it 'returns cart containing specified item quantity' do
                    VCR.use_cassette("cart_api/change-item-quantity-valid-quantity") do
                        empty_cart()
                        get_valid_line_item_id()
                        
                        token = @token
                        line_item_id = @line_item_id
                        quantity = 3
                        
                        result = VendoStoreFront::CartApi.new.change_item_quantity(token, line_item_id, quantity)

                        expect(result).to be_a(Net::HTTPSuccess)
                        expect(JSON.parse(result.body)["data"]["attributes"]["item_count"]).to eq(quantity)
                    end
                end
            end

            context 'given valid line_item_id with INsufficient quantity' do
                it 'raises API Error' do
                    VCR.use_cassette("cart_api/change-item-quantity-invalid-quantity") do
                        empty_cart()
                        get_valid_line_item_id()

                        token = @token
                        line_item_id = @line_item_id
                        insufficient_quantity = 0
                        
                        expect{VendoStoreFront::CartApi.new.change_item_quantity(token, line_item_id, insufficient_quantity)}.to raise_error(VendoStoreFront::ApiError)
                    end
                end
            end
        end

        describe '.remove_item_from_cart' do
            context 'given valid line_item_id' do
                it 'returns cart with 0 item count and removed line item id' do
                    VCR.use_cassette("cart_api/remove-line-item-valid-id") do
                        empty_cart()
                        get_valid_line_item_id()
                        
                        token = @token
                        line_item_id = @line_item_id

                        result = VendoStoreFront::CartApi.new.remove_item_from_cart(token, line_item_id)

                        expect(result).to be_a(Net::HTTPSuccess)
                        expect(JSON.parse(result.body)["data"]["attributes"]["item_count"]).to eq(0)
                        expect(JSON.parse(result.body)["data"]["relationships"]["line_items"]["data"][0]["id"]).to eq(line_item_id)
                    end
                end
            end

            context 'given invalid line_item_id' do
                it 'Raises ApiError' do
                    VCR.use_cassette("cart_api/remove-line-item-invalid-id") do
                        token = @token
                        invalid_line_item_id = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

                        expect{VendoStoreFront::CartApi.new.remove_item_from_cart(token, invalid_line_item_id)}.to raise_error(VendoStoreFront::ApiError)
                    end
                end
            end
        end

        describe 'apply_coupon_code' do
            context 'given valid coupon code' do
                xit 'returns cart with promotion data' do
                    VCR.use_cassette("cart_api/apply-coupon-valid-code") do
                        token = @token
                        coupon_code = 'test'

                        result = VendoStoreFront::CartApi.new.apply_coupon_code(token, coupon_code)
                        expect(result).to be_a(Net::HTTPSuccess)
                        expect(result["data"]["relationships"]["promotions"]["data"][0]["type"]).to eq("promotion")
                    end
                end
            end

            context 'given invalid coupon code' do
                it 'raises ApiError' do
                    VCR.use_cassette("cart_api/apply-coupon-invalid-code") do
                        token = @token
                        coupon_code = 'xxxxx'

                        expect{VendoStoreFront::CartApi.new.apply_coupon_code(token, coupon_code)}.to raise_error(VendoStoreFront::ApiError)
                    end
                end
            end
        end
 
    end
end