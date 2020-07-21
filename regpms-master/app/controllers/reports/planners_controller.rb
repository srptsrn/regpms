# encoding: utf-8
class Reports::PlannersController < OrbController
  
  skip_authorization_check
  # authorize_resource :class => false
  
  def summary_indicator
    
    if params[:filters]
      @filters = Struct.new(:year).new(params[:filters][:year].to_i)
    else
      @filters = Struct.new(:year).new(Date.current.mon >= 10 ? Date.current.year + 1 : Date.current.year)
    end
    
    if params[:xls]
      book = Spreadsheet::Workbook.new
      
      font = Spreadsheet::Font.new "TH Sarabun New"
  
      format_header = Spreadsheet::Format.new :weight => :bold, :font => font, :size => 16
      format_header_merge = Spreadsheet::Format.new :weight => :bold, :font => font, :size => 16, :align => :merge
      format_header_right = Spreadsheet::Format.new :weight => :bold, :font => font, :size => 16, :horizontal_align => :right
      
      # format_table_header_center = Spreadsheet::Format.new :weight => :bold, :font => font, :size => 16, :pattern => 1, :pattern_fg_color => "gray", :horizontal_align => :center
      # format_table_header_merge = Spreadsheet::Format.new :weight => :bold, :font => font, :size => 16, :pattern => 1, :pattern_fg_color => "gray", :align => :merge
      # format_table_header_merge_right = Spreadsheet::Format.new  :weight => :bold, :font => font, :size => 16, :pattern => 1, :pattern_fg_color => "gray", :align => :merge, :horizontal_align => :right
      
      format_table_header_center = Spreadsheet::Format.new :weight => :bold, :font => font, :size => 16, :border => :thin, :pattern_fg_color => "gray", :horizontal_align => :center, :vertical_align => :middle
      format_table_header_merge = Spreadsheet::Format.new :weight => :bold, :font => font, :size => 16, :border => :thin, :pattern_fg_color => "gray", :align => :merge, :vertical_align => :middle
      format_table_header_merge_right = Spreadsheet::Format.new  :weight => :bold, :font => font, :size => 16, :border => :thin, :pattern_fg_color => "gray", :align => :merge, :horizontal_align => :right, :vertical_align => :middle
  
      format_table_cell = Spreadsheet::Format.new :font => font, :size => 16, :border => :thin, :text_wrap => true
      format_table_cell_right = Spreadsheet::Format.new :horizontal_align => :right, :font => font, :size => 16, :border => :thin
      format_table_cell_center = Spreadsheet::Format.new :horizontal_align => :center, :font => font, :size => 16, :border => :thin
      format_table_cell_number = Spreadsheet::Format.new :horizontal_align => :right, :number_format => '#,##0.00', :font => font, :size => 16, :border => :thin
      
      sheet = book.create_worksheet
        
      sheet_column_widths = [15, 15, 15, 20, 25, 150]
      sheet_column_widths.each_index {|idx| sheet.column(idx).width = sheet_column_widths[idx]}
      
      row = 0
      
      rdata = ["รหัสโครงการ", "เริ่มจัดวันที่", "จัดถึงวันที่", "สถานที่จัด", "จำนวนผู้เข้าร่วมโครงการ/กิจกรรม", "กิจกรรมที่ดำเนินการ"]
      sheet.row(row).replace rdata
      (0..5).each {|column| sheet.row(row).set_format(column, format_table_header_center)}
      row += 1
      
      # @activities.each do |activity|
        # rdata = [
          # (activity.project ? activity.project.code : ""), 
          # activity.from_date.to_s_thai, 
          # activity.to_date.to_s_thai, 
          # activity.location, 
          # activity.number_of_participant, 
          # activity.name
        # ]
      # sheet.row(row).replace rdata
      # (0..5).each {|column| sheet.row(row).set_format(column, format_table_cell)}
      # row += 1
      # end
          
      filename = "export_activities_#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}.xls"
      filename_path = File.join("public", "files", "reports", "activities", filename)
      
      book.write filename_path
      send_file filename_path, :type => "application/vnd.ms-excel", :disposition => 'attachment'
      return false
    end
  end
  
end
