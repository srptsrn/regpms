# encoding: utf-8

require 'prawn'
require 'prawn/table'

class ProjectsController < OrbController
  load_and_authorize_resource :class => "Project"

  before_action :set_project, only: [:show, :edit, :update, :_destroy, :start_project, :cancel_start_project]

  # GET /projects
  # GET /projects.json
  def index
    if params[:q].blank?
      year = (Date.current.mon >= 10 ? Date.current.year + 1 : Date.current.year) 
      params[:q] = {}
      params[:q][:year_eq] = year
      params[:q][:workflow_state_in] = Project.active_states.join(",")
    end if Project.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Project.respond_to?(:workflow_spec)
    @q = Project.limit(params[:limit]).search(params[:q])
    @q.sorts = 'code' if @q.sorts.empty?
    @projects = request.format.html? ? @q.result.includes(:project, :policy).paginate(:page => params[:page], :per_page => 20) : @q.result.includes(:project, :policy)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new(year: params[:year])
    render layout: !request.xhr?
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    authorize! params[:button].to_sym, @project if @project.respond_to?(:current_state)

    respond_to do |format|
      if @project.save && (!@project.respond_to?(:current_state) || @project.process_event!(params[:button]))
        format.html { redirect_to projects_url(q: params[:q], page: params[:page]), notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: project_url(@project) }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    authorize! params[:button].to_sym, @project if @project.respond_to?(:current_state)

    respond_to do |format|
      if (params[:project].nil? || @project.update(project_params)) && (!@project.respond_to?(:current_state) || @project.process_event!(params[:button]))
        if params[:button].to_sym == :print
          format.html { print }
        else
          format.html { redirect_to projects_url(q: params[:q], page: params[:page]), notice: 'Project was successfully updated.' }
        end
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    if params[:id]
      if (!@project.respond_to?(:current_state) || !@project.current_state.meta[:no_destroy]) &&
        (Project.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :_destroy].include?(r.options[:dependent])}.map{|r| @project.send(r.name).count}.sum == 0)
        @project.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Project
      Project.where(id: params[:ids]).each do |project|
        if can?(:destroy, project) &&
          (!project.respond_to?(:current_state) || !project.current_state.meta[:no_destroy]) &&
          (Project.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :_destroy].include?(r.options[:dependent])}.map{|r| project.send(r.name).count}.sum == 0)
          project.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to projects_url(q: params[:q], page: params[:page]), notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def print
    
    filename = "project_#{@project.id}_#{@project.current_state}_#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}.pdf"
    filename_path = File.join("public", "files", "reports", "projects", filename)
    
    margin_top = 25
    margin_right = 25
    margin_bottom = 25
    margin_left = 25
    
    pdf = Prawn::Document.new :page_size => 'A4', :margin => [margin_top, margin_right, margin_bottom, margin_left]
    
    pdf.font_families.update("THSarabun" => {
      :normal => File.join("public", "fonts", "THSarabun.ttf"),
      :italic => File.join("public", "fonts", "THSarabunItalic.ttf"),
      :bold => File.join("public", "fonts", "THSarabunBold.ttf"),
      :bold_italic => File.join("public", "fonts", "THSarabunBoldItalic.ttf")
    })
    
    pdf.font "THSarabun", size: 14    
    
    pdf.text "<b>แบบฟอร์ม</b>", inline_format: true, align: :center
    pdf.move_down 10

    if @project.project
      pdf.text "<b>1. #{Project.human_attribute_name(:name)}</b> #{@project.project.to_s}", inline_format: true
      pdf.move_down 10
      pdf.text "<b>2. #{Project.human_attribute_name(:name_sub)}</b> #{@project.to_s}", inline_format: true
      pdf.move_down 10
    else
      pdf.text "<b>1. #{Project.human_attribute_name(:name)}</b> #{@project.to_s}", inline_format: true
      pdf.move_down 10
      pdf.text "<b>2. #{Project.human_attribute_name(:name_sub)}</b> -", inline_format: true
      pdf.move_down 10
    end
    
    pdf.text "<b>3. #{Project.human_attribute_name(:policy)}</b> #{@project.policy.to_s}", inline_format: true
    pdf.move_down 10
    
    pdf.text "<b>4. #{Project.human_attribute_name(:responsibles)}</b>", inline_format: true
    pdf.indent 30 do
      @project.responsibles.each do |responsible|
        pdf.text "#{responsible.to_s}", indent_paragraphs: 30
      end
    end
    pdf.move_down 10
    
    pdf.text "<b>5. #{Project.human_attribute_name(:rationale)}</b>", inline_format: true
    pdf.text "#{@project.rationale}", indent_paragraphs: 30
    pdf.move_down 10
    
    pdf.text "<b>6. #{Project.human_attribute_name(:objectives)}</b>", inline_format: true
    pdf.indent 30 do
      @project.objectives.each do |objective|
        pdf.text "#{objective.to_s}", indent_paragraphs: 30
      end
    end
    pdf.move_down 10
    
    pdf.text "<b>7. #{Project.human_attribute_name(:time_plan)}</b> #{@project.time_plan(:thai)}", inline_format: true
    pdf.move_down 10
    
    pdf.text "<b>8. #{Project.human_attribute_name(:budgets)}</b> #{@project.budget_amount.to_s_decimal_comma} <b>บาท</b>", inline_format: true
    pdf.indent 30 do
      @project.budgets.each do |budget|
        pdf.text "#{budget.to_s}", indent_paragraphs: 30
      end
    end
    pdf.move_down 10

    pdf.text "<b>9. #{Project.human_attribute_name(:budget_plan)}</b>", inline_format: true
    pdf.indent 30 do
      data = []
      data << [
        {content: "<b>#{Project.human_attribute_name :budget_plan_q1}<br/>#{Project.human_attribute_name :budget_plan_q1_month}</b>", inline_format: true, align: :center}, 
        {content: "<b>#{Project.human_attribute_name :budget_plan_q2}<br/>#{Project.human_attribute_name :budget_plan_q2_month}</b>", inline_format: true, align: :center}, 
        {content: "<b>#{Project.human_attribute_name :budget_plan_q3}<br/>#{Project.human_attribute_name :budget_plan_q3_month}</b>", inline_format: true, align: :center}, 
        {content: "<b>#{Project.human_attribute_name :budget_plan_q4}<br/>#{Project.human_attribute_name :budget_plan_q4_month}</b>", inline_format: true, align: :center}, 
      ]
      data << [
        {content: "#{@project.budget_plan_q1.to_s_decimal_comma}", inline_format: true, align: :center}, 
        {content: "#{@project.budget_plan_q2.to_s_decimal_comma}", inline_format: true, align: :center}, 
        {content: "#{@project.budget_plan_q3.to_s_decimal_comma}", inline_format: true, align: :center}, 
        {content: "#{@project.budget_plan_q4.to_s_decimal_comma}", inline_format: true, align: :center}
      ]
      pdf.table data, width: 400
    end
    pdf.move_down 10

    pdf.text "<b>10. #{Project.human_attribute_name(:benefits)}</b>", inline_format: true
    pdf.indent 30 do
      @project.benefits.each do |benefit|
        pdf.text "#{benefit.to_s}", indent_paragraphs: 30
      end
    end
    pdf.move_down 10
    
    pdf.text "<b>11. #{Project.human_attribute_name(:indicators)}</b>", inline_format: true
    pdf.indent 30 do
      data = []
      data << [
        {content: "<b>ตัวชี้วัด</b>", inline_format: true, align: :center}, 
        {content: "<b>#{Indicator.human_attribute_name :target} #{@project.year}</b>", inline_format: true, align: :center}, 
        {content: "<b>#{Indicator.human_attribute_name :unit}", inline_format: true, align: :center}, 
        {content: "<b>#{@project.year - 2}</b>", inline_format: true, align: :center}, 
        {content: "<b>#{@project.year - 1}</b>", inline_format: true, align: :center}, 
        {content: "<b>#{@project.year}</b>", inline_format: true, align: :center}
      ]
      @project.indicators.each do |indicator|
        data << [
          {content: "#{indicator.description}", inline_format: true}, 
          {content: "#{indicator.target.to_s_decimal_comma}", inline_format: true, align: :center}, 
          {content: "#{indicator.unit}", inline_format: true, align: :center}, 
          {content: "#{indicator.result1.to_s_decimal_comma}", inline_format: true, align: :center}, 
          {content: "#{indicator.result2.to_s_decimal_comma}", inline_format: true, align: :center}, 
          {content: "#{indicator.result3.to_s_decimal_comma}", inline_format: true, align: :center}, 
        ]
      end
      pdf.table data, width: 500, header: true, column_widths: {1 => 50, 2 => 50, 3 => 50, 4 => 50, 5 => 50}
    end
    pdf.move_down 10
    
    pdf.text "<b>12. #{Project.human_attribute_name(:activities)}</b>", inline_format: true
    pdf.indent 30 do
      @project.activities.each do |activity|
        pdf.text "#{activity.to_s}", indent_paragraphs: 30
        # pdf.text "<b>#{Activity.human_attribute_name(:name)}</b> #{activity.name}", inline_format: true, indent_paragraphs: 30
        # pdf.text "<b>วัน เดือน ปี ที่จัด</b> #{activity.from_date.to_s_thai} ถึง #{activity.to_date.to_s_thai}", inline_format: true, indent_paragraphs: 30
        # pdf.text "<b>#{Activity.human_attribute_name(:location)}</b> #{activity.location}", inline_format: true, indent_paragraphs: 30
        # pdf.text "<b>#{Activity.human_attribute_name(:number_of_participant)}</b> #{activity.number_of_participant.to_s_comma} คน", inline_format: true, indent_paragraphs: 30
        # pdf.text "<b>#{Activity.human_attribute_name(:description)}</b>", inline_format: true, indent_paragraphs: 30
        # pdf.text "#{activity.description} คน", inline_format: true, indent_paragraphs: 30
      end
    end
    pdf.move_down 10
    
    pdf.text "<b>13. #{Project.human_attribute_name(:problem_suggesstions)}</b>", inline_format: true
    pdf.indent 30 do
      @project.problem_suggesstions.each do |problem_suggesstion|
        pdf.text "#{problem_suggesstion.to_s}", indent_paragraphs: 30
      end
    end
    pdf.move_down 10
    
    pdf.text "<b>14. #{Project.human_attribute_name(:project_image)}</b>", inline_format: true
    pdf.indent 30 do
      @project.project_images.each do |project_image|
        pdf.image "#{project_image.image.path}", width: 400
      end
    end
    pdf.move_down 10
    
    pdf.render_file filename_path
    
    send_file filename_path, :type => "application/pdf", :disposition => 'attachment'
    return false
  end
  
  def chose_strategy_group
    @strategy_group = StrategyGroup.find(params[:strategy_group_id]) if !params[:strategy_group_id].blank?
    @year = !params[:year].blank? ? params[:year].to_i : nil

    respond_to do |format|
      format.js
    end
  end
  
  def chose_strategy
    @strategy = Strategy.find(params[:strategy_id]) if !params[:strategy_id].blank?

    respond_to do |format|
      format.js
    end
  end
  
  def chose_tactic
    @tactic = Tactic.find(params[:tactic_id]) if !params[:tactic_id].blank?

    respond_to do |format|
      format.js
    end
  end
  
  def chose_kku_strategic_pillar
  
    @kku_strategic_pillar = !params[:kku_strategic_pillar_id].blank? && KkuStrategicPillar.exists?(params[:kku_strategic_pillar_id]) ? KkuStrategicPillar.find(params[:kku_strategic_pillar_id]) : KkuStrategicPillar.new

    respond_to do |format|
      format.js
    end
  end
  
  def start_project
    
    @project.is_started = true
    @project.save
    
    respond_to do |format|
      format.js
    end
  end
  
  def cancel_start_project
    
    @project.is_started = false
    @project.save
    
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(
        :workflow_state, :workflow_state_updater_id, :project_id, :code, :name, :policy_id, :rationale, :objective, :from_date, :to_date, :budget_amount, 
        :budget_plan_q1, :budget_plan_q2, :budget_plan_q3, :budget_plan_q4, :budget_group_id, :strategy_id, :tactic_id, :year, 
        :kku_strategic_pillar_id, :kku_strategic_id, 
        :strategy_group_id, :measure_id, 
        responsibles_attributes: [:id, :workflow_state, :workflow_state_updater_id, :project_id, :sorting, :user_id, :prefix, :firstname, :lastname, :position, :_destroy], 
        budgets_attributes: [:id, :workflow_state, :workflow_state_updater_id, :project_id, :sorting, :budget_type_id, :description, :amount, :_destroy], 
        objectives_attributes: [:id, :workflow_state, :workflow_state_updater_id, :project_id, :sorting, :description, :_destroy], 
        benefits_attributes: [:id, :workflow_state, :workflow_state_updater_id, :project_id, :sorting, :description, :_destroy], 
        indicators_attributes: [:id, :workflow_state, :workflow_state_updater_id, :project_id, :sorting, :description, :target, :result1, :result2, :result3, :_destroy, :unit], 
        activities_attributes: [
          :id, :workflow_state, :workflow_state_updater_id, :project_id, :sorting, :name, :from_date, :to_date, :location, :number_of_participant, :description, :_destroy,
          activity_files_attributes: [:id, :workflow_state, :workflow_state_updater_id, :activity_id, :file, :_destroy] 
        ], 
        problem_suggesstions_attributes: [:id, :workflow_state, :workflow_state_updater_id, :project_id, :sorting, :description, :_destroy], 
        project_images_attributes: [:id, :workflow_state, :workflow_state_updater_id, :project_id, :image, :_destroy]
      )
    end

    def default_layout
      "orb"
    end
    
end
