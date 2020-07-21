class AddColumnSectionsViceDirector < ActiveRecord::Migration
  def change
    
    add_reference :sections, :vice_director, index: true
    
  end
end
