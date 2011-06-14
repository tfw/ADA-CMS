require 'spec_helper'

describe Search, "a saved search" do
  
 specify "validates on user and title" do
   user = make_user(:editor)
   search1 = Search.make(:user => user)
   search1.valid?.should be_true
   search2 = Search.new(:user => search1.user, :title => search1.title)
   search2.valid?.should be_false
 end
end
