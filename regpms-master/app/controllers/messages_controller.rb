class MessagesController < OrbController
  
  load_and_authorize_resource :class => "Message"

  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :fake_q, only: [:new, :create, :show, :edit, :update]

  # GET /messages
  # GET /messages.json
  def index
    
    per_page = 10
    
    params[:q] ||= {}
    if params[:list] == "sent"
      params[:q][:workflow_state_in] = [:sent].join(",")
      [:workflow_state_in].each do |to_split|
        params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
      end
      @q = current_user.messages.limit(params[:limit]).search(params[:q])
      @q.sorts = 'created_at DESC' if @q.sorts.empty?
      @messages = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => per_page) : @q.result
      
    elsif params[:list] == "drafted"
      params[:q][:workflow_state_in] = [:drafted].join(",")
      [:workflow_state_in].each do |to_split|
        params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
      end
      @q = current_user.messages.limit(params[:limit]).search(params[:q])
      @q.sorts = 'created_at DESC' if @q.sorts.empty?
      @messages = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => per_page) : @q.result
      
    elsif params[:list] == "archived"
      params[:q][:workflow_state_in] = [:archived].join(",")
      [:workflow_state_in].each do |to_split|
        params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
      end
      @q = current_user.message_receivers.limit(params[:limit]).search(params[:q])
      @q.sorts = 'created_at DESC' if @q.sorts.empty?
      @messages = request.format.html? ? @q.result.includes(:message).paginate(:page => params[:page], :per_page => per_page) : @q.result.includes(:message)
      
    elsif params[:list] == "trashed"
      params[:q][:workflow_state_in] = [:trashed].join(",")
      [:workflow_state_in].each do |to_split|
        params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
      end
      @q = current_user.message_receivers.limit(params[:limit]).search(params[:q])
      @q.sorts = 'created_at DESC' if @q.sorts.empty?
      @messages = request.format.html? ? @q.result.includes(:message).paginate(:page => params[:page], :per_page => per_page) : @q.result.includes(:message)
      
    else
      params[:q][:workflow_state_in] = [:seen, :unseen].join(",")
      [:workflow_state_in].each do |to_split|
        params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
      end
      @q = current_user.message_receivers.limit(params[:limit]).search(params[:q])
      @q.sorts = 'created_at DESC' if @q.sorts.empty?
      @messages = request.format.html? ? @q.result.includes(:message).paginate(:page => params[:page], :per_page => per_page) : @q.result.includes(:message)
      
    end
    
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    
    if @message.current_state.meta[:disabled]
      respond_to do |format|
        format.html { redirect_to messages_url(q: params[:q], page: params[:page], list: params[:list]), error: 'Message does not exists.' }
      end
    end
    
    unless @message.current_state.to_sym == :drafted
      message_receiver = @message.message_receivers.select {|mr| mr.user_id == current_user.id}.first
      message_receiver.read! if message_receiver && message_receiver.current_state.to_sym == :unseen
    end
    
    @message_receiver.process_event!(params[:button]) if @message_receiver && params[:button] && eval("@message_receiver.can_#{params[:button]}?")
        
  end

  # GET /messages/new
  def new
    @message = Message.new
    render layout: !request.xhr?
  end

  # GET /messages/1/edit
  def edit
    unless @message.current_state.to_sym == :drafted
      respond_to do |format|
        format.html { redirect_to message_url(@message, q: params[:q], page: params[:page], list: params[:list]), error: 'Message can not edit.' }
      end
    end
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)
    @message.user_id = current_user.id
    authorize! params[:button].to_sym, @message if @message.respond_to?(:current_state)

    respond_to do |format|
      if @message.save && (!@message.respond_to?(:current_state) || @message.process_event!(params[:button]))
        if @message.current_state.to_sym == :sent && params[:receivers].blank?
          @message.workflow_state = "drafted"
          @message.save
          format.html { redirect_to edit_message_url(@message) }
        else
          if @message.current_state.to_sym == :sent && params[:receivers] 
            @users = User.where(:id => params[:receivers])
            @users.each do |user|
              message_receiver = @message.message_receivers.create(receiver_type: "to", user_id: user.id)
              message_receiver.process_event!(:submit)
            end
          end
          format.html { redirect_to messages_url(q: params[:q], page: params[:page], list: (@message.current_state.to_sym == :drafted ? :draft : nil)), notice: 'Message was successfully created.' }
        end
        format.json { render action: 'show', status: :created, location: message_url(@message) }
      else
        format.html { render action: 'new' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    authorize! params[:button].to_sym, @message if @message.respond_to?(:current_state)
    
    respond_to do |format|
      if (params[:message].nil? || @message.update(message_params)) && (!@message.respond_to?(:current_state) || @message.process_event!(params[:button]))
        if @message.current_state.to_sym == :sent && params[:receivers].blank?
          @message.workflow_state = "drafted"
          @message.save
          format.html { redirect_to edit_message_url(@message) }
        else
          if @message.current_state.to_sym == :sent && params[:receivers] 
            @users = User.where(:id => params[:receivers])
            @users.each do |user|
              message_receiver = @message.message_receivers.create(receiver_type: "to", user_id: user.id)
              message_receiver.process_event!(:submit)
            end
          end
          format.html { redirect_to messages_url(q: params[:q], page: params[:page], list: params[:list]), notice: 'Message was successfully updated.' }
        end
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    if params[:id]
      if (!@message.respond_to?(:current_state) || !@message.current_state.meta[:no_destroy]) &&
        (Message.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @message.send(r.name).count}.sum == 0)
        @message.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Message
      Message.where(id: params[:ids]).each do |message|
        if can?(:destroy, message) &&
          (!message.respond_to?(:current_state) || !message.current_state.meta[:no_destroy]) &&
          (Message.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| message.send(r.name).count}.sum == 0)
          message.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to messages_url(q: params[:q], page: params[:page]), notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def fake_q
      @q = Message.search({creator_id_eq: 0})
    end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id]) if params[:id]
      @message_receiver = MessageReceiver.find(params[:oid]) if params[:oid] && params[:ocl].to_s == "MessageReceiver" && MessageReceiver.exists?(params[:oid])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:message_id, :user_id, :topic, :body, :workflow_state, :workflow_state_updater_id, receivers: [])
    end

    def default_layout
      "orb"
    end
    
end
