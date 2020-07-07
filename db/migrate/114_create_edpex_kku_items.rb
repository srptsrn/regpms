class CreateEdpexKkuItems < ActiveRecord::Migration
  def change
    create_table :edpex_kku_items do |t|
      t.references :edpex_kku, index: true
      t.string :no
      t.text :name
      t.float :target
      t.float :year1
      t.float :year2
      t.float :year3
      t.float :year4
      t.float :year5
      t.float :year
      t.string :institute

      t.userstamps
      t.timestamps
    end
  end
end
