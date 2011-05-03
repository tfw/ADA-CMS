class NewsObserver < ActiveRecord::Observer
  include Rails.application.routes.url_helpers
   
  def after_create(news)
    log("created", news) if news.created_at == news.updated_at
  end

  def after_save(news)
    log("edited", news) if news.created_at != news.updated_at
  end
  
  def after_destroy(news)
    log("deleted", news)    
  end
  
  private
  def log(verb, news)
    Inkling::Log.create!(
      :text => "#{
          news.user
        } #{
          verb
        } news <a href='#{edit_staff_news_path(news)}'>#{news.title}</a>" +
        " in #{
          if (nas = news.news_archives).size == 0
            "no archives"
          else
            nas.map do |na|
              "<a href='#{na.path.slug}'>#{na.archive.name}</a>."
            end*", "
          end
        }",
      :category => "news"
    )
  end
end
