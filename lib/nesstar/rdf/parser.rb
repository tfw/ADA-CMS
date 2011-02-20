#The parser returns a hash representing the dataset and its entries

require 'nokogiri'

module Nesstar
  module RDF
    class Parser

      def self.parse(rdf_file)
# puts "\n #{rdf_file}"
        file = File.read("#{rdf_file}")
        doc = Nokogiri::XML::Document.parse(file)
# puts "#{doc.to_s} \n\n"

        study = doc.xpath('//p4:Study3').first
        about = study.attribute('about').value
        label = study.xpath(".//s:label").text
        universe = study.xpath(".//n35:universe").text
        abstract = study.xpath(".//n36:abstractText").text
        keywords = study.xpath(".//n35:keyWords").text

        dataset = {:about => about, :label => label, :universe => universe, :abstract => abstract,
                    :keywords => keywords}

        study.children.each do |node|
          node.attributes.each do |a, v|
            dataset["#{node.name}_attribute_#{a}".to_sym] = v.to_s
          end
          dataset[node.name.to_sym] = node.text
        end

        return dataset
      end


      def self.parse_related_materials_document(xml)
        file = File.read(xml)
        doc = Nokogiri::XML::Document.parse(file)
        related_material_entries = doc.xpath(".//p2:EGMSResource2")

        related_materials = []

        related_material_entries.each do |entry|
          material = {}
          entry.children.each do |node|
            material[node.name.to_sym] = node.text

            if node.name == "study"
              material[:study_resource] = node.attributes.first.last.text
            end
          end

          related_materials << material unless material.empty?
        end
        return related_materials
      end
    end
  end
end
