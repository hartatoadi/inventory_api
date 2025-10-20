class TransactionsController < ApplicationController
  def index
    transactions = Transaction.includes(:product)
                              .order(created_at: :desc)
                              .page(params[:page])
                              .per(10)

    render json: transactions.as_json(
      include: { product: { only: %i[id name] } },
      only: %i[id quantity transaction_type created_at]
    )
  end

  def create
    transaction = Transaction.new(transaction_params)

    if transaction.save
      render json: {
        message: "Transaction created successfully",
        product: transaction.product.slice(:id, :name, :stock)
      }, status: :created
    else
      render json: { error: transaction.errors.full_messages.to_sentence },
             status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.permit(:product_id, :quantity, :transaction_type)
  end
end