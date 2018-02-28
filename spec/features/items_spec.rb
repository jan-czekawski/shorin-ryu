require "rails_helper"

feature "Items handling", type: :feature do
  after(:all) do
    Item.delete_all
    User.delete_all
  end
  
  before(:all) do
    @admin = create(:admin)
    @item = create(:item)
  end
  
  scenario "add a item" do
    item = build(:item)
    visit root_path
    login_as(@admin.email, @admin.password)
    click_link "Shop"
    expect(current_path).to eq items_path
    click_link "New item"
    expect(current_path).to eq new_item_path
    expect {
      fill_in "Name", with: item.name 
      fill_in "Description", with: item.description
      select item.size, from: "Size"
      fill_in "Price (PLN)", with: item.price
      fill_in "Item_id", with: item.store_item_id
      click_button "Create" 
    }.to change(Item, :count).by(1)
    expect(current_path).to eq items_path
    expect(page).to have_content "New item has been created."
  end
end