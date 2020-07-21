class CreateJobTemplates < ActiveRecord::Migration
  def change
    create_table :job_templates do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :job_template_group, index: true
      t.text :name
      t.string :unit
      t.integer :duration
      t.boolean :is_job_routine
      t.boolean :is_job_vice
      t.boolean :is_job_development

      t.userstamps
      t.timestamps
    end
  end
end
