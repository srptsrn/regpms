class TicketsController < OrbController
  load_and_authorize_resource :class => "Ticket"

  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  # GET /tickets
  # GET /tickets.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = Ticket.active_states.join(",")
    end if Ticket.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Ticket.respond_to?(:workflow_spec)
    @q = Ticket.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @tickets = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
    render layout: !request.xhr?
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  # POST /tickets.json
  def create
    @ticket = Ticket.new(ticket_params)
    authorize! params[:button].to_sym, @ticket if @ticket.respond_to?(:current_state)

    respond_to do |format|
      if @ticket.save && (!@ticket.respond_to?(:current_state) || @ticket.process_event!(params[:button]))

        @ticket.users.destroy_all
        if params[:users]
          @users = User.where(:id => params[:users])
          @ticket.users << @users
        end
        
        format.html { redirect_to ticket_url(@ticket, q: params[:q], page: params[:page]), notice: 'Ticket was successfully created.' }
        format.json { render action: 'show', status: :created, location: ticket_url(@ticket) }
      else
        format.html { render action: 'new' }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    authorize! params[:button].to_sym, @ticket if @ticket.respond_to?(:current_state)

    respond_to do |format|
      if (params[:ticket].nil? || @ticket.update(ticket_params)) && (!@ticket.respond_to?(:current_state) || @ticket.process_event!(params[:button]))

        @ticket.users.destroy_all
        if params[:users]
          @users = User.where(:id => params[:users])
          @ticket.users << @users
        end
        
        format.html { redirect_to tickets_url(q: params[:q], page: params[:page]), notice: 'Ticket was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    if params[:id]
      if (!@ticket.respond_to?(:current_state) || !@ticket.current_state.meta[:no_destroy]) &&
        (Ticket.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @ticket.send(r.name).count}.sum == 0)
        @ticket.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Ticket
      Ticket.where(id: params[:ids]).each do |ticket|
        if can?(:destroy, ticket) &&
          (!ticket.respond_to?(:current_state) || !ticket.current_state.meta[:no_destroy]) &&
          (Ticket.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| ticket.send(r.name).count}.sum == 0)
          ticket.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to tickets_url(q: params[:q], page: params[:page]), notice: 'Ticket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def comment
    
    @ticket = Ticket.find(params[:ticket_id])
    ticket_comment = @ticket.ticket_comments.create(ticket_comment_params)
    ticket_comment.process_event!(params[:button])
    
    respond_to do |format|
      format.html { redirect_to ticket_url(@ticket, q: params[:q], page: params[:page]), notice: 'Ticket was successfully created.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      params.require(:ticket).permit(:no, :name, :description, :priority, :workflow_state, :workflow_state_updater_id)
    end
    
    def ticket_comment_params
      params.require(:ticket_comment).permit(:description)
    end

    def default_layout
      "orb"
    end
    
end
