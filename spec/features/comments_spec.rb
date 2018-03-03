require "rails_helper"

feature "Adding and deleting comments", type: :feature do
  before(:all) do
    @user = create(:user)
    @item = create(:item)
    @event = create(:event)
  end

  scenario "add a comment" do
    login_as(@user.email)
    visit_events(@event)
    handle_create(@event)
    visit_items(@item)
    handle_create(@item)

  end

  scenario "delete a comment" do
    login_as(@user.email)
    visit_events(@event)
    handle_delete(@event)
    visit_items(@item)
    handle_delete(@item)
  end

  def visit_events(event)
    click_link "Events"
    click_link "Show", href: event_path(event)
  end

  def visit_items(item)
    click_link "Shop"
    click_link "Show", href: item_path(item)
  end

  def handle_delete(resource)
    type = resource.class.name.downcase
    path = "/#{type}s/#{resource.id}"
    comment_href = "/#{type}s/#{resource.id}/comments/" \
                   "#{resource.comments.last.id}"
    last_comment = Comment.last
    expect do
      click_link "Delete", href: comment_href
    end.to change(Comment, :count).by(-1)
    expect(current_path).to eq path
    expect(page).to have_content "Comment has been deleted."
    expect(page).not_to have_content last_comment.content
  end

  def handle_create(resource)
    type = resource.class.name.downcase
    path = "/#{type}s/#{resource.id}"
    expect do
      fill_in "Content", with: "Some random event comment"
      click_button "Add comment"
    end.to change(Comment, :count).by(1)
    last_comment = Comment.last
    expect(current_path).to eq path
    expect(page).to have_content "New comment has been added!"
    expect(page).to have_content last_comment.content
    path_of_comment = "/#{type}s/#{resource.id}/comments/#{last_comment.id}"
    expect(page).to have_link "Delete", href: path_of_comment
    visit path
    expect do
      fill_in "Content", with: nil
      click_button "Add comment"
    end.not_to change(Comment, :count)
    expect(page).to have_content "Content can't be blank"
  end
end
