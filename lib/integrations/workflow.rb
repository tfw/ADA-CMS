require 'ruby-debug'

class Integrations::Workflow
#  include TimeElapsedInWords
  
  def self.integrate(catalog_name, archive)
    log = Inkling::Log.create!(:category => "integration", :text => "#{archive.name} integration began.")
    statement = Nesstar::StatementEJB.find_by_objectId(catalog_name)

    Integrations::ArchiveCatalogs.create_or_update(statement, archive)

    study_ids = archive.studies.collect {|s| s.id}
    study_ids = study_ids.join ","
    study_ids = "(#{study_ids})" 
    studies_count = ArchiveStudy.count(:conditions => ["updated_at > ? and archive_id = ?", log.created_at, archive.id])
    vars_count = Variable.count(:conditions => ["updated_at > ? and study_id in #{study_ids}", log.created_at])
    rms_count = RelatedMaterial.count(:conditions => ["updated_at > ? and study_id in #{study_ids}", log.created_at])
    
    duration = time_in_words(Time.now, log.created_at)
    
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
  CONVERSIONS =
    [ [:seconds, :years,   31556952], # the average year in the Gregorian calendar
      [:seconds, :minutes,       60],
      [:minutes, :hours,         60],
      [:hours,   :days,          24],
      [:days,    :weeks,          7] ]

  UNIT_NAMES =
    [ [:years,   "year",   "years"  ],
      [:weeks,   "week",   "weeks"  ],
      [:days,    "day",    "days"   ],
      [:hours,   "hour",   "hours"  ],
      [:minutes, "minute", "minutes"],
      [:seconds, "second", "seconds"] ]

  def self.time_in_words(t2, t1)
    diff = (t2 - t1).to_i
    in_words(diff)
  end

  def self.in_words(seconds)
    units = CONVERSIONS.reduce({ :seconds => seconds }) do |data, conv|
      crunch(data, *conv)
    end
    nonzero = UNIT_NAMES.select do |key, s, p| units[key] > 0 end
    parts = nonzero.map do |key, singular, plural|
      n = units[key]
      "#{n} #{n == 1 ? singular : plural}"
    end
    
    case parts.length
    when 0
      "0 #{UNIT_NAMES.assoc(:seconds)[1]}"
    when 1
      parts[0]
    else
      "#{parts[0...-1].join ", "} and #{parts[-1]}" 
    end
  end

  private

  def self.crunch(data, smaller_unit, larger_unit, factor)
    smaller_amount = data[smaller_unit]
    data.merge({
      larger_unit  => smaller_amount / factor,
      smaller_unit => smaller_amount % factor
    })
  end
end