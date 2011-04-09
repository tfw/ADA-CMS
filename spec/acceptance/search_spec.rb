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
    search_form(Study.first.label.split(/\w/).first)
    page.status_code.should == 200
  end
  
  scenario "it should default to a studies title view if the format http para isnt set" do
    search_form("foo")
    page.should have_content("TITLE")    
  end
  
  scenario "the view http param should define whether jquery renders onload the title view (study), extended view (study, or variables)" do
    search("foo", "title")
    puts page.body
    page.should have_content("TITLE")
    search("foo", "ext")
    page.should have_content("EXTENDED")
    search("foo", "var")    
    page.should_not have_content("EXTENDED")
    page.should_not  have_content("TITLE")
  end
end
