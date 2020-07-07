class AddColumnProjectsYear < ActiveRecord::Migration
  def change
    
    add_column :projects, :year, :integer
        
    
    reversible do |dir|
      dir.up do
        Project.all.each do |project|
          
          year = "25#{project.code[0, 2]}".to_i - 543
          
          puts year
          
          if year < 2561
            project.year = year
            project.save(validate: false)
          else
            puts "ERROR #{year} #{project.id}"
          end
        end
      end
    end
    
  end
end
