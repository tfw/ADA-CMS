require 'spec_helper'
include Inkling::Slugs

describe PageObserver do

  describe "log creation on page callbacks" do
    it "saves a log after save" do
      page = Page.make
      Inkling::Log.all.size > 0
      Inkling::Log.first.text.has_content "created page #{page.title}"
    end
  end
end
