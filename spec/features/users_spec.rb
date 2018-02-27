require "rails_helper"

feature "User management", :new do
  after(:all) do
    User.delete_all
  end
  
  scenario "adds a new user" do
    user = create(:user)
    
    visit root_path
    click_link "Sign in"
    fill_in "Email", with: user.email 
    fill_in "Password", with: user.password
    click_button "Log in"
  end
end