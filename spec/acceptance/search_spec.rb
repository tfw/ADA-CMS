require File.dirname(__FILE__) + '/acceptance_helper'

feature "searching studies" do
  before(:all) do
    @pid = fork { Sunspot::Rails::Server.new.run }
    sleep 5 # allow some time for the instance to spin up
    ::Sunspot.session = ::Sunspot.session.original_session
  end
  
  before(:each) do
    10.times {Study.make()}
    100.times {|i| Study.make(:label => "foo #{i}")} #for some searchable data
    reindex
    sleep 2
    @study_search_term = Study.first.label.split(/\W/).first
  end

  def reindex
    Study.reindex
    Variable.reindex
  end
  
  scenario "the search form should lead to the search results page" do
    visit "/"
    search_form(@study_search_term, page) 
    page.should have_content "Search: #{@study_search_term}" 
    page.status_code.should == 200
  end
  
  scenario "the number of search results are reported" do
    sleep 6
    search("foo")
    puts page.body
    # debugger
    page.should have_content "Searching for foo produced 100 results."
  end
  
  # scenario "it should default to a studies title view if the format http param isnt set" do
  #   visit "/"
  #   search_form(@study_search_term, page)
  #   page.should have_content("TITLE")    
  # end
  
  # scenario "a save search form should be available (if there is a current_user)" do
  #   archivist = make_user(:editor)
  #   sign_in(archivist)
  #   search(@study_search_term)
  #   
  #   click_link("Save")
  #   
  #   within(:xpath, "//span[@id='save-searches']") do
  #     puts page.body
  #     page.should have_content "#{@study_search_term.downcase}:"
  #   end
  # end  
end
