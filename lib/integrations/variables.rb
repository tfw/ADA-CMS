class Integrations::Variables

  def self.create_or_update_by_study(study)
    GC.start
    variables = Nesstar::VariableEJB.find_all_by_studyID(study.stdy_id)
    
    for variable in variables
      Variable.create_or_update_from_nesstar(variable)
    end
  end
end