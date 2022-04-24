require 'vendo_storefront/cart_api'
require 'json'

describe 'Vendo API SDK Tests' do
    describe VendoStoreFront::CartApi do
        describe '.create_new_cart' do
            xit 'returns new cart data' do
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

            context 'given valid token and to include line items' do
                it 'returns cart including line items' do
                    token = 'eKl_OATDvP4EKd_DkecvNQ1650786031165'
                    result = VendoStoreFront::CartApi.new.retrieve_cart(token, true)
                    
                    expect(result.code).to eq('200')
                    expect(JSON.parse(result.body)["included"][0]["type"]).to eq("line_item")
                end
            end 
        end
    end
end