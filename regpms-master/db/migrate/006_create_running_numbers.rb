class CreateRunningNumbers < ActiveRecord::Migration
  def change
    create_table :running_numbers do |t|
      t.string :prefix
      t.integer :year
      t.integer :mon
      t.integer :day
      t.integer :last_number
      t.string :suffix

      t.userstamps
      t.timestamps
    end
  end
end
