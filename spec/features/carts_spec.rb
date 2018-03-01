require "rails_helper"

feature "Cart management", type: :feature do
  before(:all) do
    @user = create(:user)
    @ticket = create(:item, name: "ticket")
    @kimono = create(:item, name: "kimono", price: 10)
  end
  
  after(:all) do
    User.delete_all
    Item.delete_all
    Cart.delete_all
    CartItem.delete_all
  end
  
  scenario "add item to a cart" do
    login_as(@user.email)
    click_link "Shop"
    click_link "Show", href: item_path(@ticket)
    fill_in "Quantity", with: 3
    click_button "Add to cart"
    cart = @user.reload.cart
    expect(current_path).to eq cart_path(cart)
    expect(page).to have_content "Item has been added to your cart."
    expect(page).to have_content @ticket.name
    expect(page).to have_content @ticket.description
    expect(page).to have_content @ticket.price
    expect(page).to have_content "Qty:"
    expect(page).to have_content "Total price:"
    click_link "Shop"
    click_link "Show", href: item_path(@kimono)
    fill_in "Quantity", with: 3
    click_button "Add to cart"
    cart = @user.reload.cart
    expect(current_path).to eq cart_path(cart)
    expect(page).to have_content "Item has been added to your cart."
    expect(page).to have_content @kimono.name
    expect(page).to have_content @kimono.description
    expect(page).to have_content @kimono.price
    expect(page).to have_content "Qty:"
    expect(page).to have_content "Total price:"
    p cart.sum_price
  end
end