module HelperMethods
  def visit_archive(name)
    visit "/staff/archives/#{name}"    
  end
  
  
end

RSpec.configuration.include HelperMethods, :type => :acceptance
