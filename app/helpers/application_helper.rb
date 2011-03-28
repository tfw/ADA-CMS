module ApplicationHelper
  
  def archive_css(archive)
    archive.name == "ADA" ? 'default' : archive.name.gsub(" ", "").underscore
  end
  
  def nesstar_link(dataset)
    study_id = dataset.about.split(".").last
    return "http://assda-nesstar.anu.edu.au/webview/index.jsp?study=http%3A%2F%2Fassda-nesstar.anu.edu.au%3A80%2Fobj%2FfStudy%2Fau.edu.anu.assda.ddi.#{study_id}&amp;v=2&amp;mode=documentation&amp;submode=abstract&amp;top=yes"
  end
  
  def first_n_words(n, words)
    return if words.nil?
    words = words.gsub(/<\/?[^>]*>/, "").split(/\W/m).reject{|w| w.empty? }
    words = words.size > n ? words[0...n]+['...'] : words
    words * ' '
  end
  
  def archive_icon(archive)
    file_name = archive.slug.gsub("-", "")
    image_tag("structure/icon_#{file_name}.png")  
  end
  
  #outputs a deployment message for Product Owner to watch (so they now how fresh the code is)
  def deploy_log
    if File.exists?("tmp/deploy-log.txt")
      log = File.read("tmp/deploy-log.txt")
    end
  end
  
  #this checks to see if a human readable mapping (DdiMapping) exists for the DDI element
  def human_readable_check(ddi, dataset, current_user)
    mapping = DdiMapping.find_by_ddi(ddi)

    if mapping.nil?
      ddi
    else
     mapping.human_readable
    end
  end
end
