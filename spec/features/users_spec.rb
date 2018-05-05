require "rails_helper"
include Warden::Test::Helpers
Warden.test_mode!

feature "User management", type: :feature do
  scenario "adds a new user" do
    user = build(:user)
    visit root_path
    click_link "Sign up"
    expect do
      fill_in "Email", with: user.email
      fill_in "Login", with: user.login
      fill_in "Password", with: user.password
      fill_in "Password confirmation", with: user.password
      click_button "Create"
    end.to change(User, :count).by(1)
    expect(current_path).to eq root_path
    expect(page).to have_content "You have signed up successfully."
    within "li.nav-item.dropdown" do
      expect(page).to have_content "Signed in as #{user.login}"
    end
  end

  scenario "logs in a user" do
    user = create(:user)
    visit root_path
    click_link "Sign in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
    expect(current_path).to eq root_path
  end

  scenario "displays all users" do
    login_as create(:user)
    visit root_path
    click_link "Users"
    expect(current_path).to eq users_path
    within "h1" do
      expect(page).to have_content "Users"
    end
    User.each do |user|
      expect(page).to have_content user.login
    end
    expect(page).to have_css ".avatar", count: User.all.size
  end

  scenario "display single user" do
    user = create(:user)
    login_as(user)
    visit root_path
    click_link "Users"
    click_link "Show", href: user_path(user)
    within "h1" do
      expect(page).to have_content "Profile"
    end
    within ".card" do
      expect(page).to have_content user.login
      expect(page).to have_content user.created_at.strftime("%e-%b-%Y")
    end
  end

  scenario "updates a user" do
    user = create(:user)
    login_as(user)
    visit root_path
    click_link "Edit"
    expect(current_path).to eq edit_user_registration_path
    fill_in "Email", with: "another@email.com"
    fill_in "Password", with: "new_password"
    fill_in "Password confirmation", with: "new_password"
    fill_in "Current password", with: user.password
    click_button "Update"
    expect(current_path).to eq root_path
    expect(page).to have_content "Your account has been updated"
  end

  scenario "deletes a user" do
    login_as create(:user)
    visit root_path
    click_link "Edit"
    expect do
      click_button "Cancel my account"
    end.to change(User, :count).by(-1)
    expect(current_path).to eq root_path
    expect(page).to have_content "Your account has been successfully cancelled."
  end
end
