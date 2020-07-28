# encoding: utf-8
require 'role_model'

class User < ActiveRecord::Base
  
  model_stamper
  
  THEMES = [
    ["default", "default"], 
    ["blue", "blue"], 
    ["brown", "brown"], 
    ["cherry", "cherry"], 
    ["green", "green"], 
    ["khaki", "khaki"], 
    ["purple", "purple"] 
  ]
  
  belongs_to :user_group
  has_many :notifications
  has_many :messages
  has_many :message_receivers
  
  belongs_to :position
  belongs_to :employee_type
  
  has_many :job_plans, -> { order(:created_at).where(["workflow_state = ? OR workflow_state = ?", :enabled, :confirmed]) }
  has_many :job_routines, -> { order(:created_at).where(["workflow_state = ? OR workflow_state = ?", :enabled, :confirmed]) }
  has_many :job_vices, -> { order(:created_at).where(["workflow_state = ? OR workflow_state = ?", :enabled, :confirmed]) }
  has_many :job_developments, -> { order(:created_at).where(["workflow_state = ? OR workflow_state = ?", :enabled, :confirmed]) }
  
  has_many :job_plan_results, -> { order(:created_at).where(["workflow_state = ? OR workflow_state = ?", :enabled, :confirmed]) }
  has_many :job_routine_results, -> { order(:created_at).where(["workflow_state = ? OR workflow_state = ?", :enabled, :confirmed]) }
  has_many :job_vice_results, -> { order(:created_at).where(["workflow_state = ? OR workflow_state = ?", :enabled, :confirmed]) }
  has_many :job_development_results, -> { order(:created_at).where(["workflow_state = ? OR workflow_state = ?", :enabled, :confirmed]) }
  
  has_many :assessments
  has_many :assessment2s
  
  has_many :evaluation_score_cards, -> { order(nil).where(["(role IS NOT NULL AND role != '') AND (task_score IS NOT NULL AND task_score > 0) AND (ability_score IS NOT NULL AND ability_score > 0)"]) }
  
  has_many :evaluation_users
  
  has_many :evaluation_user_finals
  
  has_many :evaluation_salary_up_users
  
  has_many :employee_type_users
  
  has_many :responsibles, -> { order("projects.code DESC").where(["projects.workflow_state IN (?)", Project.active_states]).joins("JOIN projects ON projects.id = responsibles.project_id") }
  
  has_attached_file :avatar, styles: { xlarge: "1920x1080>", large: "1024x1024>", medium: "500x500>", small: "300x300>", xsmall: "150x150>", thumb: "100x100>", avatar: "36x36#", row: "26x26#" },
                    convert_options: {
                      medium: "-gravity center -extent 500x500",
                      small: "-gravity center -extent 300x300",
                      xsmall: "-gravity center -extent 150x150",
                      thumb: "-gravity center -extent 100x100"
                    },
                    url: "/files/:class/:attachment/:id/:style/:basename.:extension",
                    path: ":rails_root/public/files/:class/:attachment/:id/:style/:basename.:extension", 
                    default_url: "/files/missing/:class/:style.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  validates :username, presence: true, uniqueness: true
  validates :password, 
            # you only need presence on create
            :presence => { :on => :create },
            # allow_nil for length (presence will handle it on create)
            :length   => { :minimum => 6, :allow_nil => true },
            # and use confirmation to ensure they always match
            :confirmation => true
  validates :email, presence: true, uniqueness: true
  validates :pid, presence: true, uniqueness: true
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
          # :registerable, 
          # :confirmable, 
          :recoverable, 
          # :rememberable, 
          :trackable, 
          :validatable,
          :authentication_keys => [:login]
  
  attr_accessor :login
  
  after_initialize do 
    if self.new_record?
      self.locale ||= "th"
      self.timezone ||= "Bangkok"
      self.theme ||= "default"
    end
  end
  
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  # RoleModel ######################################################################
  ROLES = [:ibattz, :systemadmin, :accounting, :planner, :hr, :qa] 
  XROLES = [:ibattz] 
  include RoleModel
  roles ROLES

  # cancan ######################################################################
  def ability
    @ability ||= UserAbility.new(self)
  end
  delegate :can?, :cannot?, :to => :ability

  def authorized_as?(role)
    self.send("#{role}?")
  end

  def to_s
    "#{firstname} #{lastname}"
  end
  
  def employee_type_user(evid=nil)
    etu = nil
    if evid
      etu = employee_type_users.where(["evaluation_id = ?", evid]).first
      etu = EmployeeTypeUser.new if etu.nil?
      etu.user_id = id
      etu.employee_type_id = employee_type_id
      etu.evaluation_id = evid
      etu.workflow_state = :enabled
      etu.save
    end
    return etu
  end
  
  def last_accessed
    ual = user_access_logs.order("created_at DESC").limit(1).first
    ual ? ual.log_time : nil
  end
  
  def role_names
    roles.collect {|r| r}
  end
  
  def role_names_join
    role_names.join(', ')
  end
  
  def unseen_notifications
    notifications.select {|n| n.current_state.to_sym == :unseen}
  end
  
  def unseen_message_receivers
    message_receivers.select {|mr| mr.current_state.to_sym == :unseen}
  end
  
  def unseen_messages
    unseen_message_receivers.collect {|mr| mr.message}
  end
  
  def prefix_firstname_lastname
    "#{prefix} #{firstname} #{lastname}"
  end
  
  def position_boards(ev=nil)
    pbs = []
    if ev
      pbs << Evaluation.human_attribute_name(:director) if ev.director_id == id
      pbs << Evaluation.human_attribute_name(:vice_director) if ev.vice_director_id == id
      pbs << Evaluation.human_attribute_name(:vice_director2) if ev.vice_director2_id == id
      pbs << Evaluation.human_attribute_name(:vice_director3) if ev.vice_director3_id == id
      pbs << Evaluation.human_attribute_name(:secretary) if ev.secretary_id == id
    end
    Section.where(["workflow_state = ? AND (leader_id = ? OR vice_leader_id = ?)", :enabled, id, id]).sort_by {|s| [s.name]}.each do |st|
      pbs << "#{Section.human_attribute_name(:leader)}#{st.name}" if st.leader_id == id
      pbs << "#{Section.human_attribute_name(:vice_leader)}#{st.name}" if st.vice_leader_id == id
    end
    Faculty.where(["leader_id = ?", id]).sort_by {|s| [s.name]}.each do |st|
      pbs << "#{Team.human_attribute_name(:leader)}#{st.name}" if st.leader_id == id
    end
    Team.where(["leader_id = ?", id]).sort_by {|s| [s.name]}.each do |st|
      pbs << "#{Team.human_attribute_name(:leader)}#{st.name}" if st.leader_id == id
    end
    return pbs
  end
  
  def position_name
    position ? position.name : ""
  end
  
  def position_type_name
    position ? position.position_type.to_s : ""
  end
  
  def position_level_name
    position ? position.position_level.to_s : ""
  end
  
  def position_level_id
    position ? position.position_level_id : nil
  end
  
  def employee_type_name
    employee_type ? employee_type.name : ""
  end
  
  def is_assessor?(ev=nil, sids=nil)
    if ev.nil?
      return false
    elsif ev.is_360?
      return true
    else
      # return is_director?(ev) || is_vice_director?(ev) || is_secretary?(ev) || is_committee?(ev) || is_section_leader?(sids) || is_section_vice_leader?(sids) || is_team_leader? || is_faculty_leader? || is_faculty_dean?
      return is_director?(ev) || is_vice_director?(ev) || is_vice_director2?(ev) || is_vice_director3?(ev) || is_secretary?(ev) || is_committee?(ev) || is_section_leader?(sids)
    end
  end
  
  def is_director?(ev=nil)
    if ev.nil?
      return false
    else
      return ev.director_id == id
    end
  end 
  def is_vice_director?(ev=nil)
    if ev.nil?
      return false
    elsif ev.is_360?
      return ev.vice_director_id == id #|| ev.vice_director2_id == id || ev.vice_director3_id == id
    else
      return Section.where(["workflow_state = ? AND vice_director_id = ?", :enabled, id]).size > 0
    end

     #if ev.nil?
     #  return false
     #else
     #  return ev.vice_director_id == id || ev.vice_director2_id == id || ev.vice_director3_id == id
     #end
  end

  def is_vice_director2?(ev=nil)
    if ev.nil?
      return false
    elsif ev.is_360?
      return ev.vice_director2_id == id #|| ev.vice_director2_id == id || ev.vice_director3_id == id
    else
      return Section.where(["workflow_state = ? AND vice_director2_id = ?", :enabled, id]).size > 0
    end
  end

  def is_vice_director3?(ev=nil)
    if ev.nil?
      return false
    elsif ev.is_360?
      return ev.vice_director3_id == id #|| ev.vice_director2_id == id || ev.vice_director3_id == id
    else
      return Section.where(["workflow_state = ? AND vice_director3_id = ?", :enabled, id]).size > 0
    end
  end
 
  def is_secretary?(ev=nil)
    if ev.nil?
      return false
    else
      return ev.secretary_id == id
    end
  end
  
  def is_committee?(ev=nil)
    if ev.nil?
      return false
    else
      return ev.committees.select {|cmt| cmt.user_id == id}.size > 0
    end
  end
  
  def is_section_leader?(sids=nil)
    if sids
      return Section.where(["workflow_state = ? AND id IN (?) AND leader_id = ?", :enabled, sids, id]).size > 0
      # return Section.where(["workflow_state = ? AND name NOT LIKE ? AND id IN (?) AND leader_id = ?", :enabled, "%รองผู้อำนวยการ%", sids, id]).size > 0
    else
      return Section.where(["workflow_state = ? AND leader_id = ?", :enabled, id]).size > 0
      # return Section.where(["workflow_state = ? AND name NOT LIKE ? AND leader_id = ?", :enabled, "%รองผู้อำนวยการ%", id]).size > 0
    end
  end
  
  def is_section_vice_leader?(sids=nil)
    if sids
      return Section.where(["workflow_state = ? AND name NOT LIKE ? AND id IN (?) AND vice_leader_id = ?", :enabled, "%รองผู้อำนวยการ%", sids, id]).size > 0
    else
      return Section.where(["workflow_state = ? AND name NOT LIKE ? AND vice_leader_id = ?", :enabled, "%รองผู้อำนวยการ%", id]).size > 0
    end
  end
  
  def is_team_leader?
    return Team.where(["leader_id = ?", id]).size > 0
  end
  
  def is_faculty_leader?
    return Faculty.where(["leader_id = ?", id]).size > 0
  end
  
  def is_faculty_dean?
    return Faculty.where(["dean_id = ?", id]).size > 0
  end
  
  def sections
    ss = []
    SectionUser.where(["user_id = ?", id]).each do |su| 
      ss << su.section if su.section.current_state.to_sym == :enabled
    end
    return ss.sort_by {|sc| sc.to_s}
  end
  
  def teams
    TeamUser.where(["user_id = ?", id]).collect {|su| su.team}
  end
  
  def faculties
    FacultyUser.where(["user_id = ?", id]).collect {|su| su.faculty}
  end
  
  def assess_to(ev=nil, role=nil, options={})
    if ev.nil? || role.blank?
      return []
    else
      where = " 1 = 0 "
      joins = nil
      if role == "director"
        # users = []
        # users << ev.vice_director
        # users << ev.secretary if users.select {|uu| uu.id == ev.secretary.id}.size == 0
        # Section.all_enabled.collect {|s| s.leader}.each do |u|
          # users << u if !u.nil? && users.select {|uu| uu && u && uu.id == u.id}.size == 0
        # end
        # Team.all.collect {|s| s.leader}.each do |u|
          # users << u if !u.nil? && users.select {|uu| uu && u && uu.id == u.id}.size == 0
        # end
        # Faculty.all.collect {|s| s.leader}.each do |u|
          # users << u if !u.nil? && users.select {|uu| uu && u && uu.id == u.id}.size == 0
        # end
        where = nil
        users = User.joins(joins).where(where).select {|u| !u.is_director?(ev)}
      elsif role == "vice_director"
        # users = []
        # Position.order(:name).where(["name LIKE ?", "ผู้ช่วยผู้อำนวยการ%"]).each do |position|
          # position.users.each do |u|
            # users << u if !u.is_director?(ev) && !u.is_vice_director?(ev) & !u.is_secretary?(ev) && !u.is_section_leader?
          # end
        # end
        
        # where = nil
        # users = User.joins(joins).where(where).select {|u| !u.is_director?(ev)}
        
        joins = "JOIN section_users ON users.id = section_users.user_id "
        joins += "JOIN sections ON sections.id = section_users.section_id "
        where = ["sections.vice_director_id = ?", id]
        users = User.joins(joins).where(where)
      elsif role == "vice_director2"
        joins = "JOIN section_users ON users.id = section_users.user_id "
        joins += "JOIN sections ON sections.id = section_users.section_id "
        where = ["sections.vice_director2_id = ?", id]
        users = User.joins(joins).where(where)
      elsif role == "vice_director3"
        joins = "JOIN section_users ON users.id = section_users.user_id "
        joins += "JOIN sections ON sections.id = section_users.section_id "
        where = ["sections.vice_director3_id = ?", id]
        users = User.joins(joins).where(where)
      elsif role == "secretary"
        where = nil
        users = User.joins(joins).where(where).select {|u| !u.is_secretary?(ev)}
      elsif role == "committee"
        where = nil
        users = User.joins(joins).where(where).select {|u| !u.is_director?(ev)}
      elsif role == "section_leader" || role == "section_vice_leader"
        joins = "JOIN section_users ON users.id = section_users.user_id"
        where = ["section_users.section_id = ?", options[:section_id]]
        sc = Section.exists?(options[:section_id]) ? Section.find(options[:section_id]) : nil
        if sc && sc.name.include?("รองผู้อำนวยการ")
          users = User.joins(joins).where(where)
        else
          users = User.joins(joins).where(where).select {|u| !u.is_director?(ev) && !u.is_vice_director?(ev) & !u.is_secretary?(ev) && !u.is_section_leader? && !u.position_name.include?("ผู้ช่วยผู้อำนวยการ")}
        end
      elsif role == "team_leader"
        joins = "JOIN team_users ON users.id = team_users.user_id"
        where = ["team_users.team_id = ?", options[:team_id]]
        users = User.joins(joins).where(where).select {|u| !u.is_director?(ev) && !u.is_vice_director?(ev) & !u.is_secretary?(ev) && !u.is_section_leader? && !u.position_name.include?("ผู้ช่วยผู้อำนวยการ")}
      elsif role == "faculty_dean" || role == "faculty_leader"
        joins = "JOIN faculty_users ON users.id = faculty_users.user_id"
        where = ["faculty_users.faculty_id = ?", options[:faculty_id]]
        users = User.joins(joins).where(where).select {|u| !u.is_director?(ev) && !u.is_vice_director?(ev) & !u.is_secretary?(ev) && !u.is_section_leader? && !u.position_name.include?("ผู้ช่วยผู้อำนวยการ")}
      elsif role == "staff"
        where = nil
        users = User.joins(joins).where(where).select {|u| !u.is_director?(ev) && !u.is_vice_director?(ev) & !u.is_secretary?(ev) && !u.is_section_leader? && !u.position_name.include?("ผู้ช่วยผู้อำนวยการ")}
      end
      return users.select {|u| u.workflow_state.to_sym == :enabled && ev.evaluation_employee_types.collect {|evet| evet.employee_type_id }.include?(u.employee_type_id) } - User.where(["username IN (?) OR username LIKE ?", ["admin", "batt", "demo"], "dean_%"])
    end
  end
  
  def assess_director_by(ev=nil)
    if ev.nil?
      return []
    else
      # if is_vice_director?(ev) || is_secretary?(ev) || (is_section_leader? && sections.select {|sss| sss.name.include?("รองผู้อำนวยการ")}.size == 0) || is_team_leader? || is_faculty_leader?
        return [ev.director]
      # else
        # return []
      # end
    end
  end
  
#  def assess_vice_director_by(ev=nil, options={})
#    if ev.nil?
#      return []
#    else
#      ls = []
#      if ev.is_360?
#        ls << ev.vice_director if ev.vice_director
#        ls << ev.vice_director2 if ev.vice_director2
#        ls << ev.vice_director3 if ev.vice_director3
#      else
#        sections.each do |st|
#          ls << st.vice_director if st.vice_director
#        end
#      end
#      return ls
#    end
#  end
  
  def assess_vice_director_by(ev=nil)
    if ev.nil?
      return []
    else
      return [ev.vice_director]
    end
  end

  def assess_vice_director2_by(ev=nil)
    if ev.nil?
      return []
    else
      return [ev.vice_director2] 
    end
  end

  def assess_vice_director3_by(ev=nil)
    if ev.nil?
      return []
    else
      return [ev.vice_director3]
    end
  end

  def assess_secretary_by(ev=nil)
    if ev.nil?
      return []
    else
      return [ev.secretary]
    end
  end
  
  def assess_committee_by(ev=nil)
    if ev.nil?
      return []
    else
      return ev.committees
    end
  end
  
  def assess_section_leaders_by(ev=nil)
    ls = []
    if sections.select {|sss| sss.name.include?("รองผู้อำนวยการ")}.size > 0
      sections.select {|sss| sss.name.include?("รองผู้อำนวยการ")}.each do |s| 
        ls << s.leader if !s.leader.nil? && s.leader_id != id
      #end if !is_vice_director?(ev) && !is_secretary?(ev)
      end if !is_vice_director?(ev) && !is_vice_director2?(ev) && !is_vice_director3?(ev) && !is_secretary?(ev)
    else
      sections.select {|sss| !sss.name.include?("รองผู้อำนวยการ")}.each do |s| 
        ls << s.leader if !s.leader.nil? && s.leader_id != id
      #end if !is_vice_director?(ev) && !is_secretary?(ev) && !is_section_leader?
      end if !is_vice_director?(ev) && !is_vice_director2?(ev) && !is_vice_director3?(ev) && !is_secretary?(ev) && !is_section_leader?
    end
    # sections.each do |s| 
    #   ls << s.leader if !s.leader.nil? && s.leader_id != id
    # end if !is_vice_director?(ev) && !is_secretary?(ev) && !is_section_leader? && !position_name.include?("ผู้ช่วยผู้อำนวยการ")
    return ls
  end
  
  def assess_section_vice_leaders_by(ev=nil)
    ls = []
    sections.each do |s| 
      ls << s.vice_leader if !s.vice_leader.nil? && s.vice_leader_id != id && s.leader_id != id
    #end if !is_vice_director?(ev) && !is_secretary?(ev) && !is_section_leader? && !is_section_vice_leader? && !position_name.include?("ผู้ช่วยผู้อำนวยการ")
    end if !is_vice_director?(ev) && !is_vice_director2?(ev) && !is_vice_director3?(ev) && !is_secretary?(ev) && !is_section_leader? && !is_section_vice_leader? && !position_name.include?("ผู้ช่วยผู้อำนวยการ")
    return ls
  end
  
  def assess_team_leaders_by(ev=nil)
    ls = []
    teams.each do |s| 
      ls << s.leader if !s.leader.nil? && s.leader_id != id
    #end if !is_vice_director?(ev) && !is_secretary?(ev) && !is_section_leader? && !position_name.include?("ผู้ช่วยผู้อำนวยการ") && teams.size > 0
    end if !is_vice_director?(ev) && !is_vice_director2?(ev) && !is_vice_director3?(ev) && !is_secretary?(ev) && !is_section_leader? && !position_name.include?("ผู้ช่วยผู้อำนวยการ") && teams.size > 0
    return ls
  end
  
  def assess_faculty_deans_by(ev=nil)
    ls = []
    faculties.each do |s| 
      ls << s.dean unless s.dean.nil?
    #end if !is_vice_director?(ev) && !is_secretary?(ev) && !is_section_leader? && !position_name.include?("ผู้ช่วยผู้อำนวยการ") && faculties.size > 0
    end if !is_vice_director?(ev) && !is_vice_director2?(ev) && !is_vice_director3?(ev) && !is_secretary?(ev) && !is_section_leader? && !position_name.include?("ผู้ช่วยผู้อำนวยการ") && faculties.size > 0
    return ls
  end
  
  def assess_faculty_leaders_by(ev=nil)
    ls = []
    faculties.each do |s| 
      ls << s.leader if !s.leader.nil? && s.leader_id != id
    #end if !is_vice_director?(ev) && !is_secretary?(ev) && !is_section_leader? && !position_name.include?("ผู้ช่วยผู้อำนวยการ") && faculties.size > 0 && !is_faculty_leader?
    end if !is_vice_director?(ev) && !is_vice_director2?(ev) && !is_vice_director3?(ev) && !is_secretary?(ev) && !is_section_leader? && !position_name.include?("ผู้ช่วยผู้อำนวยการ") && faculties.size > 0 && !is_faculty_leader?
    return ls
  end
  
  def score_task(ev=nil)
    if ev.nil?
      return 0.0
    else
      tt1 = 0
      tt2 = 0
      cc1 = 0
      cc2 = 0
      evaluation_users.where(["evaluation_id = ?", ev.id]).each do |eu|
        if eu.employee_type_task_total.to_f > 0
          if eu.role == "committee"
            tt1 += eu.employee_type_task_total.to_f
            cc1 += 1
          else
            tt2 += eu.employee_type_task_total.to_f
            cc2 += 1
          end
        end
      end
      committee_vv = cc1 == 0 ? 0 : (tt1 / cc1)
      leader_cvv = cc2 == 0 ? 0 : (tt2 / cc2)
      
      committee_ratio = committee_ratio(ev)
      leader_ratio = leader_ratio(ev)
      
      return (committee_vv * (committee_ratio.to_f / 100)) + (leader_cvv * (leader_ratio.to_f / 100))
    end
  end
  
  def score_ability(ev=nil)
    if ev.nil?
      return 0.0
    else
      tt1 = 0
      tt2 = 0
      cc1 = 0
      cc2 = 0
      evaluation_users.where(["evaluation_id = ?", ev.id]).each do |eu|
        if eu.position_capacity_total.to_f > 0
          if eu.role == "committee"
            tt1 += eu.position_capacity_total.to_f
            cc1 += 1
          else
            tt2 += eu.position_capacity_total.to_f
            cc2 += 1
          end
        end
      end
      committee_vv = cc1 == 0 ? 0 : (tt1 / cc1)
      leader_cvv = cc2 == 0 ? 0 : (tt2 / cc2)
      
      committee_ratio = committee_ratio(ev)
      leader_ratio = leader_ratio(ev)
      
      return (committee_vv * (committee_ratio.to_f / 100)) + (leader_cvv * (leader_ratio.to_f / 100))
    end
  end
  
  def evaluation_employee_type(ev=nil)
    if ev.nil?
      return nil
    else
      ev.evaluation_employee_types.select {|e| e.employee_type_id == employee_type_id}.first
    end
  end
  
  def committee_ratio(ev=nil)
    if ev.nil?
      return 0
    else
      eve = evaluation_employee_type(ev)
      return eve ? eve.committee_ratio : 0
    end
  end
  
  def leader_ratio(ev=nil)
    if ev.nil?
      return 0
    else
      evet = evaluation_employee_type(ev)
      return evet ? evet.leaderx_ratio.to_f : 0
    end
  end
  
  def task_ratio(ev=nil)
    if ev.nil?
      return 0
    else
      eve = evaluation_employee_type(ev)
      return eve ? eve.task_ratio : 0
    end
  end
  
  def ability_ratio(ev=nil)
    if ev.nil?
      return 0
    else
      eve = evaluation_employee_type(ev)
      return eve ? eve.ability_ratio : 0
    end
  end
  
  def task_leader_total_count(ev=nil)
    if ev.nil?
      return 0, 0
    else
      total = 0
      count = 0
      
      committee_employee_type_task_users = EmployeeTypeTaskUser.where(["user_id = ? AND evaluation_id = ?", id, ev.id]).select {|ettu| ettu.employee_type_id == employee_type_id}
      
      assess_director_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "director"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      assess_vice_director_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "vice_director"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      assess_vice_director2_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "vice_director2"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      assess_vice_director3_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "vice_director3"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      assess_secretary_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "secretary"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      assess_section_leaders_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "section_leader"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      assess_section_vice_leaders_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "section_vice_leader"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      assess_team_leaders_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "team_leader"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      assess_faculty_deans_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "faculty_dean"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      assess_faculty_leaders_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "faculty_leader"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      
      return total, count
    end
  end
  
  def task_committee_total_count(ev=nil)
    if ev.nil?
      return 0, 0
    else
      total = 0
      count = 0
      
      committee_employee_type_task_users = EmployeeTypeTaskUser.where(["user_id = ? AND evaluation_id = ?", id, ev.id]).select {|ettu| ettu.employee_type_id == employee_type_id}
      
      assess_committee_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.user_id && !ettu.role.blank? && ettu.role == "committee"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      
      return total, count
    end
  end
  
  def task_leader_score(ev=nil)
    if ev.nil?
      return 0, 0, 0, 0, 0, 0 , 0, 0
    else
      # total, count = task_leader_total_count(ev)
      # score = count.to_i > 0 ? total.to_f / count.to_i : 0
      # return score
      return task_leader_total(ev)
    end
  end
  
  def task_committee_score(ev=nil)
    if ev.nil?
      return 0
    else
      # total, count = task_committee_total_count(ev)
      # score = count.to_i > 0 ? total.to_f / count.to_i : 0
      # return score
      return task_committee_total(ev)
    end
  end
  
  def task_leader_score_ratio(ev=nil)
    if ev.nil?
      return 0
    else
      tls, tlsd, tlsv, tlsv2, tlsv3, tlss, tlsl, tlslv = task_leader_score(ev)
      return tls * leader_ratio(ev).to_f / 100
    end
  end
  
  def task_committee_score_ratio(ev=nil)
    if ev.nil?
      return 0
    else
      return task_committee_score(ev).to_f * committee_ratio(ev).to_f / 100
    end
  end
  
  def task_leader_score_task_ratio(ev=nil)
    if ev.nil?
      return 0
    else
      tls, tlsd, tlsv, tlsv2, tlsv3, tlss, tlsl, tlslv = task_leader_score(ev)
      return tls * task_ratio(ev).to_f / 100
    end
  end
  
  def task_committee_score_task_ratio(ev=nil)
    if ev.nil?
      return 0
    else
      return task_committee_score(ev).to_f * task_ratio(ev).to_f / 100
    end
  end
  
  def task_leader_score_task_ratio_with_leader_ratio(ev=nil)
    if ev.nil?
      return 0
    else
      return task_leader_score_task_ratio(ev).to_f * leader_ratio(ev).to_f / 100
    end
  end
  
  def task_committee_score_task_ratio_with_committee_ratio(ev=nil)
    if ev.nil?
      return 0
    else
      return task_committee_score_task_ratio(ev).to_f * committee_ratio(ev).to_f / 100
    end
  end
  
  # ability 
  
  def ability_leader_total_count(ev=nil)
    if ev.nil?
      return 0, 0
    else
      total = 0
      count = 0
      
      committee_position_capacity_users = PositionCapacityUser.where(["user_id = ? AND evaluation_id = ?", id, ev.id]).select {|ettu| ettu.position_id == position_id}
      
      assess_director_by(ev).each do |ab|
        total_score_real = committee_position_capacity_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "director"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      assess_vice_director_by(ev).each do |ab|
        total_score_real = committee_position_capacity_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "vice_director"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      assess_vice_director2_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "vice_director2"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      assess_vice_director3_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "vice_director3"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      assess_secretary_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "secretary"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end

      assess_section_leaders_by(ev).each do |ab|
        total_score_real = committee_position_capacity_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "section_leader"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      assess_section_vice_leaders_by(ev).each do |ab|
        total_score_real = committee_position_capacity_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "section_vice_leader"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      assess_team_leaders_by(ev).each do |ab|
        total_score_real = committee_position_capacity_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "team_leader"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      assess_faculty_deans_by(ev).each do |ab|
        total_score_real = committee_position_capacity_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "faculty_dean"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      assess_faculty_leaders_by(ev).each do |ab|
        total_score_real = committee_position_capacity_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "faculty_leader"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      
      return total, count
    end
  end
  
  def ability_committee_total_count(ev=nil)
    if ev.nil?
      return 0, 0
    else
      total = 0
      count = 0
      
      committee_position_capacity_users = PositionCapacityUser.where(["user_id = ? AND evaluation_id = ?", id, ev.id]).select {|ettu| ettu.position_id == position_id}
      
      assess_committee_by(ev).each do |ab|
        total_score_real = committee_position_capacity_users.select {|ettu| ettu.committee_id == ab.user_id && !ettu.role.blank? && ettu.role == "committee"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      
      return total, count
    end
  end
  
  def ability_leader_score(ev=nil)
    if ev.nil?
      return 0, 0, 0, 0, 0, 0, 0, 0
    else
      # total, count = ability_leader_total_count(ev)
      # score = count.to_i > 0 ? total.to_f / count.to_i : 0
      # return score
      return ability_leader_total(ev)
    end
  end
  
  def ability_committee_score(ev=nil)
    if ev.nil?
      return 0
    else
      # total, count = ability_committee_total_count(ev)
      # score = count.to_i > 0 ? total.to_f / count.to_i : 0
      # return score
      return ability_committee_total(ev)
    end
  end
  
  def ability_leader_score_ratio(ev=nil)
    if ev.nil?
      return 0
    else
      als, alsd, alsv, alsv2, alsv3, alss, alsl, alslv = ability_leader_score(ev)
      return als * leader_ratio(ev) / 100
    end
  end
  
  def ability_committee_score_ratio(ev=nil)
    if ev.nil?
      return 0
    else
      return ability_committee_score(ev).to_f * committee_ratio(ev).to_f / 100
    end
  end
  
  def ability_leader_score_ability_ratio(ev=nil)
    if ev.nil?
      return 0
    else
      als, alsd, alsv, alsv2, alsv3, alss, alsl, alslv = ability_leader_score(ev)
      return als * ability_ratio(ev).to_f / 100
    end
  end
  
  def ability_committee_score_ability_ratio(ev=nil)
    if ev.nil?
      return 0
    else
      return ability_committee_score(ev).to_f * ability_ratio(ev).to_f / 100
    end
  end
  
  def ability_leader_score_ability_ratio_with_leader_ratio(ev=nil)
    if ev.nil?
      return 0
    else
      return ability_leader_score_ability_ratio(ev).to_f * leader_ratio(ev).to_f / 100
    end
  end
  
  def ability_committee_score_ability_ratio_with_committee_ratio(ev=nil)
    if ev.nil?
      return 0
    else
      return ability_committee_score_ability_ratio(ev).to_f * committee_ratio(ev).to_f / 100
    end
  end
  
  def final_score(ev=nil)
    if ev.nil?
      return 0
    else
      return ((task_leader_score_ratio(ev).to_f + task_committee_score_ratio(ev).to_f) * task_ratio(ev).to_f / 100) + ((ability_leader_score_ratio(ev).to_f + ability_committee_score_ratio(ev).to_f) * ability_ratio(ev).to_f / 100)
    end
  end
  
  def final_score_level(ev=nil)
    fsl = ""
    fs = final_score(ev)
    if fs >= 90 
      fsl = "ดีเด่น (90 - 100)"
    elsif fs >= 80 && fs < 90
      fsl = "ดีมาก (80 - 89)"
    elsif fs >= 70 && fs < 80
      fsl = "ดี (70 - 79)"
    elsif fs >= 60 && fs < 70
      fsl = "พอใช้ (60 - 69)"
    elsif fs < 60
      fsl = "ต้องปรับปรุง (ต่ำกว่า 60)"
    end
    return fsl
  end
  
  ##########################################################################################################################################################################################################################################################
  ##########################################################################################################################################################################################################################################################
  ##########################################################################################################################################################################################################################################################
  ##########################################################################################################################################################################################################################################################
  ##########################################################################################################################################################################################################################################################
  
  def task_leader_total(ev=nil)
    if ev.nil?
      return 0, 0, 0, 0, 0
    else
      
      scorex = 0
      
      evet = evaluation_employee_type(ev)
      committee_employee_type_task_users = EmployeeTypeTaskUser.where(["user_id = ? AND evaluation_id = ?", id, ev.id]).select {|ettu| ettu.employee_type_id == employee_type_id}
      
      total = 0
      count = 0
      assess_director_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "director"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      scorexd = count > 0 ? (total / count) : 0
      
      assess_vice_director_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "vice_director"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      scorexvd = count > 0 ? (total / count) : 0
      
      assess_vice_director2_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "vice_director2"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      scorexvd2 = count > 0 ? (total / count) : 0

      assess_vice_director3_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "vice_director3"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      scorexvd3 = count > 0 ? (total / count) : 0

      assess_secretary_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "secretary"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      scorexs = count > 0 ? (total / count) : 0

      assess_section_leaders_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "section_leader"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      scorexsl = count > 0 ? (total / count) : 0
      
      assess_section_vice_leaders_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "section_vice_leader"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      scorexsvl = count > 0 ? (total / count) : 0
      
      #scorex = (scorexd * evet.director_ratio.to_f / leader_ratio(ev)) + (scorexvd * evet.vice_director_ratio.to_f / leader_ratio(ev)) + (scorexsl * evet.section_leader_ratio.to_f / leader_ratio(ev)) + (scorexsvl * evet.section_vice_leader_ratio.to_f / leader_ratio(ev))
      scorex = (scorexd * evet.director_ratio.to_f / leader_ratio(ev)) + (scorexvd * evet.vice_director_ratio.to_f / leader_ratio(ev)) + (scorexvd2 * evet.vice_director2_ratio.to_f / leader_ratio(ev)) + (scorexvd3 * evet.vice_director3_ratio.to_f / leader_ratio(ev)) + (scorexs * evet.secretary_ratio.to_f / leader_ratio(ev)) + (scorexsl * evet.section_leader_ratio.to_f / leader_ratio(ev)) + (scorexsvl * evet.section_vice_leader_ratio.to_f / leader_ratio(ev))
      
      #return scorex, (scorexd * evet.director_ratio.to_f / leader_ratio(ev)), (scorexvd * evet.vice_director_ratio.to_f / leader_ratio(ev)), (scorexsl * evet.section_leader_ratio.to_f / leader_ratio(ev)), (scorexsvl * evet.section_vice_leader_ratio.to_f / leader_ratio(ev))
      return scorex, (scorexd * evet.director_ratio.to_f / leader_ratio(ev)), (scorexvd * evet.vice_director_ratio.to_f / leader_ratio(ev)), (scorexvd2 * evet.vice_director2_ratio.to_f / leader_ratio(ev)), (scorexvd3 * evet.vice_director3_ratio.to_f / leader_ratio(ev)), (scorexs * evet.secretary_ratio.to_f / leader_ratio(ev)), (scorexsl * evet.section_leader_ratio.to_f / leader_ratio(ev)), (scorexsvl * evet.section_vice_leader_ratio.to_f / leader_ratio(ev))
    end
  end
  
  def task_committee_total(ev=nil)
    if ev.nil?
      return 0
    else
      total = 0
      count = 0
      
      committee_employee_type_task_users = EmployeeTypeTaskUser.where(["user_id = ? AND evaluation_id = ?", id, ev.id]).select {|ettu| ettu.employee_type_id == employee_type_id}
      
      assess_committee_by(ev).each do |ab|
        total_score_real = committee_employee_type_task_users.select {|ettu| ettu.committee_id == ab.user_id && !ettu.role.blank? && ettu.role == "committee"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      
      scorex = count > 0 ? (total / count) : 0
      return scorex
    end
  end
  
  ##########################################################################################################################################################################################################################################################
  ##########################################################################################################################################################################################################################################################
  ##########################################################################################################################################################################################################################################################
  ##########################################################################################################################################################################################################################################################
  ##########################################################################################################################################################################################################################################################
  
  
  def ability_leader_total(ev=nil)
    if ev.nil?
      return 0, 0, 0, 0, 0
    else
      
      scorex = 0
      
      evet = evaluation_employee_type(ev)
      committee_position_capacity_users = PositionCapacityUser.where(["user_id = ? AND evaluation_id = ?", id, ev.id]).select {|ettu| ettu.position_id == position_id}
      
      total = 0
      count = 0
      
      assess_director_by(ev).each do |ab|
        total_score_real = committee_position_capacity_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "director"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      scorexd = count > 0 ? (total / count) : 0
      
      assess_vice_director_by(ev).each do |ab|
        total_score_real = committee_position_capacity_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "vice_director"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      scorexvd = count > 0 ? (total / count) : 0
      assess_vice_director2_by(ev).each do |ab|
        total_score_real = committee_position_capacity_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "vice_director2"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      scorexvd2 = count > 0 ? (total / count) : 0
      assess_vice_director3_by(ev).each do |ab|
        total_score_real = committee_position_capacity_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "vice_director3"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      scorexvd3 = count > 0 ? (total / count) : 0
      assess_secretary_by(ev).each do |ab|
        total_score_real = committee_position_capacity_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "secretary"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      scorexs = count > 0 ? (total / count) : 0
      assess_section_leaders_by(ev).each do |ab|
        total_score_real = committee_position_capacity_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "section_leader"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      scorexsl = count > 0 ? (total / count) : 0
      
      total = 0
      count = 0
      assess_section_vice_leaders_by(ev).each do |ab|
        total_score_real = committee_position_capacity_users.select {|ettu| ettu.committee_id == ab.id && !ettu.role.blank? && ettu.role == "section_vice_leader"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      scorexsvl = count > 0 ? (total / count) : 0
      
      # scorex = (scorexd * evet.director_ratio.to_f / leader_ratio(ev)) + (scorexvd * evet.vice_director_ratio.to_f / leader_ratio(ev)) + (scorexsl * evet.section_leader_ratio.to_f / leader_ratio(ev)) + (scorexsvl * evet.section_vice_leader_ratio.to_f / leader_ratio(ev))
        
      # return scorex, (scorexd * evet.director_ratio.to_f / leader_ratio(ev)), (scorexvd * evet.vice_director_ratio.to_f / leader_ratio(ev)), (scorexsl * evet.section_leader_ratio.to_f / leader_ratio(ev)), (scorexsvl * evet.section_vice_leader_ratio.to_f / leader_ratio(ev))

      scorex = (scorexd * evet.director_ratio.to_f / leader_ratio(ev)) + (scorexvd * evet.vice_director_ratio.to_f / leader_ratio(ev)) + (scorexvd2 * evet.vice_director2_ratio.to_f / leader_ratio(ev)) + (scorexvd3 * evet.vice_director3_ratio.to_f / leader_ratio(ev)) + (scorexs * evet.secretary_ratio.to_f / leader_ratio(ev)) + (scorexsl * evet.section_leader_ratio.to_f / leader_ratio(ev)) + (scorexsvl * evet.section_vice_leader_ratio.to_f / leader_ratio(ev))
        
      return scorex, (scorexd * evet.director_ratio.to_f / leader_ratio(ev)), (scorexvd * evet.vice_director_ratio.to_f / leader_ratio(ev)), (scorexvd2 * evet.vice_director2_ratio.to_f / leader_ratio(ev)), (scorexvd3 * evet.vice_director3_ratio.to_f / leader_ratio(ev)), (scorexs * evet.secretary_ratio.to_f / leader_ratio(ev)), (scorexsl * evet.section_leader_ratio.to_f / leader_ratio(ev)), (scorexsvl * evet.section_vice_leader_ratio.to_f / leader_ratio(ev))
    end
  end
  
  def ability_committee_total(ev=nil)
    if ev.nil?
      return 0
    else
      total = 0
      count = 0
      
      committee_position_capacity_users = PositionCapacityUser.where(["user_id = ? AND evaluation_id = ?", id, ev.id]).select {|ettu| ettu.position_id == position_id}
      
      assess_committee_by(ev).each do |ab|
        total_score_real = committee_position_capacity_users.select {|ettu| ettu.committee_id == ab.user_id && !ettu.role.blank? && ettu.role == "committee"}.collect {|ettu| ettu.score_real.to_f}.sum
        total += total_score_real
        count += 1 if total_score_real > 0
      end
      
      scorex = count > 0 ? (total / count) : 0
      return scorex
    end
  end
  
  def projects
    responsibles.collect {|rs| rs.project}.uniq.sort_by {|pj| pj.code}
  end
  
  def evaluation_user_final(ev=nil)
    if ev.nil?
      return nil
    else
      return evaluation_user_finals.select {|euf| euf.evaluation_id == ev.id}.first
    end
  end
  
  ##########################################################################################################################################################################################################################################################
  ##########################################################################################################################################################################################################################################################
  ##########################################################################################################################################################################################################################################################
  ##########################################################################################################################################################################################################################################################
  ##########################################################################################################################################################################################################################################################
  
  def assess_to_cards(ev=nil, role=nil, options={})
    if ev.nil? || role.blank?
      return []
    else
      if role == "director" || role == "vice_director" || role == "vice_director2" || role == "vice_director3" || role == "secretary" || role == "committee"
        order = "firstname, lastname"
        where = ["(is_except_evaluation IS NULL OR is_except_evaluation = ?)", false]
        users = User.order(order).where(where).select {|u| !u.is_director?(ev) && !u.is_vice_director?(ev) && !u.is_vice_director2?(ev) && !u.is_vice_director3?(ev) && !u.is_secretary?(ev) }
      elsif role == "staff"
        order = "firstname, lastname"
        where = ["(is_except_evaluation IS NULL OR is_except_evaluation = ?)", false]
        users = User.order(order).where(where).select {|u| !u.is_director?(ev) && !u.is_vice_director?(ev) && !u.is_vice_director2?(ev) && !u.is_vice_director3?(ev) && !u.is_secretary?(ev)} 
      else
        users = []
      end
      return users.select {|u| u.workflow_state.to_sym == :enabled && ev.evaluation_employee_types.collect {|evet| evet.employee_type_id }.include?(u.employee_type_id) } - User.where(["username IN (?) OR username LIKE ?", ["admin", "batt", "demo"], "dean_%"])
    end
  end
  
  def board_360_roles
    ["director", "vice_director" , "vice_director2" , "vice_director3" , "secretary"]
  end
  
  def staff_360_roles
    ["staff"]
  end
  
  def total_score_360(ev=nil)
    if ev.nil?
      return nil
    else
      total_task_score_360(ev) + total_ability_score_360(ev)
    end
  end
  
  def total_task_score_360(ev=nil)
    if ev.nil?
      return nil
    else
      total_task_score_board_360(ev) + total_task_score_staff_360(ev)
    end
  end
  
  def total_task_score_board_360(ev=nil)
    if ev.nil?
      return nil
    else
      escs = evaluation_score_cards.where(["evaluation_id = ? AND role IN (?)", ev.id, board_360_roles])
      esc_size = escs.size
      sc = escs.collect {|esc| esc.task_score.to_i}.sum
      return esc_size > 0 ? sc.to_f / esc_size : 0.0
    end
  end
  
  def total_task_score_staff_360(ev=nil)
    if ev.nil?
      return nil
    else
      escs = evaluation_score_cards.where(["evaluation_id = ? AND role IN (?)", ev.id, staff_360_roles])
      esc_size = escs.size
      sc = escs.collect {|esc| esc.task_score.to_i}.sum
      return esc_size > 0 ? sc.to_f / esc_size : 0.0
    end
  end
  
  def total_ability_score_360(ev=nil)
    if ev.nil?
      return nil
    else
      total_ability_score_board_360(ev) + total_ability_score_staff_360(ev)
    end
  end
  
  def total_ability_score_board_360(ev=nil)
    if ev.nil?
      return nil
    else
      escs = evaluation_score_cards.where(["evaluation_id = ? AND role IN (?)", ev.id, board_360_roles])
      esc_size = escs.size
      sc = escs.collect {|esc| esc.ability_score.to_i}.sum
      return esc_size > 0 ? sc.to_f / esc_size : 0.0
    end
  end
  
  def total_ability_score_staff_360(ev=nil)
    if ev.nil?
      return nil
    else
      escs = evaluation_score_cards.where(["evaluation_id = ? AND role IN (?)", ev.id, staff_360_roles])
      esc_size = escs.size
      sc = escs.collect {|esc| esc.ability_score.to_i}.sum
      return esc_size > 0 ? sc.to_f / esc_size : 0.0
    end
  end
  
  def self_total_task_score_360(ev=nil)
    if ev.nil?
      return nil
    else
      escs = evaluation_score_cards.where(["evaluation_id = ? AND role IN (?)", ev.id, ["self"]])
      esc_size = escs.size
      sc = escs.collect {|esc| esc.task_score.to_i}.sum
      return esc_size > 0 ? sc.to_f / esc_size : 0.0
    end
  end
  
  def self_total_ability_score_360(ev=nil)
    if ev.nil?
      return nil
    else
      escs = evaluation_score_cards.where(["evaluation_id = ? AND role IN (?)", ev.id, ["self"]])
      esc_size = escs.size
      sc = escs.collect {|esc| esc.ability_score.to_i}.sum
      return esc_size > 0 ? sc.to_f / esc_size : 0.0
    end
  end
  
  def self_total_score_360(ev=nil)
    if ev.nil?
      return nil
    else
      self_total_task_score_360(ev) + self_total_ability_score_360(ev)
    end
  end
  
  def report_score(ev=nil, options={})
    if ev.nil?
      0
    else
      if options[:before]
        if ev.is_360?
          total_score_360(ev).to_f
        else
          final_score(ev).to_f
        end
      else
        evaluation_salary_up_user(ev) ? evaluation_salary_up_user(ev).point.to_f : 0
      end
    end
  end
  
  def report_task_score(ev=nil)
    if ev.nil?
      0
    else
      report_score(ev) * task_ratio(ev).to_f / 100
    end
  end
  
  def report_ability_score(ev=nil)
    if ev.nil?
      0
    else
      report_score(ev) * ability_ratio(ev).to_f / 100
    end
  end
  
  def evaluation_salary_up_user(ev=nil)
    if ev.nil?
      nil
    else
      evaluation_salary_up_users.where(["evaluation_id = ?", ev.id]).first
    end
  end
  
  def report_score_level(ev=nil, options={})
    fsl = ""
    fs = report_score(ev, options)
    if fs >= 90 
      fsl = "ดีเด่น (90 - 100)"
    elsif fs >= 80 && fs < 90
      fsl = "ดีมาก (80 - 89)"
    elsif fs >= 70 && fs < 80
      fsl = "ดี (70 - 79)"
    elsif fs >= 60 && fs < 70
      fsl = "พอใช้ (60 - 69)"
    elsif fs < 60
      fsl = "ต้องปรับปรุง (ต่ำกว่า 60)"
    end
    return fsl
  end
  
  include Workflow
  workflow do
    state :new do
      event :submit, transitions_to: :enabled
    end
    state :enabled, meta: {no_destroy: true} do
      event :save_change, transitions_to: :enabled
      event :disable, transitions_to: :disabled
      event :terminate, transitions_to: :terminated
    end
    state :disabled, meta: {no_destroy: true} do
      event :enable, transitions_to: :enabled
      event :terminate, transitions_to: :terminated
    end
    state :terminated, meta: {no_destroy: true, disabled: true}

    on_transition do |from, to, event, *event_args|
      WorkflowStateLog.create({
        resource_class: self.class.to_s,
        resource_id: self.id,
        state_from: from,
        state_to: to,
        event: event,
        serialized_object: YAML.dump(self)
      })
    end
  end

  def self.active_states
    [:new, :enabled]
  end

  def self.form_action_events(action_name = nil)
    {
      new: [:submit],
      create: [:submit], 
      edit: [:save_change],
      update: [:save_change,], 
      show: [:enable, :disable, :terminate], 
      index: [:terminate]
    }[action_name.to_sym]
  end
  
end
