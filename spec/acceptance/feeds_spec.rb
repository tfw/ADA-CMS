require File.dirname(__FILE__) + '/acceptance_helper'

feature "serving out feeds" do
  
  scenario "requesting the url of a feed should deliver a feed document" do
    archive = Archive.make
    news = News.make
    archive_news = ArchiveNews.create!(:archive => archive, :news => news)
    feed = Inkling::Feed.create!(:title => "#{archive.name} Atom Feed", :format => "Inkling::Feeds::Atom", :source => "ArchiveFeedsSource", :authors => archive.name, :criteria => {:archive_id => archive.id})    
    visit archive_news.path.slug
    click_link feed.title
    page.status_code.should == 200
    page.should have_content(news.body)
  end
end
