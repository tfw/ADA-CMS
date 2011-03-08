# require File.dirname(__FILE__) + '/../spec_helper'
# 
# describe SearchController do
#   ThinkingSphinx::Test.start
#   
#   # before(:all) do
#   #   `rake RAILS_ENV=test thinking_sphinx:index`
#   # end
#   
#   before(:each) do
#     @archive1 = Archive.make
#     @archive2 = Archive.make
#   end
# 
#   it "should search in specified archive" do
#     study = Study.make()
#     archive_study1 = ArchiveStudy.create!(:archive => @archive1, :study => study)
#     archive_study2 = ArchiveStudy.create!(:archive => @archive2, :study => study)
#    
#     ThinkingSphinx::Test.index
#     sleep(0.25)
#     
#     get :sphinx, {:term => study.abstract.split(" ").first, :archive_id => @archive1.id}
#     debugger
#     assigns[:sphinx].size.should > 0
#     puts "oo"
#   end
# 
#   ThinkingSphinx::Test.stop
# end
