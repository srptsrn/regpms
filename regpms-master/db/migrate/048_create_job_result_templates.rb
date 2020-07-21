class CreateJobResultTemplates < ActiveRecord::Migration
  def change
    create_table :job_result_templates do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :job_template, index: true
      t.text :name
      t.string :unit
      t.integer :duration

      t.userstamps
      t.timestamps
    end
  end
end
