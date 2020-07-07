class AddColumnEvaluationQueryDate < ActiveRecord::Migration
  def change
    add_column :evaluations, :query_start_date, :date
    add_column :evaluations, :query_end_date, :date
  end
end
