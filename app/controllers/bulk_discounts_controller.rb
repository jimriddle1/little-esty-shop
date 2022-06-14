class BulkDiscountsController < ApplicationController

  def index
    @bulk_discounts = BulkDiscount.all
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @bulk_discount_new = BulkDiscount.new
    # redirect_to merchant_bulk_discounts_path
  end

  def create
    @merch = Merchant.find(params[:merchant_id])
    bd = @merch.bulk_discounts.create(bulk_discount_params)
    redirect_to merchant_bulk_discounts_path
  end

  private

    def bulk_discount_params
      params.require(:bulk_discount).permit(:percentage_discount, :quantity_threshold)
    end


end
