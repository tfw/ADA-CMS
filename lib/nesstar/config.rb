module Nesstar
  module AtsidaConfig
    # $nesstar_server = "http://palo.anu.edu.au:80"
    $nesstar_server = "http://nesstar.ada.edu.au"
    $tmp_dir = File.dirname(__FILE__) + "/../../tmp/"
    $nesstar_dir = "#{$tmp_dir}nesstar/"
    # $rss_dir = "#{$tmp_dir}rss/"
    $xml_dir = "#{$nesstar_dir}xml/"
    $studies_xml_dir = "#{$xml_dir}studies/"
    $related_xml_dir = "#{$xml_dir}related/"
    $variables_xml_dir = "#{$xml_dir}variables/"
    $catalogues_xml_dir = "#{$xml_dir}catalogues/"
  end
end
