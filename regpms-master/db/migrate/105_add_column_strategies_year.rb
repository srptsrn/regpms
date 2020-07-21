class AddColumnStrategiesYear < ActiveRecord::Migration
  def change
    
    add_column :strategies, :year, :integer
        
  end
end
