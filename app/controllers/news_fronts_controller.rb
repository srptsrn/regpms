class NewsFrontsController < OrbController
  load_and_authorize_resource :class => "NewsFront"

  before_action :set_news_front, only: [:show, :edit, :update, :destroy]

  # GET /news_fronts
  # GET /news_fronts.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = NewsFront.active_states.join(",")
    end if NewsFront.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if NewsFront.respond_to?(:workflow_spec)
    @q = NewsFront.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @news_fronts = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /news_fronts/1
  # GET /news_fronts/1.json
  def show
  end

  # GET /news_fronts/new
  def new
    @news_front = NewsFront.new
    render layout: !request.xhr?
  end

  # GET /news_fronts/1/edit
  def edit
  end

  # POST /news_fronts
  # POST /news_fronts.json
  def create
    @news_front = NewsFront.new(news_front_params)
    authorize! params[:button].to_sym, @news_front if @news_front.respond_to?(:current_state)

    respond_to do |format|
      if @news_front.save && (!@news_front.respond_to?(:current_state) || @news_front.process_event!(params[:button]))
        format.html { redirect_to news_fronts_url(q: params[:q], page: params[:page]), notice: 'News front was successfully created.' }
        format.json { render action: 'show', status: :created, location: news_front_url(@news_front) }
      else
        format.html { render action: 'new' }
        format.json { render json: @news_front.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /news_fronts/1
  # PATCH/PUT /news_fronts/1.json
  def update
    authorize! params[:button].to_sym, @news_front if @news_front.respond_to?(:current_state)

    respond_to do |format|
      if (params[:news_front].nil? || @news_front.update(news_front_params)) && (!@news_front.respond_to?(:current_state) || @news_front.process_event!(params[:button]))
        format.html { redirect_to news_fronts_url(q: params[:q], page: params[:page]), notice: 'News front was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @news_front.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news_fronts/1
  # DELETE /news_fronts/1.json
  def destroy
    if params[:id]
      if (!@news_front.respond_to?(:current_state) || !@news_front.current_state.meta[:no_destroy]) &&
        (NewsFront.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @news_front.send(r.name).count}.sum == 0)
        @news_front.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, NewsFront
      NewsFront.where(id: params[:ids]).each do |news_front|
        if can?(:destroy, news_front) &&
          (!news_front.respond_to?(:current_state) || !news_front.current_state.meta[:no_destroy]) &&
          (NewsFront.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| news_front.send(r.name).count}.sum == 0)
          news_front.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to news_fronts_url(q: params[:q], page: params[:page]), notice: 'News front was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news_front
      @news_front = NewsFront.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def news_front_params
      params.require(:news_front).permit(:workflow_state, :workflow_state_updater_id, :title, :detail, :image, :published_at)
    end

    def default_layout
      "orb"
    end
    
end
