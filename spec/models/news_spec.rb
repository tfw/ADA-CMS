require 'spec_helper'
include Inkling::Util::Slugs

describe News do

  describe "validations" do
    context "news titles" do
      it "saves news with unique news title" do
        news = make_news
        news.errors.size.should == 0
      end

      it "is in an archive" do
        news = make_news(:archives => 1)
        news.archives.size.should == 1
      end

      it "rejects duplicate news titles" do
        news = make_news
        news.errors.any?.should == false

        news2 = News.new(:title => news.title, :user => news.user)
        news2.valid?.should == false
        news2.errors.any?.should == true
      end
    end

    it "requires an archive" do
      news = make_news(:archives => 0)
      news.archives.size.should == 0
      news.valid?
      pending "validates_at_least_one doesn't work correctly yet"
      news.errors.size.should == 1
    end
  end

  describe "belonging to an archive" do
    specify "news which belong to archives take the archive name as a prefix, e.g. social-science/home" do
      news = make_news
      a = news.archives[0]
      a.should_not be_nil
      na = news.news_archives[0]
      na.should_not be_nil
      pending "NewsArchive doesn't have a slug yet"
      na.slug.should == "/#{a.archive.slug}/#{sluggerize(news.title)}"
    end
  end

end
