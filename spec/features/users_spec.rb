require "rails_helper"

feature "User management", type: :feature do
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
      expect(page).to have_content "Signed in as #{user.login}"
    end
  end
  
  scenario "logs in a user" do
    login_as(@user.email, @user.password)
  end
  
  scenario "displays all users" do
    login_as(@user.email, @user.password)
    click_link "Users"
    expect(current_path).to eq users_path
    within "h1" do
      expect(page).to have_content "Users"
    end
    User.each do |user|
      expect(page).to have_content user.login
      expect(page).to have_content user.image
    end
  end
  
  scenario "display single user" do
    login_as(@user.email, @user.password)
    click_link "Users"
    click_link "Show", href: user_path(@user)
    within "h1" do
      expect(page).to have_content "Profile"
    end
    within ".card" do
      expect(page).to have_content @user.login
      expect(page).to have_content @user.created_at.strftime("%e-%b-%Y")
    end
  end
  
  scenario "updates a user" do
    login_as(@user.email, @user.password)
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
  
  scenario "deletes a user" do
    login_as("another@email.com", "new_password")
    click_link "Edit"
    expect {
      click_button "Cancel my account"
    }.to change(User, :count).by(-1)
    expect(current_path).to eq root_path
    expect(page).to have_content "Your account has been successfully cancelled."
  end
end