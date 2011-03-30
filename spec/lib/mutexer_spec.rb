require 'spec_helper'

describe Mutexer do

  before(:each) { Mutexer.reset }

  specify "that available mutexes are all unlocked and match Mutexer::LIMIT" do
    # debugger
    [0..Mutexer::LIMIT].each do |i|
      available = Mutexer.available
      available.locked?.should be_false
      available.lock
    end
  end
  
  specify "that when all mutexes are locked, nothing is available" do
    [0..Mutexer::LIMIT].each do |i|
      available = Mutexer.available
      available.lock
    end
    
    Mutexer.available.should be_nil
  end
end
