module Staff::ActivityLogsHelper
  
  def log_icon(category)
    case category
    when "integration"
      image_tag('icons/server_connect.png')
    when "news"
      image_tag('icons/newspaper.png')
    when "page"
      image_tag('icons/page.png')
    when "users"
      image_tag('icons/user.png')
    when "search-index"
      image_tag('icons/database_refresh.png')     
    when "studies"
      image_tag('icons/bricks.png')        
    end
  end
end