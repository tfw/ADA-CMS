class Category < ActiveRecord::Base
  acts_as_nested_set
  
  def to_s
    name
  end
  
  def recurse(&block)
    block.call self, lambda{
      self.children.each do |child|
        child.recurse(&block)
      end
    }
  end

end

class Category_NoToArray < Category
  def to_a
    raise 'to_a called'
  end
end

class Category_DefaultScope < Category
  default_scope order('categories.id ASC')
end
