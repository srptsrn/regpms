class AddColumnEvaluationsIsSalaryUp < ActiveRecord::Migration
  def change
    
    add_column :evaluations, :is_salary_up, :boolean
    add_reference :evaluations, :evaluation1, index: true
    add_reference :evaluations, :evaluation2, index: true
    add_reference :evaluations, :evaluation3, index: true
    add_reference :evaluations, :evaluation4, index: true
    add_reference :evaluations, :evaluation5, index: true
        
  end
end
