class TransactionsController < ApplicationController
  before_action :set_product, only: :create

  def index
    transactions = Transaction.includes(:product).order(created_at: :desc).page(params[:page]).per(10)
    render json: transactions.as_json(include: { product: { only: [:id, :name] } },
                                      only: [:id, :quantity, :transaction_type, :created_at])
  end

  def create
    ActiveRecord::Base.transaction do
      @transaction = Transaction.new(transaction_params)
      if @transaction.save
        render json: {
          message: "Transaction created successfully",
          product: @transaction.product.slice(:id, :name, :stock)
        }, status: :created
      else
        render json: { error: @transaction.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::Rollback
    render json: { error: "Insufficient stock for product #{@product.name}" }, status: :unprocessable_entity
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Product not found" }, status: :not_found
  end

  def transaction_params
    params.permit(:product_id, :quantity, :transaction_type)
  end
end