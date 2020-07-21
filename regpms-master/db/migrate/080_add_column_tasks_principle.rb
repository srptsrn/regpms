class AddColumnTasksPrinciple < ActiveRecord::Migration
  def change
    
    add_column :tasks, :principle1, :text
    add_column :tasks, :principle2, :text
    add_column :tasks, :principle3, :text
    add_column :tasks, :principle4, :text
    add_column :tasks, :principle5, :text
    
  end
end
