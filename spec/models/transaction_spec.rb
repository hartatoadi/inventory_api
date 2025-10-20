require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  let!(:product) { Product.create!(name: "Apple", stock: 10) }

  it "creates an 'out' transaction and reduces stock" do
    post "/transactions", params: { product_id: product.id, quantity: 3, transaction_type: "out" }
    expect(response).to have_http_status(:created)
    expect(JSON.parse(response.body)["product"]["stock"]).to eq(7)
  end

  it "rejects if stock is insufficient" do
    post "/transactions", params: { product_id: product.id, quantity: 50, transaction_type: "out" }
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it "creates an 'in' transaction and increases stock" do
    post "/transactions", params: { product_id: product.id, quantity: 5, transaction_type: "in" }
    expect(JSON.parse(response.body)["product"]["stock"]).to eq(15)
  end
end