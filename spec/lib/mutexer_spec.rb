require 'spec_helper'

describe Mutexer do

  before(:each) { Mutexer.reset }
  
  specify "that the right amount of mutexes are being created" do
    Mutexer::MUXES.size.should == Mutexer::LIMIT
  end

  specify "that available mutexes are all unlocked and match Mutexer::LIMIT" do
    Mutexer::LIMIT.times do 
      available = Mutexer.available
      available.locked?.should be_false
      available.lock
    end
  end
  
  specify "that when all mutexes are locked, nothing is available" do
    Mutexer::LIMIT.times do 
      available = Mutexer.available
      available.lock
    end
    
    Mutexer.available.should be_nil
  end
end
