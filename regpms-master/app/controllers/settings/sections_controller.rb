class Settings::SectionsController < SettingsController
  load_and_authorize_resource :class => "Section"

  before_action :set_section, only: [:show, :edit, :update, :destroy]

  # GET /settings/sections
  # GET /settings/sections.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = Section.active_states.join(",")
    end if Section.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Section.respond_to?(:workflow_spec)
    @q = Section.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @sections = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/sections/1
  # GET /settings/sections/1.json
  def show
  end

  # GET /settings/sections/new
  def new
    @section = Section.new
    render layout: !request.xhr?
  end

  # GET /settings/sections/1/edit
  def edit
  end

  # POST /settings/sections
  # POST /settings/sections.json
  def create
    @section = Section.new(section_params)
    authorize! params[:button].to_sym, @section if @section.respond_to?(:current_state)

    respond_to do |format|
      if @section.save && (!@section.respond_to?(:current_state) || @section.process_event!(params[:button]))
        format.html { redirect_to settings_sections_url(q: params[:q], page: params[:page]), notice: 'Section was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_section_url(@section) }
      else
        format.html { render action: 'new' }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/sections/1
  # PATCH/PUT /settings/sections/1.json
  def update
    authorize! params[:button].to_sym, @section if @section.respond_to?(:current_state)

    respond_to do |format|
      if (params[:section].nil? || @section.update(section_params)) && (!@section.respond_to?(:current_state) || @section.process_event!(params[:button]))
        format.html { redirect_to settings_sections_url(q: params[:q], page: params[:page]), notice: 'Section was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/sections/1
  # DELETE /settings/sections/1.json
  def destroy
    if params[:id]
      if (!@section.respond_to?(:current_state) || !@section.current_state.meta[:no_destroy]) &&
        (Section.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @section.send(r.name).count}.sum == 0)
        @section.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Section
      Section.where(id: params[:ids]).each do |section|
        if can?(:destroy, section) &&
          (!section.respond_to?(:current_state) || !section.current_state.meta[:no_destroy]) &&
          (Section.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| section.send(r.name).count}.sum == 0)
          section.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_sections_url(q: params[:q], page: params[:page]), notice: 'Section was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = Section.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def section_params
      params.require(:section).permit(
        :workflow_state, :workflow_state_updater_id, :name, :leader_id, :vice_leader_id, :vice_director_id, :vice_director2_id, :vice_director3_id, 
        section_users_attributes: [:id, :section_id, :user_id, :_destroy]
      )
    end

    def default_layout
      "orb"
    end
    
end
