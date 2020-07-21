class AddColumnIndicatorsUnit < ActiveRecord::Migration
  def change
    add_column :indicators, :unit, :string
  end
end
