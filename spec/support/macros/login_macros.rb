module LoginMacros
  def login_as(email, password)
    visit root_path
    click_link "Sign in"
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Log in"
    expect(current_path).to eq root_path
  end
end