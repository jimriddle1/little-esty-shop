require 'rails_helper'

RSpec.describe 'bulk discounts index page' do
  before :each do
    @merch1 = Merchant.create!(name: 'Floopy Fopperations')
    @customer1 = Customer.create!(first_name: 'Joe', last_name: 'Bob')
    @item1 = @merch1.items.create!(name: 'Floopy Original', description: 'the best', unit_price: 450)
    @item2 = @merch1.items.create!(name: 'Floopy Updated', description: 'the better', unit_price: 950)
    @item3 = @merch1.items.create!(name: 'Floopy Retro', description: 'the OG', unit_price: 550)
    @item4 = @merch1.items.create!(name: 'Floopy Geo', description: 'the OG', unit_price: 550)
    @invoice1 = @customer1.invoices.create!(status: 2)
    @invoice2 = @customer1.invoices.create!(status: 2)
    @invoice3 = @customer1.invoices.create!(status: 2)
    @invoice4 = @customer1.invoices.create!(status: 1)
    InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice1.id, quantity: 5, unit_price: 1000, status: 0, created_at: '2022-06-02 21:08:18 UTC')
    InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice2.id, quantity: 5, unit_price: 1000, status: 1, created_at: '2022-06-01 21:08:15 UTC')
    InvoiceItem.create!(item_id: @item3.id, invoice_id: @invoice3.id, quantity: 5, unit_price: 1000, status: 1, created_at: '2022-06-03 21:08:15 UTC')
    InvoiceItem.create!(item_id: @item3.id, invoice_id: @invoice4.id, quantity: 5, unit_price: 1000, status: 2, created_at: '2022-06-03 21:08:15 UTC')
    @bd_1 = @merch1.bulk_discounts.create!(percentage_discount: 10.00, quantity_threshold: 15)
    @bd_2 = @merch1.bulk_discounts.create!(percentage_discount: 20.00, quantity_threshold: 25)
  end

  it 'shows a link to all discounts, bulk discounts index page, see all discounts are linked and their info' do

    visit "/merchants/#{@merch1.id}/dashboard"
    click_link "All Discounts"
    visit "/merchants/#{@merch1.id}/bulk_discounts"

    expect(page).to have_content("Percent Discount: 10.0%")
    expect(page).to have_content("Quantity Threshold: 15")
    expect(page).to have_content("Percent Discount: 20.0%")
    expect(page).to have_content("Quantity Threshold: 25")
    expect(page).to_not have_content("Percent Discount: 30%")
    expect(page).to_not have_content("Quantity Threshold: 30")
    click_link "Discount #{@bd_1.id}"
    expect(current_path).to eq(merchant_bulk_discount_path("#{@bd_1.merchant.id}", "#{@bd_1.id}"))
    expect(page).to have_content("Discount: 10.0%")
    expect(page).to have_content("Quantity: 15")
  end

  it 'shows a link to create a new discount, taken to page with form' do
    visit merchant_bulk_discounts_path(@merch1.id)
    click_link "Create Discount"
    expect(current_path).to eq(new_merchant_bulk_discount_path(@merch1.id))
  end

  it 'shows a delete button and can remove a discount' do
    visit merchant_bulk_discounts_path(@merch1.id)
    within "##{@bd_2.id}" do
      click_link "Delete"
    end
    expect(current_path).to eq(merchant_bulk_discounts_path(@merch1.id))
    expect(page).to_not have_content("Percent Discount: 20.0%")
    expect(page).to_not have_content("Quantity Threshold: 25")
  end

  it 'shows upcoming holidays' do
    visit merchant_bulk_discounts_path(@merch1.id)
    save_and_open_page
    expect(page).to have_css('#holidays')
  end
end
