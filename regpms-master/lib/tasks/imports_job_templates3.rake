#encoding: utf-8
namespace :imports do
   
  task :job_templates3 => :environment do
    
    puts "START :: #{Time.current}"
    
    require 'spreadsheet'
    
    Spreadsheet.client_encoding = 'UTF-8'
 
    workbook = Spreadsheet.open(Rails.root.join("pms_import_58.xls"))
    workbook.worksheets.each do |worksheet|
      unless worksheet.name.include?("skip-")
        puts "DO"
        row = 0
        tmp_job_template_group = nil
        tmp_job_template = nil
        worksheet.each do |data|
          if row > 0
            
            if tmp_job_template_group && data[0].to_s.strip.blank?
              job_template_group = tmp_job_template_group
            else
              job_template_group = JobTemplateGroup.where(["name = ?", data[0].to_s.strip]).first
              job_template_group = JobTemplateGroup.new if job_template_group.nil?
              job_template_group.name           = data[0].to_s.strip
              job_template_group.workflow_state = :enabled
            end
            
            if job_template_group.save 
              
              tmp_job_template_group = job_template_group
              
                
                if tmp_job_template && data[1].to_s.strip.blank?
                  job_template = tmp_job_template
                else
                  
                  job_template_names = []
                  job_template_names << data[1].to_s.strip unless data[1].to_s.strip.blank?
                  job_template_name = job_template_names.join(" - ")
                  
                  job_template_duration = data[3]
                  
                  job_template_unit = data[4].to_s.strip
                  
                  if worksheet.name == "งานยุทธศาสตร์"
                    job_template_is_job_plan = true
                    job_template_is_job_routine = false
                    job_template_is_job_vice = false
                    job_template_is_job_development = false
                  else
                    job_template_is_job_plan = false
                    job_template_is_job_routine = !data[5].to_s.strip.blank? || (data[5].to_s.strip.blank? && data[6].to_s.strip.blank? && data[7].to_s.strip.blank?)
                    job_template_is_job_vice = !data[6].to_s.strip.blank? || (data[5].to_s.strip.blank? && data[6].to_s.strip.blank? && data[7].to_s.strip.blank?)
                    job_template_is_job_development = !data[7].to_s.strip.blank? || (data[5].to_s.strip.blank? && data[6].to_s.strip.blank? && data[7].to_s.strip.blank?)
                  end
                  
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
                end
                
                if job_template.save 
                
                  puts ":: SAVED #{job_template_group.id} : #{job_template.id}"
                  
                  tmp_job_template = job_template
                  
                    job_result_template_names = []
                    job_result_template_names << data[2].to_s.strip unless data[2].to_s.strip.blank?
                    job_result_template_name = job_result_template_names.join(" - ")
                  
                    job_result_template_duration = data[3]
                    
                    job_result_template_unit = data[4].to_s.strip
                    
                    job_result_template = JobResultTemplate.where(["job_template_id = ? AND name = ?", job_template.id, job_result_template_name]).first
                    job_result_template = JobResultTemplate.new if job_result_template.nil?
                    job_result_template.job_template_id          = job_template.id
                    job_result_template.name                     = job_result_template_name
                    job_result_template.unit                     = job_result_template_unit
                    job_result_template.duration                 = job_result_template_duration
                    job_result_template.workflow_state           = :enabled
                    
                    if job_result_template.save 
                      puts ":: SAVED #{job_template_group.id} : #{job_template.id} : #{job_result_template.id}"
                    else
                      puts "#{row} :: #{worksheet.name} :: FAILED :: #{job_template.errors.messages.inspect}"
                    end
                  
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