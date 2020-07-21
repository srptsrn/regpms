class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.integer :year
      t.integer :episode
      t.date :pd_start_date
      t.date :pd_end_date
      t.date :pf_start_date
      t.date :pf_end_date
      t.date :confirm_start_date
      t.date :confirm_end_date
      t.date :evaluation_start_date
      t.date :evaluation_end_date
      t.references :director, index: true
      t.references :vice_director, index: true
      t.references :vice_director2, index: true
      t.references :vice_director3, index: true
      t.references :secretary, index: true

      t.userstamps
      t.timestamps
    end
  end
end
