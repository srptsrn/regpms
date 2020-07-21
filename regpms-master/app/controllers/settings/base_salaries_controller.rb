class Settings::BaseSalariesController < SettingsController
  load_and_authorize_resource :class => "BaseSalary"

  before_action :set_base_salary, only: [:show, :edit, :update, :destroy]

  # GET /settings/base_salaries
  # GET /settings/base_salaries.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = BaseSalary.active_states.join(",")
    end if BaseSalary.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if BaseSalary.respond_to?(:workflow_spec)
    @q = BaseSalary.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @base_salaries = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/base_salaries/1
  # GET /settings/base_salaries/1.json
  def show
  end

  # GET /settings/base_salaries/new
  def new
    @base_salary = BaseSalary.new
    render layout: !request.xhr?
  end

  # GET /settings/base_salaries/1/edit
  def edit
  end

  # POST /settings/base_salaries
  # POST /settings/base_salaries.json
  def create
    @base_salary = BaseSalary.new(base_salary_params)
    authorize! params[:button].to_sym, @base_salary if @base_salary.respond_to?(:current_state)

    respond_to do |format|
      if @base_salary.save && (!@base_salary.respond_to?(:current_state) || @base_salary.process_event!(params[:button]))
        format.html { redirect_to settings_base_salaries_url(q: params[:q], page: params[:page]), notice: 'Base salary was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_base_salary_url(@base_salary) }
      else
        format.html { render action: 'new' }
        format.json { render json: @base_salary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/base_salaries/1
  # PATCH/PUT /settings/base_salaries/1.json
  def update
    authorize! params[:button].to_sym, @base_salary if @base_salary.respond_to?(:current_state)

    respond_to do |format|
      if (params[:base_salary].nil? || @base_salary.update(base_salary_params)) && (!@base_salary.respond_to?(:current_state) || @base_salary.process_event!(params[:button]))
        format.html { redirect_to settings_base_salaries_url(q: params[:q], page: params[:page]), notice: 'Base salary was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @base_salary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/base_salaries/1
  # DELETE /settings/base_salaries/1.json
  def destroy
    if params[:id]
      if (!@base_salary.respond_to?(:current_state) || !@base_salary.current_state.meta[:no_destroy]) &&
        (BaseSalary.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @base_salary.send(r.name).count}.sum == 0)
        @base_salary.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, BaseSalary
      BaseSalary.where(id: params[:ids]).each do |base_salary|
        if can?(:destroy, base_salary) &&
          (!base_salary.respond_to?(:current_state) || !base_salary.current_state.meta[:no_destroy]) &&
          (BaseSalary.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| base_salary.send(r.name).count}.sum == 0)
          base_salary.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_base_salaries_url(q: params[:q], page: params[:page]), notice: 'Base salary was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_base_salary
      @base_salary = BaseSalary.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def base_salary_params
      params.require(:base_salary).permit(:workflow_state, :workflow_state_updater_id, :evaluation_id, :position_level_id, :min_low, :max_low, :base_low, :min_high, :max_high, :base_high, :remark)
    end

    def default_layout
      "orb"
    end
    
end
