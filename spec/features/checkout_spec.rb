require "rails_helper"
include Warden::Test::Helpers
Warden.test_mode!

feature "Handle orders in checkout", type: :feature do
  scenario "move items from the cart to checkout" do
    user = build(:user)
    cart = build(:cart, user: user)
    item = build(:item)
    cart_item = create(:cart_item, item: item, cart: cart)
    login_as(user)
    visit cart_path(cart)
    click_link "Proceed to checkout"
    expect(current_path).to eq new_checkout_path
    expect(page).to have_content "Items in your checkout:"
    expect(page).to have_content cart.sum_price
    check "Standard delivery"
    click_button "Continue"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Doe"
    fill_in "Phone Number", with: "+48500800800"
    fill_in "Email Address", with: user.email
    fill_in "City", with: "Juarez"
    fill_in "Street", with: "Main Street"
    fill_in "House #", with: "100"
    fill_in "Zipcode", with: "22-300"
    click_button "Continue"
  end
end