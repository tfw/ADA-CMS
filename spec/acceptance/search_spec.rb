require File.dirname(__FILE__) + '/acceptance_helper'

feature "searching studies" do
  before(:all) do
    @pid = fork { Sunspot::Rails::Server.new.run }
    sleep 5 # allow some time for the instance to spin up
    ::Sunspot.session = ::Sunspot.session.original_session
  end
  
  before(:each) do
    10.times {Study.make()}
    
    100.times do |i| 
      study = Study.make(:label => "foo #{i}")
      archive_study = ArchiveStudy.create!(:study => study, :archive => Archive.ada)
    end
    
    reindex
    sleep 2
    @study_search_term = Study.first.label.split(/\W/).first
  end

  def reindex
    Study.reindex
    Variable.reindex
  end
  
  scenario "the search form should lead to the search results page (transient search)" do
    visit "/"
    search_form("foo", page) 
    page.should have_content "Search: foo" 
    page.should have_content "Searching for foo produced 100 results."
    page.status_code.should == 200
  end
  
  # scenario "the number of search results are reported" do
  #   sleep 6
  #   search("foo")
  #   page.should have_content "Searching for foo produced 100 results."
  # end
  
  # scenario "it should default to a studies title view if the format http param isnt set" do
  #   visit "/"
  #   search_form(@study_search_term, page)
  #   page.should have_content("TITLE")    
  # end
  
  # scenario "I can save a search if I'm authenticated" do
  #   archivist = make_user(:editor)
  #   sign_in(archivist)
  #   search(@study_search_term)
  #   
  #   click_link("Save")
  #   page.should have_content "Saved"
  # end  
end
