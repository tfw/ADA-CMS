require File.dirname(__FILE__) + '/acceptance_helper'

feature "searching studies" do
  
  scenario "the search form should lead to the search results page" do
    10.times {Study.make()}
    reindex
    visit "/"
    fill_in("search_term", :with =>  Study.first.label.split(/\w/).first)
    click_button("Go") 
    
    page.status_code.should == 200
  end
  
  
  def reindex
    Study.reindex
    Variable.reindex
  end
end
