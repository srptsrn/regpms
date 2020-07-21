#encoding: utf-8
namespace :imports do
   
  task :job_templates_fix => :environment do
    
    I18n.locale = :en
    
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
        job_template_name = ""
        worksheet.each do |data|
          if row > 0
                  
                  unless data[1].to_s.strip.blank?
                    job_template_names = []
                    job_template_names << data[1].to_s.strip unless data[1].to_s.strip.blank?
                    job_template_name = job_template_names.join(" - ")
                  end
                  
                  job_template = JobTemplate.order("id DESC").where(["name = ? AND workflow_state != ?", job_template_name, :enabled]).first
                  
                  if job_template
                  
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
                      puts ":: SAVED #{job_template.workflow_state} : #{job_template.job_template_group_id} : #{job_template.id} : #{job_result_template.id}"
                    else
                      puts "#{row} :: #{worksheet.name} : #{job_template.id} :: FAILED :: #{job_result_template.errors.messages.inspect}"
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