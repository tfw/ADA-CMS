module TimeElapsedInWords
  
  def time_elapsed_in_words(t2, t1)
    diff = (t2 - t1).to_i
    time_statement(diff)
  end
  
  def time_statement(diff, str = "")
    unless str.empty?
      str += " and "
    end

    case diff
      when 0..59
        str += "#{diff} seconds"
      when 60..3600
        minutes = diff / 60
        secs = diff % 60        
    
        if secs > 0
          str += "#{minutes} minutes and #{secs} seconds"
        else
          str += "#{minutes} minutes"
        end
      when 3601..86400 
        hours = diff / 360
        str += "#{hours} hours"
        remainder = diff % 360
        recurse_on_remainder(diff, 360, str)
      else #days 
        days = diff / (8640)
        str += "#{days} days"
        recurse_on_remainder(diff, 8640, str)
      end
  end
  
  def recurse_on_remainder(total, divisor, str)
    remainder = total % divisor
    
    if remainder > 0
      time_statement(remainder, str)
    else
      str
    end
  end
end