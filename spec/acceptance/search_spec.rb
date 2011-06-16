require File.dirname(__FILE__) + '/acceptance_helper'

feature "searching studies" do

  before(:all) do
    @pid = fork { Sunspot::Rails::Server.new.run }
    sleep 5 # allow some time for the instance to spin up
    ::Sunspot.session = ::Sunspot.session.original_session
  end
  
  before(:each) do
    10.times {Study.make()}
    reindex
  end

  def reindex
    Study.reindex
    Variable.reindex
  end
  
  scenario "the search form should lead to the search results page" do
    visit "/"
    page = search_form(Study.first.label.split(/\w/).first, page)
    page.status_code.should == 200
  end
  
  scenario "it should default to a studies title view if the format http param isnt set" do
    page = search_form("foo", page)
    page.should have_content("TITLE")    
  end
  
  scenario "a save search form should be available (if there is a current_user)" do
    search("foo", "title")
    click_link("Save")
    
    within(:xpath, "//span[@id='save-searches']") do
      page.should have_content "foo"
    end
  end  
end
