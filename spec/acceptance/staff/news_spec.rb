require File.dirname(__FILE__) + '/../acceptance_helper'

feature "Creating news" do

  background do
    @admin = make_user(:administrator)
    sign_in(@admin)
  end

  after(:each) do
    sign_out
  end

  scenario "I can access the news administration page"  do
    visit(user_root_path)
    click_link("News")
    page.should have_content("ADA News Tasks")
    page.should have_content("Add a new News Item")
  end

  scenario "I can make news, save, view and re-edit it" do
    news = create_news(Archive.social_science, "test page", "sample content")
    page.should have_content("test page")
    page.should have_content("In archive Social Science")
    click_link("Edit")
    page.should have_button('Update News')
  end

end
