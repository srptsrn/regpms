class Settings::TasksController < SettingsController
  load_and_authorize_resource :class => "Task"

  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /settings/tasks
  # GET /settings/tasks.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = Task.active_states.join(",")
    end if Task.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Task.respond_to?(:workflow_spec)
    @q = Task.limit(params[:limit]).search(params[:q])
    @q.sorts = 'sorting' if @q.sorts.empty?
    @tasks = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/tasks/1
  # GET /settings/tasks/1.json
  def show
  end

  # GET /settings/tasks/new
  def new
    @task = Task.new
    render layout: !request.xhr?
  end

  # GET /settings/tasks/1/edit
  def edit
  end

  # POST /settings/tasks
  # POST /settings/tasks.json
  def create
    @task = Task.new(task_params)
    authorize! params[:button].to_sym, @task if @task.respond_to?(:current_state)

    respond_to do |format|
      if @task.save && (!@task.respond_to?(:current_state) || @task.process_event!(params[:button]))
        format.html { redirect_to settings_tasks_url(q: params[:q], page: params[:page]), notice: 'Task was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_task_url(@task) }
      else
        format.html { render action: 'new' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/tasks/1
  # PATCH/PUT /settings/tasks/1.json
  def update
    authorize! params[:button].to_sym, @task if @task.respond_to?(:current_state)

    respond_to do |format|
      if (params[:task].nil? || @task.update(task_params)) && (!@task.respond_to?(:current_state) || @task.process_event!(params[:button]))
        format.html { redirect_to settings_tasks_url(q: params[:q], page: params[:page]), notice: 'Task was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/tasks/1
  # DELETE /settings/tasks/1.json
  def destroy
    if params[:id]
      if (!@task.respond_to?(:current_state) || !@task.current_state.meta[:no_destroy]) &&
        (Task.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @task.send(r.name).count}.sum == 0)
        @task.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Task
      Task.where(id: params[:ids]).each do |task|
        if can?(:destroy, task) &&
          (!task.respond_to?(:current_state) || !task.current_state.meta[:no_destroy]) &&
          (Task.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| task.send(r.name).count}.sum == 0)
          task.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_tasks_url(q: params[:q], page: params[:page]), notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:workflow_state, :workflow_state_updater_id, :sorting, :name, :file, :principle1, :principle2, :principle3, :principle4, :principle5)
    end

    def default_layout
      "orb"
    end
    
end
