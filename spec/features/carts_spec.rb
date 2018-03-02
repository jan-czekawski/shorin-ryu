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
    check_cart_content(@ticket)
    expect(@cart.sum_price).to eq @ticket.price * 3
    click_link "Shop"
    click_link "Show", href: item_path(@kimono)
    fill_in "Quantity", with: 3
    click_button "Add to cart"
    check_cart_content(@kimono)
    expect(@cart.sum_price).to eq @ticket.price * 3 + @kimono.price * 3
  end
  
  def check_cart_content(item)
    @cart = @user.reload.cart
    expect(current_path).to eq cart_path(@cart)
    expect(page).to have_content "Item has been added to your cart."
    expect(page).to have_content item.name
    expect(page).to have_content item.description
    expect(page).to have_content item.price
    expect(page).to have_content "Qty:"
    expect(page).to have_content "Total price:"
  end
end
