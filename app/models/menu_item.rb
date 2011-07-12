class MenuItem < ActiveRecord::Base
  acts_as_nested_set

  belongs_to :parent, :class_name => "MenuItem"
  has_many :children, :class_name => "MenuItem", :foreign_key => "parent_id"
  belongs_to :archive
  belongs_to :content, :polymorphic => true
end