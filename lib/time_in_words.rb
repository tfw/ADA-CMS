module TimeInWords
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

  def time_in_words(t2, t1)
    diff = (t2 - t1).to_i
    in_words(diff)
  end

  def in_words(seconds)
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

  def crunch(data, smaller_unit, larger_unit, factor)
    smaller_amount = data[smaller_unit]
    data.merge({
      larger_unit  => smaller_amount / factor,
      smaller_unit => smaller_amount % factor
    })
  end
end