#The parser returns a hash representing the dataset and its entries

require 'nokogiri'

module Nesstar
  module RDF
    class Parser
      def self.parse(rdf_file)
        file = File.read("#{rdf_file}")
        doc = Nokogiri::XML::Document.parse(file)

        # study = doc.xpath('//p4:Study3').first
        study = doc.xpath('//p4:Study5').first
        # debugger
        about = study.attribute('about').value
        dataset = {:about => about}

        study.children.each do |node|
          hasherize_attributes(node, dataset)
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

      def self.parse_variables(xmlfile) 
        file = File.read(xmlfile)
        doc = Nokogiri::XML::Document.parse(file)
        # vars_entries = doc.xpath("//p4:Variable2")
        vars_entries = doc.xpath("//p4:Variable3")
        variables = []
        
        vars_entries.each do |var_xml|
          variable = {}
          var_xml.children.each do |node|            
            hasherize_attributes(node, variable)
            variable[node.name.to_sym] = node.text unless node.text.blank?
          end
          variables << variable unless variable.empty?
        end
        
        variables        
      end
      
      #takes the label from a catalogue file
      def self.parse_catalogue(xmlfile)
        file = File.read(xmlfile)
        doc = Nokogiri::XML::Document.parse(file)
        label = doc.xpath("//s:label")
        {:label => label.text}
      end
      
      def self.parse_catalogue_children(xmlfile)
        file = File.read(xmlfile)
        doc = Nokogiri::XML::Document.parse(file)
        node = doc.xpath("//r:Bag")
        children = []

        for item in node.children
          children << {:resource => item.attribute('resource'), :position => item.name}
        end
        
        children
      end
      
      
      def self.hasherize_attributes(node, hash)
        node.attributes.each do |a, v|
          next if v.blank?
          hash["#{node.name}_attribute_#{a}".to_sym] = v.to_s
        end  
      end
    end
  end
end
