require 'spec_helper'

describe PageObserver do

  describe "log creation on page callbacks" do
    it "saves a log after save" do
      page = Page.make
      Inkling::Log.all.size > 0
      Inkling::Log.first.text.should =~ /created page #{page.title}/
    end
    
    it "saves a log after update" do
      page = Page.make
      page.body = "changed!"
      Inkling::Log.all.size > 0
      Inkling::Log.last.text.should =~ /edited page #{page.title}/
    end
    
    it "saves a log after destroy" do
      page = Page.make
      page.destroy
      Inkling::Log.all.size > 0
      Inkling::Log.last.text.should =~ /deleted page #{page.title}/
    end
  end
end
