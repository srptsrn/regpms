class CreateJobDevelopmentLogs < ActiveRecord::Migration
  def change
    create_table :job_development_logs do |t|
      t.references :job_development, index: true
      t.text :name
      t.integer :expect
      t.float :weight

      t.userstamps
      t.timestamps
    end
  end
end
