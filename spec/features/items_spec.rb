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
  
  scenario "add an item" do
    item = build(:item)
    login_as(@admin.email)
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
  
  scenario "visit items_path" do
    visit root_path
    login_as(@admin.email)
    click_link "Shop"
    Item.each do |item|
      check_content(item)
    end
  end
  
  scenario "update an item" do
    login_as(@admin.email)
    click_link "Shop"
    expect(current_path).to eq items_path
    click_link "Show", href: item_path(@item)
    check_content(@item)
    click_link "Edit item"
    expect(current_path).to eq edit_item_path(@item)
    fill_in "Name", with: "change_name"
    fill_in "Item_id", with: 100100
    click_button "Update"
    expect(current_path).to eq item_path(@item)
    expect(page).to have_content "Item has been updated."
  end
  
  scenario "delete an item" do
    login_as(@admin.email)
    click_link "Shop"
    click_link "Show", href: item_path(@item)
    expect {
    click_link "Delete"
    }.to change(Item, :count).by(-1)
    expect(current_path).to eq items_path
    expect(page).to have_content "Item has been deleted"
    expect(page).not_to have_content @item.name
  end
  
  def check_content(item)
    expect(page).to have_content item.image
    expect(page).to have_content item.name
    expect(page).to have_content item.description
    expect(page).to have_content item.store_item_id
  end
end