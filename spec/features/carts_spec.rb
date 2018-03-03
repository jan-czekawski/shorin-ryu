require "rails_helper"

feature "Cart management", type: :feature do
  before(:all) do
    @user = create(:user)
    @ticket = create(:item, name: "ticket")
    @kimono = create(:item, name: "kimono", price: 10)
  end

  scenario "add item to a cart" do
    login_as(@user.email)
    click_link "Shop"
    click_link "Show", href: item_path(@ticket)
    expect do
      fill_in "Quantity", with: 3
      click_button "Add to cart"
    end.to change(CartItem, :count).by(1)
    expect(page).to have_content "Item has been added to your cart."
    check_cart_content(@user)
    click_link "Shop"
    click_link "Show", href: item_path(@kimono)
    expect do
      fill_in "Quantity", with: 7
      click_button "Add to cart"
    end.to change(CartItem, :count).by(1)
    expect(page).to have_content "Item has been added to your cart."
    check_cart_content(@user)
    click_link "Shop"
    click_link "Show", href: item_path(@kimono)
    expect do
      fill_in "Quantity", with: 100
      click_button "Add to cart"
    end.not_to change(CartItem, :count)
    expect(page).to have_content "Item's quantity in the cart has been updated."
    check_cart_content(@user)
  end
  
  # scenario "increase quantity of item already in cart", js: true do
  scenario "increase quantity of item already in cart" do
    login_as(@user.email)
    @cart = @user.cart
    click_link "Your cart"
    last_item = @cart.cart_items.last
    # expect(page).to have_content last_item.id
    within "##{last_item.item.name}_id" do
      # expect do
        # fill_in "Quantity", with: (last_item.quantity + 1)
      #   click_button "Update cart"
      # end.to change(@user.reload.cart.cart_items.last, :quantity).by(1)
    end
  end
  
  scenario "delete item from cart" do
    login_as(@user.email)
    click_link "Your cart"
    check_cart_content(@user)
    last_item = @user.cart.cart_items.last
    path_of_item = cart_item_path(last_item.cart, last_item)
    expect(page).to have_link "Delete item", href: path_of_item
    expect do
      path = cart_item_path(@user.cart, last_item)
      # TODO: delete items quantity, check if item still should be in cart
      # fill_in ""
      click_link "Delete item", href: path
    end.to change(CartItem, :count).by(-1)
    expect(current_path).to eq cart_path(@user.cart)
    expect(page).to have_content "Item has been deleted from your cart."
    expect(page).not_to have_link "Delete item", href: path_of_item
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
