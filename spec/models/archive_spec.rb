require 'spec_helper'

describe Archive do

  describe "urls at backend" do
    context "generating slugs from archive names" do
      it "reduces an archive name to a url friendly format" do
        archive = Archive.make(:name => "Test Archive")
        archive.slug.should == "test-archive"
      end
    end
  end
end
