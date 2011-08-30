#Menu items are either created to point to an external resource or copy themselves from their content

class MenuItem < ActiveRecord::Base
  include Workflowable

  acts_as_nested_set

  belongs_to :parent, :class_name => "MenuItem"
  has_many :children, :class_name => "MenuItem", :foreign_key => "parent_id"
  belongs_to :archive
  belongs_to :content, :polymorphic => true
  
  validate :unique_title_beneath_parent_in_archive
  validate :parent_menu_item_for_parent_page, :if => "self.content"
  validates_presence_of :archive
    
  def self.create_from_page(page)
    parent_menu_item = page.parent.menu_item if page.parent
    menu_item = nil
    
    menu_item = MenuItem.create(:title => page.title, :link => page.urn, :archive => page.archive, :content => page)
    menu_item.move_to_child_of page.parent.menu_item if page.parent
    menu_item.state = page.state
    
    menu_item
  end
  
  def self.update_from_page(page, menu_item)
    if page.parent
      menu_item.update_attributes(:title => page.title, :link => page.urn, :content => page, 
                                                  :archive => page.archive, :parent => page.parent.menu_item)
    else
      menu_item.update_attributes(:title => page.title, :link => page.urn, :content => page, :archive => page.archive)
    end
    
    menu_item
  end
  
  def self.archive_root_menu_items(archive, state = nil)
    roots = MenuItem.roots
    archive_roots = []

    for menu_item in roots
      if menu_item.archive == archive
        case state
        when Workflowable::PUBLISH
          archive_roots << menu_item if menu_item.published?
        when Workflowable::DRAFT
          archive_roots << menu_item if menu_item.draft?
        else
          archive_roots << menu_item 
        end
      end
    end
    
    archive_roots
  end
  
  
  def unique_title_beneath_parent_in_archive
    pre_existing = MenuItem.find_by_title_and_parent_id_and_archive_id(self.title, self.parent_id, self.archive_id)
    if pre_existing and pre_existing != self
      errors.add(:title, "There is already a menu item in the same position with the same title in the same archive.")
    end
  end
  
  def parent_menu_item_for_parent_page
    if self.content and self.content.parent
      unless self.content.parent.menu_item
        errors.add(:content, "Parent page #{content.parent.urn} must have a Menu Item before one is created for the child.")
      end
    end
  end
end