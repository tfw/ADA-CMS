require 'spec_helper'
include Inkling::Util::Slugs

describe News do

  describe "validations" do
    context "news titles" do

      before(:each) {@news = News.make}

      it "saves news with unique news title" do
        @news.errors.size.should == 0
      end

      it "is in an archive" do
        ArchiveNews.make(:news => @news)
        @news.reload
        @news.archives.size.should == 1
      end

      it "rejects duplicate news titles" do
        @news.errors.any?.should == false

        news2 = News.new(:title => @news.title, :user => @news.user)
        news2.valid?.should == false
        news2.errors.any?.should == true
      end

      it "can be approved for publishing" do
        admin = make_user(:administrator)
        @news.publish!(admin)
        @news.published?.should == true
      end
    end
  end
end
