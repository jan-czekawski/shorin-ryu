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
    expect(page).to have_content "Item has been added to your cart."
    check_cart_content(@user)
    click_link "Shop"
    click_link "Show", href: item_path(@kimono)
    fill_in "Quantity", with: 7
    click_button "Add to cart"
    expect(page).to have_content "Item has been added to your cart."
    check_cart_content(@user)
  end
  
  scenario "delete item from cart" do
    login_as(@user.email)
    visit cart_path(@user.cart)
    click_link "Your cart"
    check_cart_content(@user)
  end
  
  def check_cart_content(user)
    @cart = user.reload.cart
    expect(current_path).to eq cart_path(@cart)
    total_price = 0
    if @cart.cart_items.any?
      @cart.cart_items.each do |c_item|
        expect(page).to have_content c_item.item.name
        expect(page).to have_content c_item.item.description
        expect(page).to have_content c_item.item.price
        expect(page).to have_content "Qty:"
        expect(page).to have_content c_item.quantity
        path = cart_item_path(c_item.cart, c_item)
        expect(page).to have_link "Delete item", href: path
        total_price += c_item.item.price * c_item.quantity
      end
    end
    expect(page).to have_content "Total price:"
    expect(@cart.sum_price).to eq total_price
  end
end
