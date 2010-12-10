#a simple class for handling requests to Nesstar. Can be spawned by an object with a URL
#and will return an array of URLs, each representing a dataset in XML form

require 'nokogiri'

module Nesstar
  class QueryResponseParser
    include FileUtils::Verbose

    attr_accessor :query_response_document

    def initialize(query_response_document)
      @query_response_document = query_response_document
    end

    def datasets
      datasets = []
      file = File.read(@query_response_document)
      doc = Nokogiri::XML::Document.parse(file)

      node = doc.xpath("//r:Bag")

      for item in node.children
        resource = item.attribute('resource')
        datasets << resource.value if resource
      end

      datasets
    end
  end
end
