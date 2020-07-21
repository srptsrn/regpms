# encoding: utf-8

class Projects::ExpensesController < OrbController
  load_and_authorize_resource :class => "Expense"

  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  # GET /projects/expenses
  # GET /projects/expenses.json
  def index
    if params[:q].blank?
      code_year = (Date.current.mon >= 10 ? Date.current.year + 1 : Date.current.year) + 543 - 2500
      params[:q] = {}
      params[:q][:project_code_start] = code_year
      params[:q][:workflow_state_in] = Expense.active_states.join(",")
    end if Expense.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Expense.respond_to?(:workflow_spec)
    @q = Expense.limit(params[:limit]).search(params[:q])
    @q.sorts = 'date DESC' if @q.sorts.empty?
    @expenses = request.format.html? ? @q.result.includes(:project, :budget_type, :budget_group).paginate(:page => params[:page], :per_page => 20) : @q.result.includes(:project, :budget_type, :budget_group)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /projects/expenses/1
  # GET /projects/expenses/1.json
  def show
  end

  # GET /projects/expenses/new
  def new
    @expense = Expense.new
    render layout: !request.xhr?
  end

  # GET /projects/expenses/1/edit
  def edit
  end

  # POST /projects/expenses
  # POST /projects/expenses.json
  def create
    @expense = Expense.new(expense_params)
    authorize! params[:button].to_sym, @expense if @expense.respond_to?(:current_state)

    respond_to do |format|
      if @expense.save && (!@expense.respond_to?(:current_state) || @expense.process_event!(params[:button]))
        format.html { redirect_to projects_expenses_url(q: params[:q], page: params[:page]), notice: 'Expense was successfully created.' }
        format.json { render action: 'show', status: :created, location: projects_expense_url(@expense) }
      else
        format.html { render action: 'new' }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/expenses/1
  # PATCH/PUT /projects/expenses/1.json
  def update
    authorize! params[:button].to_sym, @expense if @expense.respond_to?(:current_state)

    respond_to do |format|
      if (params[:expense].nil? || @expense.update(expense_params)) && (!@expense.respond_to?(:current_state) || @expense.process_event!(params[:button]))
        format.html { redirect_to projects_expenses_url(q: params[:q], page: params[:page]), notice: 'Expense was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/expenses/1
  # DELETE /projects/expenses/1.json
  def destroy
    if params[:id]
      if (!@expense.respond_to?(:current_state) || !@expense.current_state.meta[:no_destroy]) &&
        (Expense.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @expense.send(r.name).count}.sum == 0)
        @expense.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Expense
      Expense.where(id: params[:ids]).each do |expense|
        if can?(:destroy, expense) &&
          (!expense.respond_to?(:current_state) || !expense.current_state.meta[:no_destroy]) &&
          (Expense.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| expense.send(r.name).count}.sum == 0)
          expense.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to projects_expenses_url(q: params[:q], page: params[:page]), notice: 'Expense was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def chose_project
    @project = Project.find(params[:project_id]) if !params[:project_id].blank?

    respond_to do |format|
      format.js
    end
  end
  
  def import
    @log = ""
  end
  
  def import_save
    
    @log = ""
    
    if params[:file].original_filename.to_s.split('.').last == "xls"
      
      workbook = Spreadsheet.open(params[:file].tempfile)
      worksheet = workbook.worksheet 0
      
      row = 0
      worksheet.each do |data|
        if row > 0
          
          project_code = data[0].to_s.strip.split('.')[0]
          project = Project.where(["code = ?", project_code]).first
          
          budget_group_name = data[1].to_s.strip.gsub('.', '') == "มข" ? "มหาวิทยาลัย" : data[1].to_s.strip
          budget_group = BudgetGroup.where(["name LIKE ?", "%#{budget_group_name}%"]).first
          
          budget_type_name = data[2].to_s.strip
          budget_type = BudgetType.where(["name LIKE ?", "%#{budget_type_name}%"]).first
          
          if project && budget_group && budget_type
            
            date = nil
            begin
              if data[3].class == Date
                date_datas = data[3]
                d = date_datas.day.to_i
                m = date_datas.mon.to_i
                y = date_datas.year.to_i > 2500 ? date_datas.year.to_i - 543 : date_datas.year.to_i
                date = Date.strptime("#{d}/#{m}/#{y}", "%d/%m/%Y")
              else
                date_datas = data[3].to_s.split("/")
                d = date_datas[0].to_i
                m = date_datas[1].to_i
                y = date_datas[2].to_i > 2500 ? date_datas[2].to_i - 543 : date_datas[2].to_i
                date = Date.strptime("#{d}/#{m}/#{y}", "%d/%m/%Y")
              end
            rescue
              date = nil
            end 
            
            description = data[4].to_s.strip
            amount = data[5].to_f
            by = data[6].to_s.strip
            
            expense = Expense.where(["project_id = ? AND budget_group_id = ? AND budget_type_id = ? AND date = ? AND amount = ?", project.id, budget_group.id, budget_type.id, date, amount]).first
            expense = Expense.new if expense.nil?
            
            expense.project_id = project.id
            expense.budget_group_id = budget_group.id
            expense.budget_type_id = budget_type.id
            expense.date = date
            expense.description = description
            expense.amount = amount
            expense.by = by
            expense.workflow_state = :enabled
              
            if expense.save
              @log +=  "<b>SAVED</b> : #{row} : #{expense}<br/>"
            else
              @log +=  "<b>FAILED</b> : #{row} : #{expense} : #{expense.errors.messages}<br/>"
            end
          else
            @log +=  "<b>FAILED</b> : #{row} : #{expense} : <br/>"
            @log +=  "-------------------- ไม่พบ #{Project.model_name.human} #{project_code}<br/>" if project.nil?
            @log +=  "-------------------- ไม่พบ #{BudgetGroup.model_name.human} #{budget_group_name}<br/>" if budget_group.nil?
            @log +=  "-------------------- ไม่พบ #{BudgetType.model_name.human} #{budget_type_name}<br/>" if budget_type.nil?
          end
        end
        row += 1
        
      end
    else
      @log += "<br/><span style='color:#FF0000;'>ชนิดไฟล์ไม่ถูกต้อง ต้องเป็น Excel 97-2003 Workbook (*.xls) เท่านั้น</span>"
    end
    
    puts @log
    
    respond_to do |format|
      format.html { render template: "/projects/expenses/import" }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      params.require(:expense).permit(:workflow_state, :workflow_state_updater_id, :project_id, :sorting, :budget_type_id, :budget_group_id, :date, :description, :amount, :by)
    end

    def default_layout
      "orb"
    end
    
end
