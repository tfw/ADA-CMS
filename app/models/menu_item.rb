class MenuItem < ActiveRecord::Base
  acts_as_nested_set

  belongs_to :parent, :class_name => "MenuItem"
  has_many :children, :class_name => "MenuItem", :foreign_key => "parent_id"
  belongs_to :archive
  belongs_to :content, :polymorphic => true
  
  validate :unique_title_beneath_parent_in_archive
  validates_presence_of :archive
    
  def self.create_from_page(page)
    parent_menu_item = page.parent.menu_item if page.parent
    
    if page.parent
      menu_item = MenuItem.new(:title => page.title, :uri => page.path.slug, :parent => parent_menu_item, :archive => page.archive)
    else
      menu_item = MenuItem.new(:title => page.title, :uri => page.path.slug, :archive => page.archive)
    end
  end
  
  def unique_title_beneath_parent_in_archive
    pre_existing = self.find_by_title_and_parent_id_and_archive(self.title, self.parent_id, self.archive_id)
    if pre_existing and pre_existing != self
      errors.add(:title, "There is already a menu item in the same position with the same title in the same archive.")
    end
  end
end