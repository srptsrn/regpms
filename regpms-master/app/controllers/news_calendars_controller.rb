class NewsCalendarsController < OrbController
  load_and_authorize_resource :class => "NewsCalendar"

  before_action :set_news_calendar, only: [:show, :edit, :update, :destroy]

  # GET /news_calendars
  # GET /news_calendars.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = NewsCalendar.active_states.join(",")
    end if NewsCalendar.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if NewsCalendar.respond_to?(:workflow_spec)
    @q = NewsCalendar.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @news_calendars = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /news_calendars/1
  # GET /news_calendars/1.json
  def show
  end

  # GET /news_calendars/new
  def new
    @news_calendar = NewsCalendar.new
    render layout: !request.xhr?
  end

  # GET /news_calendars/1/edit
  def edit
  end

  # POST /news_calendars
  # POST /news_calendars.json
  def create
    @news_calendar = NewsCalendar.new(news_calendar_params)
    authorize! params[:button].to_sym, @news_calendar if @news_calendar.respond_to?(:current_state)

    respond_to do |format|
      if @news_calendar.save && (!@news_calendar.respond_to?(:current_state) || @news_calendar.process_event!(params[:button]))
        format.html { redirect_to news_calendars_url(q: params[:q], page: params[:page]), notice: 'News calendar was successfully created.' }
        format.json { render action: 'show', status: :created, location: news_calendar_url(@news_calendar) }
      else
        format.html { render action: 'new' }
        format.json { render json: @news_calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /news_calendars/1
  # PATCH/PUT /news_calendars/1.json
  def update
    authorize! params[:button].to_sym, @news_calendar if @news_calendar.respond_to?(:current_state)

    respond_to do |format|
      if (params[:news_calendar].nil? || @news_calendar.update(news_calendar_params)) && (!@news_calendar.respond_to?(:current_state) || @news_calendar.process_event!(params[:button]))
        format.html { redirect_to news_calendars_url(q: params[:q], page: params[:page]), notice: 'News calendar was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @news_calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news_calendars/1
  # DELETE /news_calendars/1.json
  def destroy
    if params[:id]
      if (!@news_calendar.respond_to?(:current_state) || !@news_calendar.current_state.meta[:no_destroy]) &&
        (NewsCalendar.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @news_calendar.send(r.name).count}.sum == 0)
        @news_calendar.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, NewsCalendar
      NewsCalendar.where(id: params[:ids]).each do |news_calendar|
        if can?(:destroy, news_calendar) &&
          (!news_calendar.respond_to?(:current_state) || !news_calendar.current_state.meta[:no_destroy]) &&
          (NewsCalendar.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| news_calendar.send(r.name).count}.sum == 0)
          news_calendar.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to news_calendars_url(q: params[:q], page: params[:page]), notice: 'News calendar was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news_calendar
      @news_calendar = NewsCalendar.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def news_calendar_params
      params.require(:news_calendar).permit(:workflow_state, :workflow_state_updater_id, :start_at, :end_at, :title, :detail, :published_at)
    end

    def default_layout
      "orb"
    end
    
end
