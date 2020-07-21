class NewsImagesController < OrbController
  load_and_authorize_resource :class => "NewsImage"

  before_action :set_news_image, only: [:show, :edit, :update, :destroy]

  # GET /news_images
  # GET /news_images.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = NewsImage.active_states.join(",")
    end if NewsImage.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if NewsImage.respond_to?(:workflow_spec)
    @q = NewsImage.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @news_images = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /news_images/1
  # GET /news_images/1.json
  def show
  end

  # GET /news_images/new
  def new
    @news_image = NewsImage.new
    render layout: !request.xhr?
  end

  # GET /news_images/1/edit
  def edit
  end

  # POST /news_images
  # POST /news_images.json
  def create
    @news_image = NewsImage.new(news_image_params)
    authorize! params[:button].to_sym, @news_image if @news_image.respond_to?(:current_state)

    respond_to do |format|
      if @news_image.save && (!@news_image.respond_to?(:current_state) || @news_image.process_event!(params[:button]))
        format.html { redirect_to news_images_url(q: params[:q], page: params[:page]), notice: 'News image was successfully created.' }
        format.json { render action: 'show', status: :created, location: news_image_url(@news_image) }
      else
        format.html { render action: 'new' }
        format.json { render json: @news_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /news_images/1
  # PATCH/PUT /news_images/1.json
  def update
    authorize! params[:button].to_sym, @news_image if @news_image.respond_to?(:current_state)

    respond_to do |format|
      if (params[:news_image].nil? || @news_image.update(news_image_params)) && (!@news_image.respond_to?(:current_state) || @news_image.process_event!(params[:button]))
        format.html { redirect_to news_images_url(q: params[:q], page: params[:page]), notice: 'News image was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @news_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news_images/1
  # DELETE /news_images/1.json
  def destroy
    if params[:id]
      if (!@news_image.respond_to?(:current_state) || !@news_image.current_state.meta[:no_destroy]) &&
        (NewsImage.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @news_image.send(r.name).count}.sum == 0)
        @news_image.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, NewsImage
      NewsImage.where(id: params[:ids]).each do |news_image|
        if can?(:destroy, news_image) &&
          (!news_image.respond_to?(:current_state) || !news_image.current_state.meta[:no_destroy]) &&
          (NewsImage.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| news_image.send(r.name).count}.sum == 0)
          news_image.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to news_images_url(q: params[:q], page: params[:page]), notice: 'News image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news_image
      @news_image = NewsImage.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def news_image_params
      params.require(:news_image).permit(:workflow_state, :workflow_state_updater_id, :image, :published_at)
    end

    def default_layout
      "orb"
    end
    
end
