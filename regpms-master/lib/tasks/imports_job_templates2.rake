#encoding: utf-8
namespace :imports do
   
  task :job_templates2 => :environment do
    
    puts "START :: #{Time.current}"
    
    require 'spreadsheet'
    
    Spreadsheet.client_encoding = 'UTF-8'
 
    workbook = Spreadsheet.open(Rails.root.join("pms_import.xls"))
    workbook.worksheets.each do |worksheet|
      unless worksheet.name.include?("skip-")
        puts "DO"
        row = 0
        worksheet.each do |data|
          if row > 0
            job_template_group = JobTemplateGroup.where(["name = ?", data[0].to_s.strip]).first
            job_template_group = JobTemplateGroup.new if job_template_group.nil?
            job_template_group.name           = data[0].to_s.strip
            job_template_group.workflow_state = :enabled
            if job_template_group.save
              
              job_template_names = []
              job_template_names << data[1].to_s.strip unless data[1].to_s.strip.blank?
              job_template_names << data[2].to_s.strip unless data[2].to_s.strip.blank?
              job_template_name = job_template_names.join(" - ")
              
              job_template_duration = data[3]
              
              job_template_unit = data[4].to_s.strip
              
              job_template_is_job_routine = !data[5].to_s.strip.blank? || (data[5].to_s.strip.blank? && data[6].to_s.strip.blank? && data[7].to_s.strip.blank? && data[8].to_s.strip.blank?)
              job_template_is_job_vice = !data[6].to_s.strip.blank? || (data[5].to_s.strip.blank? && data[6].to_s.strip.blank? && data[7].to_s.strip.blank? && data[8].to_s.strip.blank?)
              job_template_is_job_development = !data[7].to_s.strip.blank?
              job_template_is_job_plan = !data[8].to_s.strip.blank?
              
              job_template = JobTemplate.where(["job_template_group_id = ? AND name = ?", job_template_group.id, job_template_name]).first
              job_template = JobTemplate.new if job_template.nil?
              job_template.job_template_group_id    = job_template_group.id
              job_template.name                     = job_template_name
              job_template.unit                     = job_template_unit
              job_template.duration                 = job_template_duration
              job_template.is_job_routine           = job_template_is_job_routine
              job_template.is_job_vice              = job_template_is_job_vice
              job_template.is_job_development       = job_template_is_job_development
              job_template.is_job_plan              = job_template_is_job_plan
              job_template.workflow_state           = :enabled
              if job_template.save
                # puts ":: SAVED"
              else
                puts "#{row} :: #{worksheet.name} :: FAILED :: #{job_template.errors.messages.inspect}"
              end
            end
          end
          
          row += 1
          
        end
      else
        puts "SKIP"
      end
    end
  end
    
  task :job_templates2_fix => :environment do
    
    puts "START :: #{Time.current}"
    
    JobTemplate.where(["is_job_plan = ?", true]).each do |job_template|
      unless job_template.job_template_group_name.include?("งานตามยุทธศาสตร์ -")
        job_template.is_job_plan = false
        job_template.save
      end
    end
    
  end
  
end