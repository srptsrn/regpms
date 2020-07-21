class CreateEdpexKkuGroups < ActiveRecord::Migration
  def change
    create_table :edpex_kku_groups do |t|
      t.string :no
      t.text :name

      t.userstamps
      t.timestamps
    end
  end
end
