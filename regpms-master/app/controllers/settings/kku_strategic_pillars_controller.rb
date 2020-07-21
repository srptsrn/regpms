class Settings::KkuStrategicPillarsController < SettingsController
  load_and_authorize_resource :class => "KkuStrategicPillar"

  before_action :set_kku_strategic_pillar, only: [:show, :edit, :update, :destroy]

  # GET /settings/kku_strategic_pillars
  # GET /settings/kku_strategic_pillars.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = KkuStrategicPillar.active_states.join(",")
    end if KkuStrategicPillar.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if KkuStrategicPillar.respond_to?(:workflow_spec)
    @q = KkuStrategicPillar.limit(params[:limit]).search(params[:q])
    @q.sorts = 'no' if @q.sorts.empty?
    @kku_strategic_pillars = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/kku_strategic_pillars/1
  # GET /settings/kku_strategic_pillars/1.json
  def show
  end

  # GET /settings/kku_strategic_pillars/new
  def new
    @kku_strategic_pillar = KkuStrategicPillar.new
    render layout: !request.xhr?
  end

  # GET /settings/kku_strategic_pillars/1/edit
  def edit
  end

  # POST /settings/kku_strategic_pillars
  # POST /settings/kku_strategic_pillars.json
  def create
    @kku_strategic_pillar = KkuStrategicPillar.new(kku_strategic_pillar_params)
    authorize! params[:button].to_sym, @kku_strategic_pillar if @kku_strategic_pillar.respond_to?(:current_state)

    respond_to do |format|
      if @kku_strategic_pillar.save && (!@kku_strategic_pillar.respond_to?(:current_state) || @kku_strategic_pillar.process_event!(params[:button]))
        format.html { redirect_to settings_kku_strategic_pillars_url(q: params[:q], page: params[:page]), notice: 'Kku strategic pillar was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_kku_strategic_pillar_url(@kku_strategic_pillar) }
      else
        format.html { render action: 'new' }
        format.json { render json: @kku_strategic_pillar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/kku_strategic_pillars/1
  # PATCH/PUT /settings/kku_strategic_pillars/1.json
  def update
    authorize! params[:button].to_sym, @kku_strategic_pillar if @kku_strategic_pillar.respond_to?(:current_state)

    respond_to do |format|
      if (params[:kku_strategic_pillar].nil? || @kku_strategic_pillar.update(kku_strategic_pillar_params)) && (!@kku_strategic_pillar.respond_to?(:current_state) || @kku_strategic_pillar.process_event!(params[:button]))
        format.html { redirect_to settings_kku_strategic_pillars_url(q: params[:q], page: params[:page]), notice: 'Kku strategic pillar was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @kku_strategic_pillar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/kku_strategic_pillars/1
  # DELETE /settings/kku_strategic_pillars/1.json
  def destroy
    if params[:id]
      if (!@kku_strategic_pillar.respond_to?(:current_state) || !@kku_strategic_pillar.current_state.meta[:no_destroy]) &&
        (KkuStrategicPillar.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @kku_strategic_pillar.send(r.name).count}.sum == 0)
        @kku_strategic_pillar.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, KkuStrategicPillar
      KkuStrategicPillar.where(id: params[:ids]).each do |kku_strategic_pillar|
        if can?(:destroy, kku_strategic_pillar) &&
          (!kku_strategic_pillar.respond_to?(:current_state) || !kku_strategic_pillar.current_state.meta[:no_destroy]) &&
          (KkuStrategicPillar.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| kku_strategic_pillar.send(r.name).count}.sum == 0)
          kku_strategic_pillar.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_kku_strategic_pillars_url(q: params[:q], page: params[:page]), notice: 'Kku strategic pillar was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kku_strategic_pillar
      @kku_strategic_pillar = KkuStrategicPillar.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def kku_strategic_pillar_params
      params.require(:kku_strategic_pillar).permit(:workflow_state, :workflow_state_updater_id, :no, :name)
    end

    def default_layout
      "orb"
    end
    
end
