require 'simplecov'
SimpleCov.start
require 'vendo_storefront'
require 'json'

describe 'Vendo API SDK Tests' do
    describe VendoStoreFront::CartApi do
        describe '.create_new_cart' do
            it 'returns new cart data' do
                result = VendoStoreFront::CartApi.new.create_new_cart()
                
                expect(result.code).to eq('201')
                expect(JSON.parse(result.body)["data"]).not_to be(nil)
            end
        end

        describe '.fetch_exisiting_cart' do
            context 'given valid token' do 
                it 'returns cart with the correct token' do
                    token = 'eKl_OATDvP4EKd_DkecvNQ1650786031165'
                    result = VendoStoreFront::CartApi.new.retrieve_cart(token)
                    
                    expect(result.code).to eq('200')
                    expect(JSON.parse(result.body)["data"]["attributes"]["token"]).to eq(token)
                end
            end

            context "given token with invalid length" do 
                it "raises ArgumentError" do
                    invalid_length_token = 'OL1-31K9RZAncY'
                    expect{VendoStoreFront::CartApi.new.retrieve_cart(invalid_length_token)}.to raise_error(ArgumentError)
                end
            end

            context "given invalid token" do 
                it "raises APIError" do
                    invalid_token = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
                    expect{VendoStoreFront::CartApi.new.retrieve_cart(invalid_token)}.to raise_error(VendoStoreFront::ApiError)
                end
            end

            context "given no token" do 
                it "raises ArgumentError" do
                    expect{VendoStoreFront::CartApi.new.retrieve_cart()}.to raise_error(ArgumentError)
                end
            end

            context 'given valid token and to include line items' do
                it 'returns cart including line items' do
                    token = 'eKl_OATDvP4EKd_DkecvNQ1650786031165'
                    result = VendoStoreFront::CartApi.new.retrieve_cart(token, true)
                    
                    expect(result.code).to eq('200')
                    expect(JSON.parse(result.body)["included"][0]["type"]).to eq("line_item")
                end
            end 
        end

        describe '.add_item_to_cart' do
            context "given valid variant_id" do
                it "returns new cart data containing the added item" do
                    token = 'eKl_OATDvP4EKd_DkecvNQ1650786031165'
                    variant_id = '862747fd-0720-45db-a906-10879b809857'
                    
                    result = VendoStoreFront::CartApi.new.add_item_to_cart(token, variant_id)

                    expect(result.code).to eq('200')
                    expect(JSON.parse(result.body)["data"]["relationships"]["variants"]["data"][0]["id"]).to eq(variant_id)
                end
            end

            context "given invalid variant_id" do
                it "raises APIError" do
                    token = 'eKl_OATDvP4EKd_DkecvNQ1650786031165'
                    invalid_variant_id = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
                    
                    expect{VendoStoreFront::CartApi.new.add_item_to_cart(token, invalid_variant_id)}.to raise_error(VendoStoreFront::ApiError)
                end
            end
        end

    end
end