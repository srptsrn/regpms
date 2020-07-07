class AddColumnProjectsIsStarted < ActiveRecord::Migration
  def change
    
    add_column :projects, :is_started, :boolean, default: false
    
    reversible do |dir|
      dir.up do
        Project.all.each do |project|
          
          if project.activities.size > 0
            project.is_started = true
            project.save
          end
          
        end
      end
    end
    
  end
end
