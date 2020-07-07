class CreateJobTemplateGroups < ActiveRecord::Migration
  def change
    create_table :job_template_groups do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.text :name
      t.integer :sorting

      t.userstamps
      t.timestamps
    end
  end
end
