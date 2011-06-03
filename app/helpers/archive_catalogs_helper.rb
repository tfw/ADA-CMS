module ArchiveCatalogsHelper 
  include SearchHelper
  
  def line_break_title(title, limit)
    line_break = []
    bits = title.split(/\W/) 

    if bits.size > limit
      i = 0      
      for word in bits
        line_break << word
        i+= 1
        if i == limit
          line_break << "<br/>"
          i = 0
        end
      end
    else
      title
    end
    line_break.join " "
  end
end