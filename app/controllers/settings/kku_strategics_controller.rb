class Settings::KkuStrategicsController < SettingsController
  load_and_authorize_resource :class => "KkuStrategic"

  before_action :set_kku_strategic, only: [:show, :edit, :update, :destroy]

  # GET /settings/kku_strategics
  # GET /settings/kku_strategics.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = KkuStrategic.active_states.join(",")
    end if KkuStrategic.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if KkuStrategic.respond_to?(:workflow_spec)
    @q = KkuStrategic.limit(params[:limit]).search(params[:q])
    @q.sorts = 'no' if @q.sorts.empty?
    @kku_strategics = request.format.html? ? @q.result.includes(:kku_strategic_pillar).paginate(:page => params[:page], :per_page => 20) : @q.result.includes(:kku_strategic_pillar)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/kku_strategics/1
  # GET /settings/kku_strategics/1.json
  def show
  end

  # GET /settings/kku_strategics/new
  def new
    @kku_strategic = KkuStrategic.new
    render layout: !request.xhr?
  end

  # GET /settings/kku_strategics/1/edit
  def edit
  end

  # POST /settings/kku_strategics
  # POST /settings/kku_strategics.json
  def create
    @kku_strategic = KkuStrategic.new(kku_strategic_params)
    authorize! params[:button].to_sym, @kku_strategic if @kku_strategic.respond_to?(:current_state)

    respond_to do |format|
      if @kku_strategic.save && (!@kku_strategic.respond_to?(:current_state) || @kku_strategic.process_event!(params[:button]))
        format.html { redirect_to settings_kku_strategics_url(q: params[:q], page: params[:page]), notice: 'Kku strategic was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_kku_strategic_url(@kku_strategic) }
      else
        format.html { render action: 'new' }
        format.json { render json: @kku_strategic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/kku_strategics/1
  # PATCH/PUT /settings/kku_strategics/1.json
  def update
    authorize! params[:button].to_sym, @kku_strategic if @kku_strategic.respond_to?(:current_state)

    respond_to do |format|
      if (params[:kku_strategic].nil? || @kku_strategic.update(kku_strategic_params)) && (!@kku_strategic.respond_to?(:current_state) || @kku_strategic.process_event!(params[:button]))
        format.html { redirect_to settings_kku_strategics_url(q: params[:q], page: params[:page]), notice: 'Kku strategic was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @kku_strategic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/kku_strategics/1
  # DELETE /settings/kku_strategics/1.json
  def destroy
    if params[:id]
      if (!@kku_strategic.respond_to?(:current_state) || !@kku_strategic.current_state.meta[:no_destroy]) &&
        (KkuStrategic.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @kku_strategic.send(r.name).count}.sum == 0)
        @kku_strategic.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, KkuStrategic
      KkuStrategic.where(id: params[:ids]).each do |kku_strategic|
        if can?(:destroy, kku_strategic) &&
          (!kku_strategic.respond_to?(:current_state) || !kku_strategic.current_state.meta[:no_destroy]) &&
          (KkuStrategic.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| kku_strategic.send(r.name).count}.sum == 0)
          kku_strategic.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_kku_strategics_url(q: params[:q], page: params[:page]), notice: 'Kku strategic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kku_strategic
      @kku_strategic = KkuStrategic.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def kku_strategic_params
      params.require(:kku_strategic).permit(:workflow_state, :workflow_state_updater_id, :kku_strategic_pillar_id, :no, :name)
    end

    def default_layout
      "orb"
    end
    
end
