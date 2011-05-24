require 'spec_helper'
include Inkling::Util::Slugs

describe ArchiveNews do
  
  describe "belonging to an archive" do
    specify "news which belong to archives take the archive name as a prefix, e.g. social-science/home" do
      news = make_news
      a = news.archives[0]
      a.should_not be_nil
      na = news.news_archives[0]
      na.should_not be_nil
      na.path.slug.should =~ %r{/#{a.slug}/news/\d\d\d\d/\d\d/\d\d/#{sluggerize(news.title)}}
    end
  end
end
