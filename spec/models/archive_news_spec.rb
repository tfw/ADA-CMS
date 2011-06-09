require 'spec_helper'
include Inkling::Util::Slugs

describe ArchiveNews do
  
  describe "belonging to an archive" do
    specify "news which belong to archives take the archive name as a prefix, e.g. social-science/home" do
      archive = Archive.make
      news = News.make
      ArchiveNews.make(:news => news, :archive => archive)
      a = news.archives[0]
      a.should_not be_nil
      na = news.archive_news[0]
      na.should_not be_nil
      na.path.slug.should =~ %r{/#{a.slug}/news/\d\d\d\d/\d\d/\d\d/#{sluggerize(news.title)}}
    end
  end
end
