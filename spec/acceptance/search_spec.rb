require File.dirname(__FILE__) + '/acceptance_helper'

feature "searching" do
  
  before(:all) do
    @pid = fork { Sunspot::Rails::Server.new.run }
    sleep 5 # allow some time for the instance to spin up
    ::Sunspot.session = ::Sunspot.session.original_session
  end
  
  before(:each) do    
    100.times do |i| 
      study = Study.make(:label => "foo #{i}")
      archive_study = ArchiveStudy.create!(:study_id => study.id, :archive => Archive.ada)
    end
    
    for study in Study.all[0..4] #create vars in first 5 studies 
      (0..9).each do |i|
        str = "var #{study.id} #{i}"
        Variable.make(:study_id => study.id, :label => str, :name => str)
      end
    end
    
    reindex
    @study_search_term = Study.first.label.split(/\W/).first
  end

  def reindex
    Study.reindex
    Variable.reindex
    sleep 2
  end
  
  context "for variables" do
    scenario "should show data when the variables tab is clicked on" do
      search("var") 
      click_link("variables-link")

      page.should have_content "var 1 0"
      page.should have_content "var 1 9"
    end

    #unsure why this isn't passing - there's a state issue in the index for variables. Put this test first in line, it passes
    scenario "pagination works" do
      search("var")
      click_link("variables-link")

      page.should have_content "var 1 0"
      page.should have_content "var 3 9"    
      page.should_not have_content "var 4 0"

      click_link "2"

      page.should have_content "var 4 0"
    end    
  end

  context "for studies " do
    scenario "the search form should lead to the search results page (transient search)" do
      visit "/"
      search_form("foo", page) 
      page.should have_content "Search: foo" 
      page.should have_content "Searching for foo produced 100 results."
    end
  
    scenario "I can save a search if I'm authenticated" do
      archivist = make_user(:editor)
      sign_in(archivist)
      search("foo")
    
      click_link("Save this search")
      click_button("Save")
      archivist.reload
      archivist.searches.first.title.should == "foo"
    end  
  
    scenario "pagination works" do
      search("foo")
    
      29.times do |n|
        page.should have_content "foo #{n}"
      end
    
      page.should_not have_content "foo 30"
    
      click_link "2"
    
      page.should_not have_content "foo 0"
    
      (30..59).each do |n|
        page.should have_content "foo #{n}"
      end
    end
  end
end
