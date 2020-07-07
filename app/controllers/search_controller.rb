class SearchController < OrbController
  
  skip_authorization_check
  
  def index
    
    @search_all = params[:search_all]
    
    sql = ""
    sql += " SELECT users.username AS title, "
    sql += "        users.email AS description, "
    sql += "        users.updated_at AS updated_at, "
    sql += "        users.id AS result_id, "
    sql += "        '/admin/users/' || id AS result_url, "
    sql += "        'user' AS result_icon "
    sql += " FROM users "
    sql += " WHERE users.username LIKE '%#{@search_all}%' "
    sql += "    OR users.email LIKE '%#{@search_all}%' "
    
    sql += " UNION ALL "
    
    sql += " SELECT 'TICKET#' || tickets.no AS title, "
    sql += "        tickets.description AS description, "
    sql += "        tickets.updated_at AS updated_at, "
    sql += "        tickets.id AS result_id, "
    sql += "        '/tickets/' || id AS result_url, "
    sql += "        'ticket' AS result_icon "
    sql += " FROM tickets "
    sql += " WHERE tickets.no LIKE '%#{@search_all}%' "
    sql += "    OR tickets.description LIKE '%#{@search_all}%' "
    
    @results = User.paginate_by_sql(sql, :page => params[:page], :per_page => 20)
  end
  
end
