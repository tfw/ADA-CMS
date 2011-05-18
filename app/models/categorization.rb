class Categorization < ActiveRecord::Base

  belongs_to :category
  belongs_to :study

  def validate
    pre_existing = Categorization.find_by_category_id_and_study_id(self.category.id, self.study_id)

    if pre_existing
      errors.add("This study is already categorized under #{pre_existing.category.name}!")
    end
  end

end
