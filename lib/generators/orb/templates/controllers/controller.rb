<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= orb_controller_class_name %>Controller < <%= prefix.present? ? prefix_capitalize : %{Orb} %>Controller
  load_and_authorize_resource :class => "<%= class_name %>"

  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  # GET <%= orb_route_url %>
  # GET <%= orb_route_url %>.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = <%= class_name %>.active_states.join(",")
    end if <%= class_name %>.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if <%= class_name %>.respond_to?(:workflow_spec)
    @q = <%= class_name %>.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @<%= plural_table_name %> = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET <%= orb_route_url %>/1
  # GET <%= orb_route_url %>/1.json
  def show
  end

  # GET <%= orb_route_url %>/new
  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
    render layout: !request.xhr?
  end

  # GET <%= orb_route_url %>/1/edit
  def edit
  end

  # POST <%= orb_route_url %>
  # POST <%= orb_route_url %>.json
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>
    authorize! params[:button].to_sym, @<%= singular_table_name %> if @<%= singular_table_name %>.respond_to?(:current_state)

    respond_to do |format|
      if @<%= orm_instance.save %> && (!@<%= singular_table_name %>.respond_to?(:current_state) || @<%= singular_table_name %>.process_event!(params[:button]))
        format.html { redirect_to <%= orb_index_helper %>_url(q: params[:q], page: params[:page]), notice: <%= "'#{human_name} was successfully created.'" %> }
        format.json { render action: 'show', status: :created, location: <%= orb_plain_model_url %>_url(<%= "@#{singular_table_name}" %>) }
      else
        format.html { render action: 'new' }
        format.json { render json: <%= "@#{orm_instance.errors}" %>, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT <%= orb_route_url %>/1
  # PATCH/PUT <%= orb_route_url %>/1.json
  def update
    authorize! params[:button].to_sym, @<%= singular_table_name %> if @<%= singular_table_name %>.respond_to?(:current_state)

    respond_to do |format|
      if (params[:<%= singular_table_name %>].nil? || @<%= orm_instance.update("#{singular_table_name}_params") %>) && (!@<%= singular_table_name %>.respond_to?(:current_state) || @<%= singular_table_name %>.process_event!(params[:button]))
        format.html { redirect_to <%= orb_index_helper %>_url(q: params[:q], page: params[:page]), notice: <%= "'#{human_name} was successfully updated.'" %> }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: <%= "@#{orm_instance.errors}" %>, status: :unprocessable_entity }
      end
    end
  end

  # DELETE <%= orb_route_url %>/1
  # DELETE <%= orb_route_url %>/1.json
  def destroy
    if params[:id]
      if (!@<%= singular_table_name %>.respond_to?(:current_state) || !@<%= singular_table_name %>.current_state.meta[:no_destroy]) &&
        (<%= class_name %>.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @<%= singular_table_name %>.send(r.name).count}.sum == 0)
        @<%= orm_instance.destroy %>
      end
    elsif params[:ids]
      authorize! :destroy_selected, <%= class_name %>
      <%= class_name %>.where(id: params[:ids]).each do |<%= singular_table_name %>|
        if can?(:destroy, <%= singular_table_name %>) &&
          (!<%= singular_table_name %>.respond_to?(:current_state) || !<%= singular_table_name %>.current_state.meta[:no_destroy]) &&
          (<%= class_name %>.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| <%= singular_table_name %>.send(r.name).count}.sum == 0)
          <%= orm_instance.destroy %>
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to <%= orb_index_helper %>_url(q: params[:q], page: params[:page]), notice: <%= "'#{human_name} was successfully destroyed.'" %> }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %> if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
      params[<%= ":#{singular_table_name}" %>]
      <%- else -%>
      params.require(<%= ":#{singular_table_name}" %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
      <%- end -%>
    end

    def default_layout
      "orb"
    end
    
end
<% end -%>