class CreateJobViceLogs < ActiveRecord::Migration
  def change
    create_table :job_vice_logs do |t|
      t.references :job_vice, index: true
      t.text :name
      t.integer :expect
      t.float :weight

      t.userstamps
      t.timestamps
    end
  end
end
