require "rails_helper"

feature "Events handling", type: :feature do
  after(:all) do
    Event.delete_all
    User.delete_all
  end
  
  before(:all) do
    @user = create(:user)
  end
  
  scenario "add new event" do
    event = build(:event)
    login_as(@user.email, @user.password)
    click_link "Events"
    expect(current_path).to eq events_path
    click_link "New event"
    expect(current_path).to eq new_event_path
    expect {
      fill_in "Name", with: event.name
      fill_in "Street", with: event.address[:street]
      fill_in "House #", with: event.address[:house_number]
      fill_in "City", with: event.address[:city]
      fill_in "Zip code", with: event.address[:zip_code]
      click_button "Create"
    }.to change(Event, :count).by(1)
    expect(current_path).to eq events_path
    expect(page).to have_content "New event was created!"
  end
end