class BulkDiscountsController < ApplicationController

  def index
    @bulk_discounts = BulkDiscount.all
    @holidays = HolidayFacade.new
    @holidays.upcoming_holidays
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

  def edit
    @bulk_discount_edit = BulkDiscount.find(params[:id])
  end

  def update
    @bulk_discount = BulkDiscount.find(params[:id])
    @bulk_discount.update(bulk_discount_params)
    @bulk_discount.save

    redirect_to merchant_bulk_discount_path(@bulk_discount.merchant_id, @bulk_discount.id)
  end

  def delete

  end

  def destroy
    @bulk_discount = BulkDiscount.find(params[:id])
    @bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path
  end

  private

    def bulk_discount_params
      params.permit(:percentage_discount, :quantity_threshold)
    end


end
