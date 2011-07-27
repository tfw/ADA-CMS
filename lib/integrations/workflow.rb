require 'time_elapsed_in_words'

class Integrations::Workflow
#  include TimeElapsedInWords
  
  def self.integrate(catalog_name, archive)
    log = Inkling::Log.create!(:category => "integration", :text => "#{archive.name} integration began.")
    statement = Nesstar::StatementEJB.find_by_objectId("indigenous")

    Integrations::ArchiveCatalogs.create_or_update(statement, archive)

    study_ids = Study.all.collect {|s| s.id}
    study_ids = study_ids.join ","
    study_ids = "(#{study_ids})" 
    studies_count = ArchiveStudy.count(:conditions => ["updated_at > ? and archive_id = ?", log.created_at, archive.id])
    vars_count = Variable.count(:conditions => ["updated_at > ? and study_id in #{study_ids}", log.created_at])
    rms_count = RelatedMaterial.count(:conditions => ["updated_at > ? and study_id in #{study_ids}", log.created_at])
    
    duration = time_elapsed_in_words(Time.now, log.created_at)
    
    log_str = "#{archive.name} integration finished "
    
    if (studies_count + rms_count + vars_count > 0)    
      log_str += "(Updates or Creations - Studies:#{studies_count} / Related Materials: #{rms_count} / Variables: #{vars_count}) "
    else
      log_str += "(nothing new) "
    end
    
    log_str += "after #{duration}."
    Inkling::Log.create!(:category => "integration", :text => log_str)
  end
  
  
  # copied from lib/time_elapsed_in_words - the module inclusion is reporting ok but the method isnt appearing
  # will investigate later
  def self.time_elapsed_in_words(t2, t1)
    diff = (t2 - t1).to_i
    time_statement(diff)
  end
  
  def self.time_statement(diff, str = "")
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
  
  def self.recurse_on_remainder(total, divisor, str)
    remainder = total % divisor
    
    if remainder > 0
      self.time_statement(remainder, str)
    else
      str
    end
  end
end