class CreateEdpexKkus < ActiveRecord::Migration
  def change
    create_table :edpex_kkus do |t|
      t.integer :year
      t.references :edpex_kku_group, index: true
      t.string :no
      t.text :name
      t.text :description

      t.userstamps
      t.timestamps
    end
  end
end
