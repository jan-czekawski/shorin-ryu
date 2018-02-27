require "rails_helper"

feature "Events handling", type: :feature do
  after(:all) do
    Event.delete_all
    User.delete_all
  end
  
  before(:all) do
    @user = create(:user)
  end
  
  scenario "add an event" do
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
  
  scenario "display all events" do
    first_event = Event.first
    visit root_path
    click_link "Events"
    expect(current_path).to eq events_path
    Event.each do |event|
      check_content(event)
    end
    click_link "Show", href: event_path(first_event)
    check_content(first_event)
    expect(page).to have_content first_event.comments if first_event.comments.any? 
    expect(page).to have_content first_event.user.login
    expect(page).to have_content first_event.created_at.strftime("%e-%b-%Y")
  end
  
  def check_content(event)
    expect(page).to have_content event.image
    expect(page).to have_content event.name
    expect(page).to have_content event.address[:street]
    expect(page).to have_content event.address[:city]
    expect(page).to have_content event.address[:house_number]
    expect(page).to have_content event.address[:zip_code]
  end
end