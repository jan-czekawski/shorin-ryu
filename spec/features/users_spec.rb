require "rails_helper"

feature "User management", :new do
  after(:all) do
    User.delete_all
  end
  
  before(:all) do
    @user = create(:user)
  end
  
  scenario "adds a new user" do
    user = build(:user)
    
    visit root_path
    click_link "Sign up"
    expect{
      fill_in "Email", with: user.email 
      fill_in "Login", with: user.login 
      fill_in "Password", with: user.password
      fill_in "Password confirmation", with: user.password
      click_button "Create"
    }.to change(User, :count).by(1)
    expect(current_path).to eq root_path
    expect(page).to have_content "You have signed up successfully."
    within "li.nav-item.dropdown" do
      "Signed in as #{user.login}"
    end
  end
  
  scenario "log in user" do
    login_as(@user)
  end
  
  scenario "update a user" do
    login_as(@user)
    click_link "Edit"
    expect(current_path).to eq edit_user_registration_path
    fill_in "Email", with: "another@email.com"
    fill_in "Password", with: "new_password"
    fill_in "Password confirmation", with: "new_password"
    fill_in "Current password", with: @user.password
    click_button "Update"
    expect(current_path).to eq root_path
    expect(page).to have_content "Your account has been updated"
  end
  
  scenario "delete a user" do
    user = create(:user)
    login_as(user)
    click_link "Edit"
    expect {
      click_button "Cancel my account"
    }.to change(User, :count).by(-1)
    expect(current_path).to eq root_path
    expect(page).to have_content "Your account has been successfully cancelled."
  end
  
  def login_as(user)
    visit root_path
    click_link "Sign in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
    expect(current_path).to eq root_path
  end
end