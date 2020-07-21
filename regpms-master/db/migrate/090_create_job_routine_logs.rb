class CreateJobRoutineLogs < ActiveRecord::Migration
  def change
    create_table :job_routine_logs do |t|
      t.references :job_routine, index: true
      t.text :name
      t.integer :expect
      t.float :weight

      t.userstamps
      t.timestamps
    end
  end
end
