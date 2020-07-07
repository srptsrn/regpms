class AddColumnEvaluationsIs360 < ActiveRecord::Migration
  def change
    
    add_column :evaluations, :is_360, :boolean
        
  end
end
