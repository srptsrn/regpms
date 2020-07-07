class AddColumnEvaluationViceDirector < ActiveRecord::Migration
  def change
    add_column :evaluations, :vice_director2_id, :integer
    add_column :evaluations, :vice_director3_id, :integer
  end
end
