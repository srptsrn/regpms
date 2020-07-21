class AddColumnEvaluationDate < ActiveRecord::Migration
  def change
    add_column :evaluations, :start_date, :date
    add_column :evaluations, :end_date, :date
  end
end
