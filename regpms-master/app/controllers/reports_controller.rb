# encoding: utf-8
require 'rtf'

class ReportsController < OrbController
  
  # authorize_resource :class => false
  # skip_authorization_check
  authorize_resource :class => false
  
  before_filter :has_current_evaluation?
  
  def users
    params[:q] ||= {}
    params[:q][:workflow_state_eq] = :enabled
    params[:q][:employee_type_id_not_null] = true
    params[:q][:position_id_not_null] = true
    params[:q][:username_not_eq] = "admin"
    params[:q][:username_not_eq] = "batt"
    params[:q][:username_not_eq] = "demo"
    params[:q][:username_not_start] = "dean_%"
    @q = User.limit(params[:limit]).search(params[:q])
    @q.sorts = 'firstname, lastname' if @q.sorts.empty?
    @users = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 200) : @q.result
    
    respond_to do |format|
      format.html
      format.json
    end
  end
  
  def user
    if User.exists?(params[:id])
      @user = User.find(params[:id])
    else
      redirect_to action: "index"
      return false
    end
  end
  
  def comment
    if User.exists?(params[:id])
      evaluation = @current_evaluation
      user = User.find(params[:id])
      
      if evaluation.is_360?

        committees = []
        user.assess_committee_by(evaluation).each {|c| committees << [c.user_id, "committee"]} 
        user.assess_section_leaders_by(evaluation).each {|c| committees << [c.id, "section_leader"]}
        user.assess_section_vice_leaders_by(evaluation).each {|c| committees << [c.id, "section_vice_leader"]}
        user.assess_team_leaders_by(evaluation).each {|c| committees << [c.id, "team_leader"]}
        user.assess_faculty_deans_by(evaluation).each {|c| committees << [c.id, "faculty_dean"]}
        user.assess_faculty_leaders_by(evaluation).each {|c| committees << [c.id, "faculty_leader"]}

        evaluation_users = user.evaluation_users.where(["evaluation_id = ?", evaluation.id])

      else

        committees = []
        committees << [evaluation.director_id, "director"]
        committees << [evaluation.vice_director_id, "vice_director"]
        committees << [evaluation.vice_director2_id, "vice_director"]
        committees << [evaluation.vice_director3_id, "vice_director"]
        
        evaluation_users = user.evaluation_score_cards.where(["evaluation_id = ?", evaluation.id])

      end
            
      document_style = RTF::DocumentStyle.new
      document_style.top_margin = 850
      document_style.bottom_margin = 850
      document_style.left_margin = 1415
      document_style.right_margin = 1415
  
      document = RTF::Document.new(RTF::Font.new(RTF::Font::NIL, "TH SarabunPSK"), document_style)
      
      styles = load_rtf_style
      
      document.paragraph(styles['CENTER']).apply(styles['NORMAL_BOLD']) << "ความคิดเห็นของผู้ประเมิน"
      document.paragraph(styles['FULL']).apply(styles['SPACE']) << " "
      
      table = document.table(3, 2, 2000, 7000)
      table[0][0].style = styles['LEFT']
      table[0][1].style = styles['LEFT']
      table[1][0].style = styles['LEFT']
      table[1][1].style = styles['LEFT']
      table[2][0].style = styles['LEFT']
      table[2][1].style = styles['LEFT']
      table[0][0].apply(styles['NORMAL_BOLD']) << "รอบการประเมิน   :" 
      table[0][1].apply(styles['NORMAL']) << "#{evaluation.full}"
      table[1][0].apply(styles['NORMAL_BOLD']) << "ผู้รับการประเมิน  :" 
      table[1][1].apply(styles['NORMAL']) << "#{user.prefix_firstname_lastname}"
      table[2][0].apply(styles['NORMAL_BOLD']) << "ตำแหน่ง/ระดับ   :" 
      table[2][1].apply(styles['NORMAL']) << "#{user.position_name}" 
      document.paragraph(styles['FULL']).apply(styles['SPACE']) << " "
      
      xxx = 1 + committees.size
      table = document.table(xxx, 3, 1500, 3750, 3750)
      table.border_width = 1
      table[0][0].style = styles['CENTER']
      table[0][1].style = styles['CENTER']
      table[0][2].style = styles['CENTER']
      table[0][0].apply(styles['NORMAL_BOLD']) << "ผู้ประเมิน" 
      table[0][1].apply(styles['NORMAL_BOLD']) << "#{EvaluationUser.human_attribute_name(:comment1)}"
      table[0][2].apply(styles['NORMAL_BOLD']) << "#{EvaluationUser.human_attribute_name(:comment2)}"
      ccc = 0
      
      committees.each do |committee| 
        evaluation_user = evaluation_users.select {|eu| eu.committee_id == committee[0] && eu.role == committee[1]}.first
        ccc += 1
        table[ccc][0].style = styles['CENTER']
        table[ccc][1].style = styles['CENTER']
        table[ccc][2].style = styles['CENTER']
        table[ccc][0].apply(styles['NORMAL']) << "ผู้ประเมิน ##{ccc}" 
        table[ccc][1].apply(styles['NORMAL']) << "#{evaluation_user && !evaluation_user.comment1.blank? ? evaluation_user.comment1 : '-'}"
        table[ccc][2].apply(styles['NORMAL']) << "#{evaluation_user && !evaluation_user.comment2.blank? ? evaluation_user.comment2 : '-'}"
      end 
      document.paragraph(styles['FULL']).apply(styles['SPACE']) << " "
      
      document.paragraph(styles['LEFT']).apply(styles['NORMAL_BOLD']) << "การรับทราบความคิดเห็น"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL_BOLD']) << "ผู้รับการประเมิน"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t[  ] ได้รับทราบความคิดเห็นรายบุคคลแล้ว"
      document.paragraph(styles['FULL']).apply(styles['SPACE']) << " "
      
      document.paragraph(styles['RIGHT']).apply(styles['NORMAL']) << "ลงชื่อ ..................................................."
      document.paragraph(styles['RIGHT']).apply(styles['NORMAL']) << "ตำแหน่ง ..............................................."
      document.paragraph(styles['RIGHT']).apply(styles['NORMAL']) << "วันที่ ....................................................."
      document.paragraph(styles['FULL']).apply(styles['SPACE']) << " "
      
      document.paragraph(styles['LEFT']).apply(styles['NORMAL_BOLD']) << "ผู้ประเมิน"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t[  ] ได้แจ้งความคิดเห็นรายบุคคลแล้ว"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t[  ] ได้แจ้งความคิดเห็นรายบุคคลเมื่อวันที่ ...........................  แต่ผู้รับการประเมินไม่ลงนามรับทราบความคิดเห็น"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t     โดยมี ............................................ เป็นพยาน"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t     ลงชื่อ ........................................... (พยาน)"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t     ตำแหน่ง ..................................................."
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t     วันที่ ........................................................."
      document.paragraph(styles['FULL']).apply(styles['SPACE']) << " "
      document.paragraph(styles['FULL']).apply(styles['SPACE']) << " "
      
      document.paragraph(styles['RIGHT']).apply(styles['NORMAL']) << "ลงชื่อ ...................................................(ผู้ประเมิน)"
      document.paragraph(styles['RIGHT']).apply(styles['NORMAL']) << "ตำแหน่ง ................................................................."
      document.paragraph(styles['RIGHT']).apply(styles['NORMAL']) << "วันที่ ......................................................................."
      document.paragraph(styles['FULL']).apply(styles['SPACE']) << " "
  
      # filename = "report_comment_#{'%05d' % user.id}_#{evaluation.year + 543}_#{evaluation.episode}_#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}.doc"
      filename = "รายงานข้อคิดเห็น_#{user.prefix_firstname_lastname.gsub(' ', '_')}_#{evaluation.year + 543}_#{evaluation.episode}_#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}.doc"
      filename_path = File.join("public", "files", "reports", "comments", filename)
      my_rtf = File.new(filename_path, "w")
      my_rtf.write(document.to_rtf)
      my_rtf.close
      
      send_file filename_path
      return false
    else
      redirect_to action: "index"
      return false
    end
  end
  
  def r4
    if User.exists?(params[:id])
      evaluation = @current_evaluation
      evaluationx1 = evaluation.episode == 1 ? evaluation : Evaluation.where(["year = ? AND episode = ?", evaluation.year, 1]).first
      evaluationx1 = Evaluation.new(year: evaluation.year, episode: 1) if evaluationx1.nil?
      evaluationx2 = evaluation.episode == 2 ? evaluation : Evaluation.where(["year = ? AND episode = ?", evaluation.year, 2]).first
      evaluationx2 = Evaluation.new(year: evaluation.year, episode: 2) if evaluationx2.nil?
      
      user = User.find(params[:id])
      evaluation_employee_type = evaluation.evaluation_employee_types.select {|eet| eet.employee_type_id == user.employee_type_id}.first
      evaluation_employee_type = evaluation.evaluation_employee_types.new if evaluation_employee_type.nil?
      evaluation_users = user.evaluation_users.where(["evaluation_id = ?", evaluation.id])
      committees = []
      user.assess_committee_by(evaluation).each {|c| committees << [c.user_id, "committee"]} 
      user.assess_section_leaders_by(evaluation).each {|c| committees << [c.id, "section_leader"]}
      user.assess_section_vice_leaders_by(evaluation).each {|c| committees << [c.id, "section_vice_leader"]}
      user.assess_team_leaders_by(evaluation).each {|c| committees << [c.id, "team_leader"]}
      user.assess_faculty_deans_by(evaluation).each {|c| committees << [c.id, "faculty_dean"]}
      user.assess_faculty_leaders_by(evaluation).each {|c| committees << [c.id, "faculty_leader"]}
      
      document_style = RTF::DocumentStyle.new
      document_style.top_margin = 850
      document_style.bottom_margin = 850
      document_style.left_margin = 1415
      document_style.right_margin = 1415
  
      document = RTF::Document.new(RTF::Font.new(RTF::Font::NIL, "TH SarabunPSK"), document_style)
      
      styles = load_rtf_style
      
      document.paragraph(styles['CENTER']).apply(styles['NORMAL_BOLD']) << "แบบสรุปการประเมินผลการปฏิบัติราชการ"
      document.paragraph(styles['CENTER']).apply(styles['NORMAL_BOLD']) << "ของข้าราชการในสถาบันอุดมศึกษา สังกัดมหาวิทยาลัยขอนแก่น"
      document.paragraph(styles['CENTER']).apply(styles['NORMAL_BOLD']) << "สำนักบริหารและพัฒนาวิชาการ"
      document.paragraph(styles['FULL']).apply(styles['SPACE']) << " "
      
      document.paragraph(styles['LEFT']).apply(styles['NORMAL_BOLD']) << "ส่วนที่ 1 ข้อมูลของผู้รับการประเมิน"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\tรอบการประเมิน\t#{evaluation.full}"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\tผู้รับการประเมิน\t#{user.prefix_firstname_lastname}"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t\t\tตำแหน่ง #{user.position}"
      user.sections.each do |ttt|
        document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t\t\tสังกัด #{ttt.to_s}"
      end
      user.faculties.each do |ttt|
        document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t\t\tสังกัด #{ttt.to_s}"
      end
      user.teams.each do |ttt|
        document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t\t\tสังกัด #{ttt.to_s}"
      end
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\tผู้ประเมิน\t\t1. #{evaluation.director.prefix_firstname_lastname} (ผู้อำนวยการ)"
      iab = 1
      user.assess_faculty_deans_by(evaluation).each do |ab|
        document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t\t\t#{iab += 1}. #{ab.prefix_firstname_lastname} (#{Faculty.human_attribute_name(:dean)})"
      end
      user.assess_faculty_leaders_by(evaluation).each do |ab|
        document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t\t\t#{iab += 1}. #{ab.prefix_firstname_lastname} (#{Faculty.human_attribute_name(:leader)})"
      end
      user.assess_section_leaders_by(evaluation).each do |ab|
        document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t\t\t#{iab += 1}. #{ab.prefix_firstname_lastname} (#{Section.human_attribute_name(:leader)})"
      end
      user.assess_section_vice_leaders_by(evaluation).each do |ab|
        document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t\t\t#{iab += 1}. #{ab.prefix_firstname_lastname} (#{Section.human_attribute_name(:vice_leader)})"
      end
      user.assess_team_leaders_by(evaluation).each do |ab|
        document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t\t\t#{iab += 1}. #{ab.prefix_firstname_lastname} (#{Team.human_attribute_name(:leader)})"
      end
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t\t\tและคณะกรรมการประเมิน"
      document.paragraph(styles['FULL']).apply(styles['SPACE']) << " "

      
      document.paragraph(styles['CENTER']).apply(styles['NORMAL_BOLD']) << "คำชี้แจง"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "แบบสรุปการประเมินผลการปฏิบัติราชการนี้มีด้วยกัน 5 ส่วน ดังนี้" 
      document.paragraph(styles['LEFT']).apply(styles['NORMAL_BOLD']) << "ส่วนที่ 1 ข้อมูลของผู้รับการประเมิน"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "เพื่อระบุรายละเอียดต่างๆ ที่เกี่ยวข้องกับตัวผู้รับการประเมิน"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL_BOLD']) << "ส่วนที่ 2 การสรุปผลการประเมิน"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "ใช้เพื่อกรอกค่าคะแนนการประเมินในองค์ประกอบด้านผลสัมฤทธิ์ของงาน องค์ประกอบด้านพฤติกรรมการปฏิบัติราชการ และน้ำหนัก ของทั้งสององค์ประกอบ ในแบบสรุปส่วนที่ 2 นี้ ยังใช้สำหรับคำนวณคะแนนผลการปฏิบัติราชการรวมด้วย"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL_BOLD']) << "ส่วนที่ 3 แผนพัฒนาการปฏิบัติราชการรายบุคคล"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "ผู้ประเมินและผู้รับการประเมินร่วมกันจัดทำแผนพัฒนาผลการปฏิบัติราชการ"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL_BOLD']) << "ส่วนที่ 4 การรับทราบผลการประเมิน "
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "ผู้รับการประเมินลงนามรับทราบผลการประเมิน"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL_BOLD']) << "ส่วนที่ 5 ความเห็นของผู้บังคับบัญชาเหนือขึ้นไป"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "ผู้บังคับบัญชาเหนือขึ้นไปกลั่นกรองผลการประเมินแผนพัฒนาผลการปฏิบัติราชการ และให้ความเห็น"
      document.paragraph(styles['FULL']).apply(styles['SPACE']) << " "
      
      task_ratio = user.task_ratio(evaluation).to_f
      task_total = user.report_task_score(evaluation).to_f
      task_score = task_total * 100 / task_ratio
      
      ability_ratio = user.ability_ratio(evaluation).to_f
      ability_total = user.report_ability_score(evaluation).to_f
      ability_score = ability_total * 100 / ability_ratio
      
      score_total = user.report_score(evaluation)
      
      document.paragraph(styles['LEFT']).apply(styles['NORMAL_BOLD']) << "ส่วนที่ 2 การสรุปผลการประเมิน"
      table = document.table(5, 4, 3500, 2000, 2000, 2000)
      table.border_width = 1
      table[0][0].style = styles['CENTER']
      table[0][1].style = styles['CENTER']
      table[0][2].style = styles['CENTER']
      table[0][3].style = styles['CENTER']
      table[0][0].apply(styles['NORMAL_BOLD']) << "องค์ประกอบการประเมิน" 
      table[0][1].apply(styles['NORMAL_BOLD']) << "ค่าคะแนนที่ได้หลังถ่วงน้ำหนัก (ก)"
      table[0][2].apply(styles['NORMAL_BOLD']) << "สัดส่วนคะแนน (ข)" 
      table[0][3].apply(styles['NORMAL_BOLD']) << "สรุปคะแนน (ก) X (ข)"
      table[1][0].style = styles['LEFT']
      table[1][1].style = styles['CENTER']
      table[1][2].style = styles['CENTER']
      table[1][3].style = styles['CENTER']
      table[1][0].apply(styles['NORMAL']) << "องค์ประกอบที่ 1 ผลสัมฤทธิ์ของงาน" 
      table[1][1].apply(styles['NORMAL']) << "#{task_score.to_s_decimal_comma}"
      table[1][2].apply(styles['NORMAL']) << "#{task_ratio.to_s_decimal_comma}%"
      table[1][3].apply(styles['NORMAL']) << "#{task_total.to_s_decimal_comma}"
      table[2][0].style = styles['LEFT']
      table[2][1].style = styles['CENTER']
      table[2][2].style = styles['CENTER']
      table[2][3].style = styles['CENTER']
      table[2][0].apply(styles['NORMAL']) << "องค์ประกอบที่ 2 พฤติกรรมการปฏิบัติราชการ" 
      table[2][1].apply(styles['NORMAL']) << "#{ability_score.to_s_decimal_comma}"
      table[2][2].apply(styles['NORMAL']) << "#{ability_ratio.to_s_decimal_comma}%"
      table[2][3].apply(styles['NORMAL']) << "#{ability_total.to_s_decimal_comma}"
      table[3][0].style = styles['LEFT']
      table[3][1].style = styles['CENTER']
      table[3][2].style = styles['CENTER']
      table[3][3].style = styles['CENTER']
      table[3][0].apply(styles['NORMAL']) << "องค์ประกอบอื่นๆ (ถ้ามี)"
      table[3][1].apply(styles['NORMAL']) << "-"
      table[3][2].apply(styles['NORMAL']) << "-"
      table[3][3].apply(styles['NORMAL']) << "-"
      table[4][0].style = styles['CENTER']
      table[4][1].style = styles['CENTER']
      table[4][2].style = styles['CENTER']
      table[4][3].style = styles['CENTER']
      table[4][0].apply(styles['NORMAL_BOLD']) << "รวม" 
      table[4][1].apply(styles['NORMAL_BOLD']) << "#{}"
      table[4][2].apply(styles['NORMAL_BOLD']) << "#{(task_ratio + ability_ratio).to_s_decimal_comma}%" 
      table[4][3].apply(styles['NORMAL_BOLD']) << "#{score_total.to_s_decimal_comma}"
      document.paragraph(styles['FULL']).apply(styles['SPACE']) << " "
      document.paragraph(styles['LEFT']).apply(styles['NORMAL_BOLD']) << "ระดับผลการประเมินที่ได้"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL_BOLD']) << "\t[ #{score_total >= 90 ? '/' : ''} ]   ดีเด่น (90 - 100)"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL_BOLD']) << "\t[ #{score_total >= 80 && score_total < 90 ? '/' : ''} ]   ดีมาก (80 - 89)"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL_BOLD']) << "\t[ #{score_total >= 70 && score_total < 80 ? '/' : ''} ]   ดี (70 - 79)"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL_BOLD']) << "\t[ #{score_total >= 60 && score_total < 70 ? '/' : ''} ]   พอใช้ (60 - 69)"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL_BOLD']) << "\t[ #{score_total < 60 ? '/' : ''} ]   ต้องปรับปรุง (ต่ำกว่า 60)"
      document.paragraph(styles['FULL']).apply(styles['SPACE']) << " "
      
      document.paragraph(styles['LEFT']).apply(styles['NORMAL_BOLD']) << "ส่วนที่ 3 แผนพัฒนาการปฏิบัติราชการรายบุคคล"
      table = document.table(2, 3, 3500, 3000, 3000)
      table.border_width = 1
      table[0][0].style = styles['CENTER']
      table[0][1].style = styles['CENTER']
      table[0][2].style = styles['CENTER']
      table[0][0].apply(styles['NORMAL_BOLD']) << "ความรู้/ทักษะ/สมรรถนะที่ต้องการพัฒนา" 
      table[0][1].apply(styles['NORMAL_BOLD']) << "วิธีการพัฒนา"
      table[0][2].apply(styles['NORMAL_BOLD']) << "ช่วงเวลาที่ต้องการพัฒนา" 
      table[1][0].style = styles['CENTER']
      table[1][1].style = styles['CENTER']
      table[1][2].style = styles['CENTER']
      table[1][0].apply(styles['NORMAL']) << "-" 
      table[1][1].apply(styles['NORMAL']) << "-"
      table[1][2].apply(styles['NORMAL']) << "-"
      document.paragraph(styles['FULL']).apply(styles['SPACE']) << " "
      
      document.paragraph(styles['LEFT']).apply(styles['NORMAL_BOLD']) << "ส่วนที่ 4 การรับทราบผลการประเมิน"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL_BOLD']) << "ผู้รับการประเมิน"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t[  ] ได้รับทราบความคิดเห็นรายบุคคลแล้ว"
      document.paragraph(styles['FULL']).apply(styles['SPACE']) << " "
      
      document.paragraph(styles['RIGHT']).apply(styles['NORMAL']) << "ลงชื่อ ..................................................."
      document.paragraph(styles['RIGHT']).apply(styles['NORMAL']) << "ตำแหน่ง ..............................................."
      document.paragraph(styles['RIGHT']).apply(styles['NORMAL']) << "วันที่ ....................................................."
      document.paragraph(styles['FULL']).apply(styles['SPACE']) << " "
      
      document.paragraph(styles['LEFT']).apply(styles['NORMAL_BOLD']) << "ผู้ประเมิน"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t[  ] ได้แจ้งความคิดเห็นรายบุคคลแล้ว"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t[  ] ได้แจ้งความคิดเห็นรายบุคคลเมื่อวันที่ ...........................  แต่ผู้รับการประเมินไม่ลงนามรับทราบความคิดเห็น"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t     โดยมี ............................................ เป็นพยาน"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t     ลงชื่อ ........................................... (พยาน)"
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t     ตำแหน่ง ..................................................."
      document.paragraph(styles['LEFT']).apply(styles['NORMAL']) << "\t     วันที่ ........................................................."
      document.paragraph(styles['FULL']).apply(styles['SPACE']) << " "
      document.paragraph(styles['FULL']).apply(styles['SPACE']) << " "
      
      document.paragraph(styles['RIGHT']).apply(styles['NORMAL']) << "ลงชื่อ ...................................................(ผู้ประเมิน)"
      document.paragraph(styles['RIGHT']).apply(styles['NORMAL']) << "ตำแหน่ง ................................................................."
      document.paragraph(styles['RIGHT']).apply(styles['NORMAL']) << "วันที่ ......................................................................."
      document.paragraph(styles['FULL']).apply(styles['SPACE']) << " "

      
      # filename = "report_comment_#{'%05d' % user.id}_#{evaluation.year + 543}_#{evaluation.episode}_#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}.doc"
      filename = "รงปม4_#{user.prefix_firstname_lastname.gsub(' ', '_')}_#{evaluation.year + 543}_#{evaluation.episode}_#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}.doc"
      filename_path = File.join("public", "files", "reports", "r4s", filename)
      my_rtf = File.new(filename_path, "w")
      my_rtf.write(document.to_rtf)
      my_rtf.close
      
      send_file filename_path
      return false
    else
      redirect_to action: "index"
      return false
    end
  end
  
  def employee_type
    @employee_types = EmployeeType.all_enabled
    if params[:id] && EmployeeType.exists?(params[:id])
      
      evaluation = @current_evaluation
      @employee_type = EmployeeType.find(params[:id])
      evaluation_employee_type = evaluation.evaluation_employee_types.where(["employee_type_id = ?", @employee_type.id]).first
      
      book = Spreadsheet::Workbook.new
      
      font = Spreadsheet::Font.new "TH Sarabun New"

      format_header = Spreadsheet::Format.new :weight => :bold, :font => font, :size => 16
      format_header_merge = Spreadsheet::Format.new :weight => :bold, :font => font, :size => 16, :align => :merge
      format_header_right = Spreadsheet::Format.new :weight => :bold, :font => font, :size => 16, :horizontal_align => :right
      
      # format_table_header_center = Spreadsheet::Format.new :weight => :bold, :font => font, :size => 16, :pattern => 1, :pattern_fg_color => "gray", :horizontal_align => :center
      # format_table_header_merge = Spreadsheet::Format.new :weight => :bold, :font => font, :size => 16, :pattern => 1, :pattern_fg_color => "gray", :align => :merge
      # format_table_header_merge_right = Spreadsheet::Format.new  :weight => :bold, :font => font, :size => 16, :pattern => 1, :pattern_fg_color => "gray", :align => :merge, :horizontal_align => :right
      
      format_table_header_center = Spreadsheet::Format.new :weight => :bold, :font => font, :size => 16, :border => :thin, :pattern_fg_color => "gray", :horizontal_align => :center, :vertical_align => :middle
      format_table_header_merge = Spreadsheet::Format.new :weight => :bold, :font => font, :size => 16, :border => :thin, :pattern_fg_color => "gray", :align => :merge, :vertical_align => :middle
      format_table_header_merge_right = Spreadsheet::Format.new  :weight => :bold, :font => font, :size => 16, :border => :thin, :pattern_fg_color => "gray", :align => :merge, :horizontal_align => :right, :vertical_align => :middle

      format_table_cell = Spreadsheet::Format.new :font => font, :size => 16, :border => :thin
      format_table_cell_right = Spreadsheet::Format.new :horizontal_align => :right, :font => font, :size => 16, :border => :thin
      format_table_cell_center = Spreadsheet::Format.new :horizontal_align => :center, :font => font, :size => 16, :border => :thin
      format_table_cell_number = Spreadsheet::Format.new :horizontal_align => :right, :number_format => '#,##0.00', :font => font, :size => 16, :border => :thin
      
      position_types = []
      if @employee_type.name == "ข้าราชการ"
        position_types = ["เชี่ยวชาญเฉพาะ/ประเภทผู้บริหาร", "ทั่วไป"]
      else
        position_types = ["all"]
      end
      
      position_types.each do |position_type|
          
        sheet_name = @employee_type.name[0..20]
        position_type_header = "ประเภทตำแหน่งวิชาชีพเฉพาะ #{position_type}"
        if position_type == "เชี่ยวชาญเฉพาะ/ประเภทผู้บริหาร"
          sheet_name = "#{@employee_type}(วิชาชีพเฉพาะ)"
          position_type_header = "ประเภทตำแหน่งวิชาชีพเฉพาะ เชี่ยวชาญเฉพาะ/ประเภทผู้บริหาร"
          position_type_ids = PositionType.where(["name = ? OR name = ?", "เชี่ยวชาญเฉพาะ", "ผู้บริหาร"]).collect {|pt| pt.id}
          @users = User.select("users.*").order("users.firstname, users.lastname").joins("JOIN positions ON positions.id  = users.position_id").where(["users.employee_type_id = ? AND positions.position_type_id IN (?) AND users.workflow_state = ?", @employee_type, position_type_ids, :enabled])
        elsif position_type == "ทั่วไป"
          sheet_name = "#{@employee_type}(ตำแหน่งทั่วไป)"
          position_type_header = "ประเภทตำแหน่งวิชาชีพเฉพาะ ตำแหน่งทั่วไป"
          position_type_ids = PositionType.where(["name = ?", "ทั่วไป"]).collect {|pt| pt.id}
          @users = User.select("users.*").order("users.firstname, users.lastname").joins("JOIN positions ON positions.id  = users.position_id").where(["users.employee_type_id = ? AND positions.position_type_id IN (?) AND users.workflow_state = ?", @employee_type, position_type_ids, :enabled])
        else
          position_type = ""
          @users = User.order("firstname, lastname").where(["employee_type_id = ? AND users.workflow_state = ?", @employee_type, :enabled])
        end
        @users -= User.where(["username IN (?) OR username LIKE ?", ["admin", "batt", "demo"], "dean_%"])
        
        # page 1 ############################################################################################################################################################################################################################################
        sheet = book.create_worksheet :name => "#{sheet_name}-1"
        
        sheet_column_widths = [10, 40, 25, 30, 30, 10, 10, 10, 10, 10, 10, 10, 10, 10, 15]
        sheet_column_widths.each_index {|idx| sheet.column(idx).width = sheet_column_widths[idx]}
        
        row = 0
        rdata = ["ผลการประเมินการปฏิบัติราชการ ของ#{@employee_type}สำนักบริหารและพัฒนาวิชาการ"]  
        sheet.row(row).replace rdata
        (0..14).each {|column| sheet.row(row).set_format(column, format_header_merge)}
        row += 1
        rdata = ["#{evaluation.full2}"]  
        sheet.row(row).replace rdata
        (0..14).each {|column| sheet.row(row).set_format(column, format_header_merge)}
        row += 1
        rdata = [position_type]  
        sheet.row(row).replace rdata
        (0..14).each {|column| sheet.row(row).set_format(column, format_header_merge)}
        row += 1
        
        [0, 1, 2, 3, 4, 13, 14].each {|column| sheet.merge_cells(row, column, row + 1, column)}
        
        rdata = ["ลำดับที่", "ชื่อ-สกุล", "ประเภท", "ตำแหน่ง", "กลุ่มภารกิจ", "ผู้บังคับบัญชาขั้นต้น", nil, nil, nil, "คณะกรรมการ", nil, nil, nil, "รวมหลังถ่วงน้ำหนัก (100%)", "ระดับผลการประเมิน"]
        sheet.row(row).replace rdata
        (0..4).each {|column| sheet.row(row).set_format(column, format_table_header_merge)}
        (5..12).each {|column| sheet.row(row).set_format(column, format_table_header_merge)}
        (13..14).each {|column| sheet.row(row).set_format(column, format_table_header_merge)}
        row += 1

        rdata = [nil, nil, nil, nil, nil, "ผลสัมฤทธิ์ของงาน (#{evaluation_employee_type.task_ratio.to_i}%)", "พฤติกรรมการปฏิบัติราชการ (#{evaluation_employee_type.ability_ratio.to_i}%)", "คะแนนรวม", "หลังถ่วงน้ำหนัก (#{evaluation_employee_type.leaderx_ratio.to_i}%)", "ผลสัมฤทธิ์ของงาน (#{evaluation_employee_type.task_ratio.to_i}%)", "พฤติกรรมการปฏิบัติราชการ (#{evaluation_employee_type.ability_ratio.to_i}%)", "คะแนนรวม", "หลังถ่วงน้ำหนัก (#{evaluation_employee_type.committee_ratio.to_i}%)", nil, nil]
        sheet.row(row).replace rdata
        (5..12).each {|column| sheet.row(row).set_format(column, format_table_header_merge)}
        row += 1 
        
        count = 0
        @users.each do |user|
          
          if params[:before]
            leader_ratio = user.leader_ratio(evaluation).to_f
            committee_ratio = user.committee_ratio(evaluation).to_f
            
            task_leader_score_ratio = user.task_leader_score_task_ratio(evaluation).to_f
            task_committee_score_ratio = user.task_committee_score_task_ratio(evaluation).to_f
            
            ability_leader_score_ratio = user.ability_leader_score_ability_ratio(evaluation).to_f
            ability_committee_score_ratio = user.ability_committee_score_ability_ratio(evaluation).to_f
            
            leader_score_ratio = task_leader_score_ratio + ability_leader_score_ratio
            committee_score_ratio = task_committee_score_ratio + ability_committee_score_ratio
            
            leader_score_ratiox = leader_score_ratio * leader_ratio / 100
            committee_score_ratiox = committee_score_ratio * committee_ratio / 100
            
            final_score = user.final_score(evaluation)
            final_score_level = user.final_score_level(evaluation)
          else
            leader_ratio = user.leader_ratio(evaluation)
            committee_ratio = user.committee_ratio(evaluation)
            
            task_leader_score_ratio = 0
            task_committee_score_ratio = 0
            
            ability_leader_score_ratio = 0
            ability_committee_score_ratio = 0
            
            leader_score_ratio = 0
            committee_score_ratio = 0
            
            leader_score_ratiox = 0
            committee_score_ratiox = 0
            
            final_score = user.report_score(evaluation)
            final_score_level = user.report_score_level(evaluation)
          end
          
          rdata = [
            count += 1, 
            user.prefix_firstname_lastname, 
            user.employee_type.to_s, 
            user.position.to_s, 
            user.sections.collect {|s| s.to_s}.join(', '), 
            final_score > 0 ? task_leader_score_ratio.to_s_decimal_comma : '-',  
            final_score > 0 ? ability_leader_score_ratio.to_s_decimal_comma : '-',  
            final_score > 0 ? leader_score_ratio.to_s_decimal_comma : '-',  
            final_score > 0 ? leader_score_ratiox.to_s_decimal_comma : '-',
            final_score > 0 ? task_committee_score_ratio.to_s_decimal_comma : '-',   
            final_score > 0 ? ability_committee_score_ratio.to_s_decimal_comma : '-',  
            final_score > 0 ? committee_score_ratio.to_s_decimal_comma : '-',  
            final_score > 0 ? committee_score_ratiox.to_s_decimal_comma : '-',
            final_score > 0 ? final_score.to_s_decimal_comma : '-',  
            final_score > 0 ? final_score_level : '-'
          ]
          sheet.row(row).replace rdata
          (0..14).each {|column| sheet.row(row).set_format(column, format_table_cell_center)}
          [1, 3, 4].each {|column| sheet.row(row).set_format(column, format_table_cell)}
          row += 1   
        end
        
        # page 2 ############################################################################################################################################################################################################################################
        sheet = book.create_worksheet :name => "#{sheet_name}-2"
        
        sheet_column_widths = [10, 40, 40, 30, 30, 10, 10, 10, 15]
        sheet_column_widths.each_index {|idx| sheet.column(idx).width = sheet_column_widths[idx]}
        
        row = 0
        rdata = ["ผลการประเมินการปฏิบัติราชการ ของ#{@employee_type}สำนักบริหารและพัฒนาวิชาการ"]  
        sheet.row(row).replace rdata
        (0..8).each {|column| sheet.row(row).set_format(column, format_header_merge)}
        row += 1
        rdata = ["#{evaluation.full2}"]  
        sheet.row(row).replace rdata
        (0..8).each {|column| sheet.row(row).set_format(column, format_header_merge)}
        row += 1
        rdata = [position_type]  
        sheet.row(row).replace rdata
        (0..8).each {|column| sheet.row(row).set_format(column, format_header_merge)}
        row += 1
        
        [0, 1, 2, 3, 4, 8].each {|column| sheet.merge_cells(row, column, row + 1, column)}
        
        rdata = ["ลำดับที่", "ชื่อ-สกุล", "กลุ่มงาน", "ตำแหน่ง", "กลุ่มภารกิจ", "ผลการประเมิน", nil, nil, "ระดับผลการประเมิน"]
        sheet.row(row).replace rdata
        (0..8).each {|column| sheet.row(row).set_format(column, format_table_header_merge)}
        row += 1

        rdata = [nil, nil, nil, nil, nil, "ผลสัมฤทธิ์ของงาน (#{evaluation_employee_type.task_ratio.to_i}%)", "พฤติกรรมการปฏิบัติราชการ (#{evaluation_employee_type.ability_ratio.to_i}%)", "คะแนนรวม", nil]
        sheet.row(row).replace rdata
        (5..8).each {|column| sheet.row(row).set_format(column, format_table_header_merge)}
        row += 1 
        
        count = 0
        @users.each do |user|
          
            if params[:before]
              task_leader_score_ratio = user.task_leader_score_task_ratio_with_leader_ratio(evaluation)
              task_committee_score_ratio = user.task_committee_score_task_ratio_with_committee_ratio(evaluation)
              task_score = task_leader_score_ratio + task_committee_score_ratio
    
              ability_leader_score_ratio = user.ability_leader_score_ability_ratio_with_leader_ratio(evaluation)
              ability_committee_score_ratio = user.ability_committee_score_ability_ratio_with_committee_ratio(evaluation)
              ability_score = ability_leader_score_ratio + ability_committee_score_ratio
              
              final_score = user.final_score(evaluation)
              final_score_level = user.final_score_level(evaluation)
            else
              task_leader_score_ratio = 0
              task_committee_score_ratio = 0
              task_score = user.report_task_score(evaluation)
    
              ability_leader_score_ratio = 0
              ability_committee_score_ratio = 0
              ability_score = user.report_ability_score(evaluation)
              
              final_score = user.report_score(evaluation)
              final_score_level = user.report_score_level(evaluation)
            end
          
          rdata = [
            count += 1, 
            user.prefix_firstname_lastname, 
            " ", 
            user.position.to_s, 
            user.sections.collect {|s| s.to_s}.join(', '),   
            final_score > 0 ? task_score.to_s_decimal_comma : '-',  
            final_score > 0 ? ability_score.to_s_decimal_comma : '-',  
            final_score > 0 ? final_score.to_s_decimal_comma : '-',  
            final_score > 0 ? final_score_level : '-'
          ]
          sheet.row(row).replace rdata
          (0..8).each {|column| sheet.row(row).set_format(column, format_table_cell_center)}
          [1, 3, 4].each {|column| sheet.row(row).set_format(column, format_table_cell)}
          row += 1   
        end
        
        # page 3 ############################################################################################################################################################################################################################################
        sheet = book.create_worksheet :name => "#{sheet_name}-3"
        
        sheet_column_widths = [10, 40, 40, 25, 30, 30, 30, 10, 15, 15]
        sheet_column_widths.each_index {|idx| sheet.column(idx).width = sheet_column_widths[idx]}
        
        row = 0
        rdata = ["ผลการประเมินการปฏิบัติราชการ ของ#{@employee_type}สำนักบริหารและพัฒนาวิชาการ"]  
        sheet.row(row).replace rdata
        (0..9).each {|column| sheet.row(row).set_format(column, format_header_merge)}
        row += 1
        rdata = ["#{evaluation.full2}"]  
        sheet.row(row).replace rdata
        (0..9).each {|column| sheet.row(row).set_format(column, format_header_merge)}
        row += 1
        rdata = [position_type]  
        sheet.row(row).replace rdata
        (0..9).each {|column| sheet.row(row).set_format(column, format_header_merge)}
        row += 1
        
        rdata = ["ลำดับที่", "ชื่อ-สกุล", "กลุ่มงาน", "ประเภท", "ตำแหน่ง", "กลุ่มภารกิจ", "สังกัดหน่วยงาน", "คะแนน (100)", "ระดับผลการประเมิน", "หมายเหตุ"]
        sheet.row(row).replace rdata
        (0..9).each {|column| sheet.row(row).set_format(column, format_table_header_merge)}
        row += 1
        
        count = 0
        @users.each do |user|
          
          if params[:before]
            final_score = user.final_score(evaluation)
            final_score_level = user.final_score_level(evaluation)
          else
            final_score = user.report_score(evaluation)
            final_score_level = user.report_score_level(evaluation)
          end
          
          rdata = [
            count += 1, 
            user.prefix_firstname_lastname, 
            " ", 
            user.employee_type.to_s, 
            user.position.to_s, 
            user.sections.collect {|s| s.to_s}.join(', '), 
            " ", 
            final_score > 0 ? final_score.to_s_decimal_comma : '-',  
            final_score > 0 ? final_score_level : '-',
            '-'
          ]
          sheet.row(row).replace rdata
          (0..9).each {|column| sheet.row(row).set_format(column, format_table_cell_center)}
          [1, 4, 5].each {|column| sheet.row(row).set_format(column, format_table_cell)}
          row += 1   
        end
          
      end
      
      filename = "สรุปผล#{@employee_type.to_s}_รอบ#{evaluation.episode}_ปี#{evaluation.year}_#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}.xls"
      filename_path = File.join("public", "files", "reports", "employee_types", filename)
      
      book.write filename_path
      send_file filename_path, :type => "application/vnd.ms-excel", :disposition => 'attachment'
      return false
    end
  end
    
  def job_result_others
    
    evaluation = @current_evaluation
    
    book = Spreadsheet::Workbook.new
    
    font = Spreadsheet::Font.new "TH Sarabun New"

    format_header = Spreadsheet::Format.new :weight => :bold, :font => font, :size => 16
    
    format_table_header = Spreadsheet::Format.new :weight => :bold, :font => font, :size => 16, :pattern_fg_color => "gray"

    format_table_cell = Spreadsheet::Format.new :font => font, :size => 16
    
    [
       ["plan", "งานยุทธศาสตร์", JobPlanResult], 
       ["routine", "งานหลัก", JobRoutineResult], 
       ["vice", "งานรอง", JobViceResult], 
       ["development", "งานเชิงพัฒนา", JobDevelopmentResult] 
    ].each do |job_type|
      
      sheet = book.create_worksheet :name => job_type[1]
        
      sheet_column_widths = [10, 10, 200]
      sheet_column_widths.each_index {|idx| sheet.column(idx).width = sheet_column_widths[idx]}
      
      row = 0
      rdata = ["PF #{job_type[1]} ที่กรอกเอง"]  
      sheet.row(row).replace rdata
      (0..2).each {|column| sheet.row(row).set_format(column, format_header)}
      row += 1
      
      select = "job_template_groups.name AS job_template_group_namex, job_templates.name AS job_template_namex, job_#{job_type[0]}s.name AS job_type_name, job_#{job_type[0]}_results.name AS job_result_name"
      where = ["job_#{job_type[0]}_results.job_result_template_id IS NULL AND job_#{job_type[0]}_results.evaluation_id = ?", evaluation]
      joins = ""
      joins += "JOIN job_#{job_type[0]}s ON job_#{job_type[0]}s.id = job_#{job_type[0]}_results.job_#{job_type[0]}_id "
      joins += "JOIN job_templates ON job_templates.id = job_#{job_type[0]}s.job_template_id "
      joins += "JOIN job_template_groups ON job_template_groups.id = job_templates.job_template_group_id "
      group = "job_template_groups.name, job_templates.name, job_#{job_type[0]}s.name, job_#{job_type[0]}_results.name "
      order = "job_template_groups.name, job_templates.name, job_#{job_type[0]}s.name, job_#{job_type[0]}_results.name"
      
      job_results = job_type[2].order(order).group(group).joins(joins).where(where).select(select)
      
      tmp_job_template_group_name = ""
      tmp_job_template_name = ""
      count = 0
      job_results.each do |job_result|
        
        if tmp_job_template_group_name != job_result.job_template_group_namex
          rdata = [
            job_result.job_template_group_namex.to_s.strip, 
            nil, 
            nil
          ]
          sheet.row(row).replace rdata
          (0..2).each {|column| sheet.row(row).set_format(column, format_table_header)}
          row += 1
          
          tmp_job_template_group_name = job_result.job_template_group_namex
          tmp_job_template_name = ""
        end
        
        if tmp_job_template_name != job_result.job_template_namex
          rdata = [ 
            nil, 
            job_result.job_template_namex.to_s.strip,
            nil
          ]
          sheet.row(row).replace rdata
          (0..2).each {|column| sheet.row(row).set_format(column, format_table_header)}
          row += 1
          
          tmp_job_template_name = job_result.job_template_namex
        end
        
        rdata = [ 
          nil, 
          count += 1, 
          job_result.job_result_name.to_s.strip
        ]
        sheet.row(row).replace rdata
        (0..2).each {|column| sheet.row(row).set_format(column, format_table_cell)}
        row += 1
      end
      
    end
    
    filename = "สรุปผล#{@employee_type.to_s}_รอบ#{evaluation.episode}_ปี#{evaluation.year}_#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}.xls"
    filename_path = File.join("public", "files", "reports", "employee_types", filename)
    
    book.write filename_path
    send_file filename_path, :type => "application/vnd.ms-excel", :disposition => 'attachment'
    return false
  end
    
  private
    def load_rtf_style
      styles = {}
      styles['LEFT'] = RTF::ParagraphStyle.new
      styles['LEFT'].justification = :ql
      styles['CENTER'] = RTF::ParagraphStyle.new
      styles['CENTER'].justification = :qc
      styles['RIGHT'] = RTF::ParagraphStyle.new
      styles['RIGHT'].justification = :qr
      styles['FULL'] = RTF::ParagraphStyle.new
      styles['FULL'].justification = :qj
      styles['FULL'].first_line_indent = 700
      styles['TAB'] = RTF::ParagraphStyle.new
      styles['TAB'].justification = :ql
      styles['TAB'].left_indent = 700
      styles['DOUBLETAB'] = RTF::ParagraphStyle.new
      styles['DOUBLETAB'].justification = :ql
      styles['DOUBLETAB'].left_indent = 1400
      styles['SIGNLEFT'] = RTF::ParagraphStyle.new
      styles['SIGNLEFT'].justification = :qc
      styles['SIGNLEFT'].right_indent = 2500
      styles['SIGNRIGHT'] = RTF::ParagraphStyle.new
      styles['SIGNRIGHT'].justification = :qc
      styles['SIGNRIGHT'].left_indent = 2500
      
      styles['HEADER'] = RTF::CharacterStyle.new
      styles['HEADER'].font        = RTF::Font.new(RTF::Font::NIL, "TH SarabunPSK")
      styles['HEADER'].bold        = true
      styles['HEADER'].font_size   = 2 * 12
      
      styles['H1'] = RTF::CharacterStyle.new
      styles['H1'].font        = RTF::Font.new(RTF::Font::NIL, "TH SarabunPSK")
      styles['H1'].bold        = true
      styles['H1'].font_size   = 2 * 14
      
      styles['NORMAL'] = RTF::CharacterStyle.new
      styles['NORMAL'].font        = RTF::Font.new(RTF::Font::NIL, "TH SarabunPSK")
      styles['NORMAL'].font_size   = 2 * 14
      
      styles['NORMAL_BOLD'] = RTF::CharacterStyle.new
      styles['NORMAL_BOLD'].font        = RTF::Font.new(RTF::Font::NIL, "TH SarabunPSK")
      styles['NORMAL_BOLD'].bold        = true
      styles['NORMAL_BOLD'].font_size   = 2 * 14
      
      styles['FOOTER'] = RTF::CharacterStyle.new
      styles['FOOTER'].font        = RTF::Font.new(RTF::Font::NIL, "TH SarabunPSK")
      styles['FOOTER'].font_size   = 2 * 12
      
      styles['SPACE'] = RTF::CharacterStyle.new
      styles['SPACE'].font        = RTF::Font.new(RTF::Font::NIL, "TH SarabunPSK")
      styles['SPACE'].font_size   = 2 * 8
      
      return styles
    end
  
    def has_current_evaluation?
      if @current_evaluation.nil?
        @current_evaluation = Evaluation.last
      end
    end
end
