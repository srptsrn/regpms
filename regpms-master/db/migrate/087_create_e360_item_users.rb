class CreateE360ItemUsers < ActiveRecord::Migration
  def change
    create_table :e360_item_users do |t|
      t.references :e360_user, index: true
      t.references :e360_item, index: true
      t.integer :score

      t.userstamps
      t.timestamps
    end
  end
end
