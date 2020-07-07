class AddColumnJobTemplatesIsJobPlan < ActiveRecord::Migration
  def change
    add_column :job_templates, :is_job_plan, :boolean
  end
end
