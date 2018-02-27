require "rails_helper"

feature "Events handling", type: :feature do
  after(:all) do
    Event.delete_all
    User.delete_all
  end
  
  before(:all) do
    @admin = create(:admin)
    @event = create(:event)
  end
  
  scenario "add an event" do
    event = build(:event)
    login_as(@admin.email, @admin.password)
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
    visit root_path
    click_link "Events"
    expect(current_path).to eq events_path
    Event.each do |event|
      check_content(event)
    end
    click_link "Show", href: event_path(@event)
    check_content(@event)
    expect(page).to have_content @event.comments if @event.comments.any? 
    expect(page).to have_content @event.user.login
    expect(page).to have_content @event.created_at.strftime("%e-%b-%Y")
  end
  
  scenario "update an event" do
    login_as(@admin.email, @admin.password)
    click_link "Events"
    click_link "Edit", href: edit_event_path(@event)
    fill_in "Name", with: "New Event Nam"
    fill_in "Street", with: "Quarter Street"
    fill_in "House #", with: 32
    fill_in "City", with: "Los Alamos"
    fill_in "Zip code", with: "22-333"
    click_button "Update"
    expect(current_path).to eq event_path(@event)
    expect(page).to have_content "Event was successfully updated!"
  end
  
  scenario "delete an event" do
    login_as(@admin.email, @admin.password)
    click_link "Events"
    click_link "Show", href: event_path(@event)
    expect {
      click_link "Delete"
    }.to change(Event, :count).by(-1)
    expect(current_path).to eq events_path
    expect(page).to have_content "Event was successfully deleted!"
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