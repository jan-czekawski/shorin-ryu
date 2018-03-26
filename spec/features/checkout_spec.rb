require "rails_helper"
include Warden::Test::Helpers
Warden.test_mode!

feature "Handle orders in checkout", type: :feature do
  scenario "move items from the cart to checkout", js: true, slow: true do
    user = build(:user)
    cart = build(:cart, user: user)
    item = build(:item)
    create(:cart_item, item: item, cart: cart)
    login_as(user)
    visit cart_path(cart)
    click_link "Proceed to checkout"
    expect(current_path).to eq edit_checkout_path(cart.checkout)
    expect(page).to have_content "Items in your checkout:"
    expect(page).to have_content cart.sum_price
    choose "Standard delivery"
    click_button "Continue", id: "from_delivery_method"
    within ".delivery_address" do
      fill_in "First Name", with: "John"
      fill_in "Last Name", with: "Doe"
      fill_in "Phone Number", with: "+48500800800"
      fill_in "Email Address", with: user.email
      fill_in "City", with: "Juarez"
      fill_in "Street", with: "Main Street"
      fill_in "House #", with: "100"
      fill_in "Zipcode", with: "22-300"
    end
    click_button "Continue", id: "from_delivery_address"
    click_button "Use delivery address"
    within ".billing_address" do
      expect(page).to have_field("First Name", with: "John")
      expect(page).to have_field("Last Name", with: "Doe")
      expect(page).to have_field("Phone Number", with: "+48500800800")
      expect(page).to have_field("Email Address", with: user.email)
      expect(page).to have_field("City", with: "Juarez")
      expect(page).to have_field("Street", with: "Main Street")
      expect(page).to have_field("House #", with: "100")
      expect(page).to have_field("Zipcode", with: "22-300")
    end
    # click_button "Continue"
  end
end