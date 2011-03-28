#The parser returns a hash representing the dataset and its entries

require 'nokogiri'

module Nesstar
  module RDF
    class Parser
      def self.parse(rdf_file)
        file = File.read("#{rdf_file}")
        doc = Nokogiri::XML::Document.parse(file)

        study = doc.xpath('//p4:Study3').first
        about = study.attribute('about').value
        dataset = {:about => about}

        study.children.each do |node|
          node.attributes.each do |a, v|
            dataset["#{node.name}_attribute_#{a}".to_sym] = v.to_s
          end
          dataset[node.name.to_sym] = node.text
        end

        dataset
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
        related_materials
      end

      def self.parse_variables(xml) 
        file = File.read(xml)
        doc = Nokogiri::XML::Document.parse(file)
        variables_entries = doc.xpath("//p4:Variable2")
        
        variables = []
        
        variables_entries.each do |xml_var|
          variable = {}
          xml_var.each do |node|
            variable[node.name.to_sym] = node.text
          end
          variables << variable unless variable.empty?
        end
        
        variables        
      end
    end
  end
end
