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
    click_link("News")
    page.should have_content("ADA News")
  end

  scenario "I can make news, save, view and re-edit it" do
    news = create_news(Archive.social_science, "test news", "sample content")
    page.should have_content("test news")
    click_link("Edit")
    page.should have_button('Update News')
  end

  scenario "I can delete news" do
    news = create_news(Archive.social_science, "test news", "sample content")

    # Find it, delete it:
    visit(staff_news_index_path)
    
    within("\#newsrow-#{news.id}") do |row|
      click_link("Delete")
    end
    lambda {
      visit(staff_news_path(news_id))
    }.should raise_error
    ArchiveNews.find(:all, :conditions => {:news_id => news.id}).size.should == 0
  end
end
