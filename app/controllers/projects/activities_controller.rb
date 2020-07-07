# encoding: utf-8
class Projects::ActivitiesController < OrbController
  load_and_authorize_resource :class => "Activity"

  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  # GET /projects/activities
  # GET /projects/activities.json
  def index
    if params[:q].blank?
      year = (Date.current.mon >= 10 ? Date.current.year + 1 : Date.current.year) 
      params[:q] = {}
      params[:q][:project_year_eq] = year
      params[:q][:workflow_state_in] = Activity.active_states.join(",")
    end if Activity.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Activity.respond_to?(:workflow_spec)
    @q = Activity.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @activities = request.format.html? ? @q.result.includes(:project).paginate(:page => params[:page], :per_page => 20) : @q.result.includes(:project)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /projects/activities/1
  # GET /projects/activities/1.json
  def show
  end

  # GET /projects/activities/new
  def new
    @activity = Activity.new(project_id: params[:project_id])
    render layout: !request.xhr?
  end

  # GET /projects/activities/1/edit
  def edit
  end

  # POST /projects/activities
  # POST /projects/activities.json
  def create
    @activity = Activity.new(activity_params)
    authorize! params[:button].to_sym, @activity if @activity.respond_to?(:current_state)

    respond_to do |format|
      if @activity.save && (!@activity.respond_to?(:current_state) || @activity.process_event!(params[:button]))
        format.html { redirect_to projects_activities_url(q: params[:q], page: params[:page]), notice: 'Activity was successfully created.' }
        format.json { render action: 'show', status: :created, location: projects_activity_url(@activity) }
      else
        format.html { render action: 'new' }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/activities/1
  # PATCH/PUT /projects/activities/1.json
  def update
    authorize! params[:button].to_sym, @activity if @activity.respond_to?(:current_state)

    respond_to do |format|
      if (params[:activity].nil? || @activity.update(activity_params)) && (!@activity.respond_to?(:current_state) || @activity.process_event!(params[:button]))
        
        @activity.project.indicators.each do |indicator|
          puts params["indicator_#{indicator.id}"].inspect
          puts params["indicator_#{indicator.id}"].inspect
          puts params["indicator_#{indicator.id}"].inspect
          puts params["indicator_#{indicator.id}"].inspect
          puts params["indicator_#{indicator.id}"].inspect
          if params["indicator_#{indicator.id}"]
            indicator.result3 = params["indicator_#{indicator.id}"][:result3]
            indicator.save
          end
        end
        
        format.html { redirect_to projects_activities_url(q: params[:q], page: params[:page]), notice: 'Activity was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/activities/1
  # DELETE /projects/activities/1.json
  def destroy
    if params[:id]
      if (!@activity.respond_to?(:current_state) || !@activity.current_state.meta[:no_destroy]) &&
        (Activity.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @activity.send(r.name).count}.sum == 0)
        @activity.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Activity
      Activity.where(id: params[:ids]).each do |activity|
        if can?(:destroy, activity) &&
          (!activity.respond_to?(:current_state) || !activity.current_state.meta[:no_destroy]) &&
          (Activity.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| activity.send(r.name).count}.sum == 0)
          activity.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to projects_activities_url(q: params[:q], page: params[:page]), notice: 'Activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def export
    
    con_st = " activities.workflow_state IN (?) "
    con_pr = [Activity.enabled_states]
    
    if params[:project_id]
      con_st += " AND activities.project_id = ? "
      con_pr << params[:project_id]
    end
    
    if params[:year]
      con_st += " AND projects.year = ? "
      con_pr << params[:year]
    end
    
    if params[:project_id]
      con_st += " AND activities.name LIKE ? "
      con_pr << "%#{params[:name]}"
    end
    
    where = [con_st, *con_pr]
    
    joins = " JOIN projects ON projects.id = activities.project_id "
    
    order = "projects.code, activities.created_at, activities.updated_at"
    
    @activities = Activity.order(order).where(where).joins(joins)
      
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
    
    @activities.each do |activity|
      rdata = [
        (activity.project ? activity.project.code : ""), 
        activity.from_date.to_s_thai, 
        activity.to_date.to_s_thai, 
        activity.location, 
        activity.number_of_participant, 
        activity.name
      ]
    sheet.row(row).replace rdata
    (0..5).each {|column| sheet.row(row).set_format(column, format_table_cell)}
    row += 1
    end
        
    filename = "export_activities_#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}.xls"
    filename_path = File.join("public", "files", "reports", "activities", filename)
    
    book.write filename_path
    send_file filename_path, :type => "application/vnd.ms-excel", :disposition => 'attachment'
    return false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      params.require(:activity).permit(
        :workflow_state, :workflow_state_updater_id, :project_id, :sorting, :name, :from_date, :to_date, :location, :number_of_participant, :description,
        activity_files_attributes: [:id, :workflow_state, :workflow_state_updater_id, :activity_id, :file, :_destroy] 
      )
    end

    def default_layout
      "orb"
    end
    
end
