# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200703180427) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "project_id"
    t.integer  "sorting"
    t.text     "name"
    t.date     "from_date"
    t.date     "to_date"
    t.text     "location"
    t.integer  "number_of_participant"
    t.text     "description"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["project_id"], name: "index_activities_on_project_id", using: :btree
  add_index "activities", ["workflow_state_updater_id"], name: "index_activities_on_workflow_state_updater_id", using: :btree

  create_table "activity_files", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "activity_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_files", ["activity_id"], name: "index_activity_files_on_activity_id", using: :btree
  add_index "activity_files", ["workflow_state_updater_id"], name: "index_activity_files_on_workflow_state_updater_id", using: :btree

  create_table "allowance_rates", force: true do |t|
    t.float    "amount"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "sub_budget_type_id"
    t.integer  "budget_type_id"
  end

  create_table "assessment2s", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "user_id"
    t.integer  "evaluation_id"
    t.integer  "committee_id"
    t.string   "role"
    t.integer  "score111"
    t.integer  "score112"
    t.integer  "score113"
    t.integer  "score114"
    t.integer  "score121"
    t.integer  "score122"
    t.integer  "score123"
    t.integer  "score124"
    t.integer  "score211"
    t.integer  "score212"
    t.integer  "score213"
    t.integer  "score214"
    t.integer  "score215"
    t.integer  "score221"
    t.integer  "score222"
    t.integer  "score223"
    t.integer  "score224"
    t.text     "comment1"
    t.text     "comment2"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assessment2s", ["committee_id"], name: "index_assessment2s_on_committee_id", using: :btree
  add_index "assessment2s", ["evaluation_id"], name: "index_assessment2s_on_evaluation_id", using: :btree
  add_index "assessment2s", ["user_id"], name: "index_assessment2s_on_user_id", using: :btree
  add_index "assessment2s", ["workflow_state_updater_id"], name: "index_assessment2s_on_workflow_state_updater_id", using: :btree

  create_table "assessments", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "user_id"
    t.integer  "evaluation_id"
    t.integer  "committee_id"
    t.string   "role"
    t.integer  "score111"
    t.integer  "score112"
    t.integer  "score113"
    t.integer  "score114"
    t.integer  "score211"
    t.integer  "score212"
    t.integer  "score213"
    t.integer  "score214"
    t.integer  "score215"
    t.integer  "score221"
    t.integer  "score222"
    t.integer  "score223"
    t.integer  "score224"
    t.integer  "score225"
    t.integer  "score226"
    t.text     "comment1"
    t.text     "comment2"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assessments", ["committee_id"], name: "index_assessments_on_committee_id", using: :btree
  add_index "assessments", ["evaluation_id"], name: "index_assessments_on_evaluation_id", using: :btree
  add_index "assessments", ["user_id"], name: "index_assessments_on_user_id", using: :btree
  add_index "assessments", ["workflow_state_updater_id"], name: "index_assessments_on_workflow_state_updater_id", using: :btree

  create_table "base_salaries", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "evaluation_id"
    t.integer  "position_level_id"
    t.float    "min_low"
    t.float    "max_low"
    t.float    "base_low"
    t.float    "min_high"
    t.float    "max_high"
    t.float    "base_high"
    t.text     "remark"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "base_salaries", ["evaluation_id"], name: "index_base_salaries_on_evaluation_id", using: :btree
  add_index "base_salaries", ["position_level_id"], name: "index_base_salaries_on_position_level_id", using: :btree
  add_index "base_salaries", ["workflow_state_updater_id"], name: "index_base_salaries_on_workflow_state_updater_id", using: :btree

  create_table "benefits", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "project_id"
    t.integer  "sorting"
    t.text     "description"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "benefits", ["project_id"], name: "index_benefits_on_project_id", using: :btree
  add_index "benefits", ["workflow_state_updater_id"], name: "index_benefits_on_workflow_state_updater_id", using: :btree

  create_table "budget_groups", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.string   "name"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_name"
  end

  add_index "budget_groups", ["workflow_state_updater_id"], name: "index_budget_groups_on_workflow_state_updater_id", using: :btree

  create_table "budget_types", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.string   "name"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "budget_types", ["workflow_state_updater_id"], name: "index_budget_types_on_workflow_state_updater_id", using: :btree

  create_table "budgets", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "project_id"
    t.integer  "sorting"
    t.integer  "budget_type_id"
    t.text     "description"
    t.float    "amount"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "allowance_rate_id"
    t.float    "hr"
    t.integer  "sub_budget_type_id"
    t.integer  "wage_rate_id"
  end

  add_index "budgets", ["budget_type_id"], name: "index_budgets_on_budget_type_id", using: :btree
  add_index "budgets", ["project_id"], name: "index_budgets_on_project_id", using: :btree
  add_index "budgets", ["workflow_state_updater_id"], name: "index_budgets_on_workflow_state_updater_id", using: :btree

  create_table "capacities", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.string   "name"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "capacities", ["workflow_state_updater_id"], name: "index_capacities_on_workflow_state_updater_id", using: :btree

  create_table "committees", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "evaluation_id"
    t.integer  "user_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "committees", ["evaluation_id"], name: "index_committees_on_evaluation_id", using: :btree
  add_index "committees", ["user_id"], name: "index_committees_on_user_id", using: :btree
  add_index "committees", ["workflow_state_updater_id"], name: "index_committees_on_workflow_state_updater_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "e360_item_users", force: true do |t|
    t.integer  "e360_user_id"
    t.integer  "e360_item_id"
    t.integer  "score"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "e360_item_users", ["e360_item_id"], name: "index_e360_item_users_on_e360_item_id", using: :btree
  add_index "e360_item_users", ["e360_user_id"], name: "index_e360_item_users_on_e360_user_id", using: :btree

  create_table "e360_items", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "evaluation_id"
    t.integer  "sorting"
    t.text     "name"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "e360_items", ["evaluation_id"], name: "index_e360_items_on_evaluation_id", using: :btree
  add_index "e360_items", ["workflow_state_updater_id"], name: "index_e360_items_on_workflow_state_updater_id", using: :btree

  create_table "e360_users", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "evaluation_id"
    t.integer  "user_id"
    t.integer  "committee_id"
    t.string   "role"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "e360_users", ["committee_id"], name: "index_e360_users_on_committee_id", using: :btree
  add_index "e360_users", ["evaluation_id"], name: "index_e360_users_on_evaluation_id", using: :btree
  add_index "e360_users", ["user_id"], name: "index_e360_users_on_user_id", using: :btree
  add_index "e360_users", ["workflow_state_updater_id"], name: "index_e360_users_on_workflow_state_updater_id", using: :btree

  create_table "edpex_kku_groups", force: true do |t|
    t.string   "no"
    t.text     "name"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "edpex_kku_items", force: true do |t|
    t.integer  "edpex_kku_id"
    t.string   "no"
    t.text     "name"
    t.float    "target"
    t.float    "year1"
    t.float    "year2"
    t.float    "year3"
    t.float    "year4"
    t.float    "year5"
    t.float    "year"
    t.string   "institute"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "edpex_kku_items", ["edpex_kku_id"], name: "index_edpex_kku_items_on_edpex_kku_id", using: :btree

  create_table "edpex_kkus", force: true do |t|
    t.integer  "year"
    t.integer  "edpex_kku_group_id"
    t.string   "no"
    t.text     "name"
    t.text     "description"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "edpex_kkus", ["edpex_kku_group_id"], name: "index_edpex_kkus_on_edpex_kku_group_id", using: :btree

  create_table "employee_type_task_groups", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "sorting"
    t.integer  "employee_type_id"
    t.string   "name"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_type_user_id"
  end

  add_index "employee_type_task_groups", ["employee_type_id"], name: "index_employee_type_task_groups_on_employee_type_id", using: :btree
  add_index "employee_type_task_groups", ["employee_type_user_id"], name: "index_employee_type_task_groups_on_employee_type_user_id", using: :btree
  add_index "employee_type_task_groups", ["workflow_state_updater_id"], name: "index_employee_type_task_groups_on_workflow_state_updater_id", using: :btree

  create_table "employee_type_task_users", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "employee_type_task_id"
    t.integer  "user_id"
    t.integer  "evaluation_id"
    t.integer  "committee_id"
    t.string   "role"
    t.float    "weight"
    t.integer  "score"
    t.float    "score_real"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employee_type_task_users", ["committee_id"], name: "index_employee_type_task_users_on_committee_id", using: :btree
  add_index "employee_type_task_users", ["employee_type_task_id"], name: "index_employee_type_task_users_on_employee_type_task_id", using: :btree
  add_index "employee_type_task_users", ["evaluation_id"], name: "index_employee_type_task_users_on_evaluation_id", using: :btree
  add_index "employee_type_task_users", ["user_id"], name: "index_employee_type_task_users_on_user_id", using: :btree
  add_index "employee_type_task_users", ["workflow_state_updater_id"], name: "index_employee_type_task_users_on_workflow_state_updater_id", using: :btree

  create_table "employee_type_tasks", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "sorting"
    t.integer  "employee_type_task_group_id"
    t.integer  "task_id"
    t.float    "weight"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "criteria1"
    t.text     "criteria2"
    t.text     "criteria3"
    t.text     "criteria4"
    t.text     "criteria5"
    t.integer  "min_value"
  end

  add_index "employee_type_tasks", ["employee_type_task_group_id"], name: "index_employee_type_tasks_on_employee_type_task_group_id", using: :btree
  add_index "employee_type_tasks", ["task_id"], name: "index_employee_type_tasks_on_task_id", using: :btree
  add_index "employee_type_tasks", ["workflow_state_updater_id"], name: "index_employee_type_tasks_on_workflow_state_updater_id", using: :btree

  create_table "employee_type_users", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "employee_type_id"
    t.integer  "user_id"
    t.integer  "evaluation_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employee_type_users", ["employee_type_id"], name: "index_employee_type_users_on_employee_type_id", using: :btree
  add_index "employee_type_users", ["evaluation_id"], name: "index_employee_type_users_on_evaluation_id", using: :btree
  add_index "employee_type_users", ["user_id"], name: "index_employee_type_users_on_user_id", using: :btree
  add_index "employee_type_users", ["workflow_state_updater_id"], name: "index_employee_type_users_on_workflow_state_updater_id", using: :btree

  create_table "employee_types", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.string   "name"
    t.integer  "sorting"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employee_types", ["workflow_state_updater_id"], name: "index_employee_types_on_workflow_state_updater_id", using: :btree

  create_table "evaluation_employee_types", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "employee_type_id"
    t.integer  "evaluation_id"
    t.float    "leader_ratio"
    t.float    "committee_ratio"
    t.float    "task_ratio"
    t.float    "ability_ratio"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "director_ratio"
    t.float    "vice_director_ratio"
    t.float    "section_leader_ratio"
    t.float    "section_vice_leader_ratio"
    t.float    "vice_director2_ratio"
    t.float    "vice_director3_ratio"
    t.float    "secretary_ratio"
  end

  add_index "evaluation_employee_types", ["employee_type_id"], name: "index_evaluation_employee_types_on_employee_type_id", using: :btree
  add_index "evaluation_employee_types", ["evaluation_id"], name: "index_evaluation_employee_types_on_evaluation_id", using: :btree
  add_index "evaluation_employee_types", ["workflow_state_updater_id"], name: "index_evaluation_employee_types_on_workflow_state_updater_id", using: :btree

  create_table "evaluation_principles", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "evaluation_id"
    t.integer  "task_id"
    t.text     "principle1"
    t.text     "principle2"
    t.text     "principle3"
    t.text     "principle4"
    t.text     "principle5"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "evaluation_principles", ["evaluation_id"], name: "index_evaluation_principles_on_evaluation_id", using: :btree
  add_index "evaluation_principles", ["task_id"], name: "index_evaluation_principles_on_task_id", using: :btree
  add_index "evaluation_principles", ["workflow_state_updater_id"], name: "index_evaluation_principles_on_workflow_state_updater_id", using: :btree

  create_table "evaluation_salary_up_users", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "evaluation_id"
    t.integer  "evaluation_salary_up_id"
    t.integer  "user_id"
    t.integer  "position_level_id"
    t.float    "salary"
    t.float    "base_salary"
    t.float    "base_salary_min"
    t.float    "base_salary_max"
    t.boolean  "is_eligible"
    t.boolean  "is_work_hour_passed"
    t.integer  "lost_count"
    t.integer  "late_count"
    t.float    "leave_count"
    t.float    "point"
    t.float    "percent_of_min_up"
    t.float    "salary_min_up"
    t.float    "percent_of_up"
    t.float    "salary_up"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "avg_point"
    t.float    "extra_money"
    t.text     "remark"
  end

  add_index "evaluation_salary_up_users", ["evaluation_id"], name: "index_evaluation_salary_up_users_on_evaluation_id", using: :btree
  add_index "evaluation_salary_up_users", ["evaluation_salary_up_id"], name: "index_evaluation_salary_up_users_on_evaluation_salary_up_id", using: :btree
  add_index "evaluation_salary_up_users", ["position_level_id"], name: "index_evaluation_salary_up_users_on_position_level_id", using: :btree
  add_index "evaluation_salary_up_users", ["user_id"], name: "index_evaluation_salary_up_users_on_user_id", using: :btree
  add_index "evaluation_salary_up_users", ["workflow_state_updater_id"], name: "index_evaluation_salary_up_users_on_workflow_state_updater_id", using: :btree

  create_table "evaluation_salary_ups", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "evaluation_id"
    t.float    "percent_of_change"
    t.float    "total_amount"
    t.float    "total_eligible_amount"
    t.float    "point_level1"
    t.float    "point_level2"
    t.float    "point_level3"
    t.float    "point_level4"
    t.float    "point_level5"
    t.float    "min_change1"
    t.float    "min_change2"
    t.float    "min_change3"
    t.float    "min_change4"
    t.float    "min_change5"
    t.float    "max_change1"
    t.float    "max_change2"
    t.float    "max_change3"
    t.float    "max_change4"
    t.float    "max_change5"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "evaluation_salary_ups", ["evaluation_id"], name: "index_evaluation_salary_ups_on_evaluation_id", using: :btree
  add_index "evaluation_salary_ups", ["workflow_state_updater_id"], name: "index_evaluation_salary_ups_on_workflow_state_updater_id", using: :btree

  create_table "evaluation_score_cards", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "evaluation_id"
    t.integer  "user_id"
    t.integer  "committee_id"
    t.string   "role"
    t.integer  "task_score"
    t.integer  "ability_score"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment1"
    t.text     "comment2"
  end

  add_index "evaluation_score_cards", ["committee_id"], name: "index_evaluation_score_cards_on_committee_id", using: :btree
  add_index "evaluation_score_cards", ["evaluation_id"], name: "index_evaluation_score_cards_on_evaluation_id", using: :btree
  add_index "evaluation_score_cards", ["user_id"], name: "index_evaluation_score_cards_on_user_id", using: :btree
  add_index "evaluation_score_cards", ["workflow_state_updater_id"], name: "index_evaluation_score_cards_on_workflow_state_updater_id", using: :btree

  create_table "evaluation_user_finals", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "evaluation_id"
    t.integer  "director_id"
    t.integer  "user_id"
    t.datetime "director_at"
    t.datetime "user_at"
    t.float    "final_task_score"
    t.float    "final_ability_score"
    t.float    "leader_task_score"
    t.float    "leader_ability_score"
    t.float    "staff_task_score"
    t.float    "staff_ability_score"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "evaluation_user_finals", ["director_id"], name: "index_evaluation_user_finals_on_director_id", using: :btree
  add_index "evaluation_user_finals", ["evaluation_id"], name: "index_evaluation_user_finals_on_evaluation_id", using: :btree
  add_index "evaluation_user_finals", ["user_id"], name: "index_evaluation_user_finals_on_user_id", using: :btree
  add_index "evaluation_user_finals", ["workflow_state_updater_id"], name: "index_evaluation_user_finals_on_workflow_state_updater_id", using: :btree

  create_table "evaluation_users", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "user_id"
    t.integer  "evaluation_id"
    t.integer  "committee_id"
    t.string   "role"
    t.text     "comment1"
    t.text     "comment2"
    t.float    "position_capacity_total"
    t.float    "employee_type_task_total"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "evaluation_users", ["committee_id"], name: "index_evaluation_users_on_committee_id", using: :btree
  add_index "evaluation_users", ["evaluation_id"], name: "index_evaluation_users_on_evaluation_id", using: :btree
  add_index "evaluation_users", ["user_id"], name: "index_evaluation_users_on_user_id", using: :btree
  add_index "evaluation_users", ["workflow_state_updater_id"], name: "index_evaluation_users_on_workflow_state_updater_id", using: :btree

  create_table "evaluations", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "year"
    t.integer  "episode"
    t.date     "pd_start_date"
    t.date     "pd_end_date"
    t.date     "pf_start_date"
    t.date     "pf_end_date"
    t.date     "confirm_start_date"
    t.date     "confirm_end_date"
    t.date     "evaluation_start_date"
    t.date     "evaluation_end_date"
    t.integer  "director_id"
    t.integer  "vice_director_id"
    t.integer  "secretary_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vice_director2_id"
    t.integer  "vice_director3_id"
    t.date     "query_start_date"
    t.date     "query_end_date"
    t.date     "start_date"
    t.date     "end_date"
    t.date     "director_confirm_start_date"
    t.date     "director_confirm_end_date"
    t.boolean  "is_360"
    t.boolean  "is_salary_up"
    t.integer  "evaluation1_id"
    t.integer  "evaluation2_id"
    t.integer  "evaluation3_id"
    t.integer  "evaluation4_id"
    t.integer  "evaluation5_id"
  end

  add_index "evaluations", ["director_id"], name: "index_evaluations_on_director_id", using: :btree
  add_index "evaluations", ["evaluation1_id"], name: "index_evaluations_on_evaluation1_id", using: :btree
  add_index "evaluations", ["evaluation2_id"], name: "index_evaluations_on_evaluation2_id", using: :btree
  add_index "evaluations", ["evaluation3_id"], name: "index_evaluations_on_evaluation3_id", using: :btree
  add_index "evaluations", ["evaluation4_id"], name: "index_evaluations_on_evaluation4_id", using: :btree
  add_index "evaluations", ["evaluation5_id"], name: "index_evaluations_on_evaluation5_id", using: :btree
  add_index "evaluations", ["secretary_id"], name: "index_evaluations_on_secretary_id", using: :btree
  add_index "evaluations", ["vice_director_id"], name: "index_evaluations_on_vice_director_id", using: :btree
  add_index "evaluations", ["workflow_state_updater_id"], name: "index_evaluations_on_workflow_state_updater_id", using: :btree

  create_table "expenses", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "project_id"
    t.integer  "sorting"
    t.integer  "budget_type_id"
    t.date     "date"
    t.text     "description"
    t.float    "amount"
    t.string   "by"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "budget_group_id"
    t.integer  "allowance_rate_id"
    t.float    "hr"
    t.integer  "sub_budget_type_id"
    t.integer  "wage_rate_id"
  end

  add_index "expenses", ["budget_group_id"], name: "index_expenses_on_budget_group_id", using: :btree
  add_index "expenses", ["budget_type_id"], name: "index_expenses_on_budget_type_id", using: :btree
  add_index "expenses", ["project_id"], name: "index_expenses_on_project_id", using: :btree
  add_index "expenses", ["workflow_state_updater_id"], name: "index_expenses_on_workflow_state_updater_id", using: :btree

  create_table "faculties", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.string   "name"
    t.integer  "dean_id"
    t.integer  "leader_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "faculties", ["dean_id"], name: "index_faculties_on_dean_id", using: :btree
  add_index "faculties", ["leader_id"], name: "index_faculties_on_leader_id", using: :btree
  add_index "faculties", ["workflow_state_updater_id"], name: "index_faculties_on_workflow_state_updater_id", using: :btree

  create_table "faculty_users", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "faculty_id"
    t.integer  "user_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "faculty_users", ["faculty_id"], name: "index_faculty_users_on_faculty_id", using: :btree
  add_index "faculty_users", ["user_id"], name: "index_faculty_users_on_user_id", using: :btree
  add_index "faculty_users", ["workflow_state_updater_id"], name: "index_faculty_users_on_workflow_state_updater_id", using: :btree

  create_table "indicators", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "project_id"
    t.integer  "sorting"
    t.text     "description"
    t.float    "target"
    t.float    "result1"
    t.float    "result2"
    t.float    "result3"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unit"
  end

  add_index "indicators", ["project_id"], name: "index_indicators_on_project_id", using: :btree
  add_index "indicators", ["workflow_state_updater_id"], name: "index_indicators_on_workflow_state_updater_id", using: :btree

  create_table "job_development_files", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "job_development_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.text     "description"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_development_files", ["job_development_id"], name: "index_job_development_files_on_job_development_id", using: :btree
  add_index "job_development_files", ["workflow_state_updater_id"], name: "index_job_development_files_on_workflow_state_updater_id", using: :btree

  create_table "job_development_logs", force: true do |t|
    t.integer  "job_development_id"
    t.text     "name"
    t.integer  "expect"
    t.float    "weight"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_development_logs", ["job_development_id"], name: "index_job_development_logs_on_job_development_id", using: :btree

  create_table "job_development_result_files", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "job_development_result_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.text     "description"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_development_result_files", ["job_development_result_id"], name: "index_job_development_result_files_on_job_development_result_id", using: :btree
  add_index "job_development_result_files", ["workflow_state_updater_id"], name: "index_job_development_result_files_on_workflow_state_updater_id", using: :btree

  create_table "job_development_results", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "user_id"
    t.integer  "evaluation_id"
    t.integer  "job_development_id"
    t.integer  "job_result_template_id"
    t.text     "name"
    t.integer  "duration"
    t.float    "expect_qty"
    t.float    "qty"
    t.string   "unit"
    t.text     "description"
    t.integer  "approver_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_development_results", ["approver_id"], name: "index_job_development_results_on_approver_id", using: :btree
  add_index "job_development_results", ["evaluation_id"], name: "index_job_development_results_on_evaluation_id", using: :btree
  add_index "job_development_results", ["job_development_id"], name: "index_job_development_results_on_job_development_id", using: :btree
  add_index "job_development_results", ["job_result_template_id"], name: "index_job_development_results_on_job_result_template_id", using: :btree
  add_index "job_development_results", ["user_id"], name: "index_job_development_results_on_user_id", using: :btree
  add_index "job_development_results", ["workflow_state_updater_id"], name: "index_job_development_results_on_workflow_state_updater_id", using: :btree

  create_table "job_developments", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "user_id"
    t.integer  "evaluation_id"
    t.integer  "job_template_id"
    t.text     "name"
    t.integer  "duration"
    t.float    "expect_qty"
    t.float    "qty"
    t.string   "unit"
    t.text     "description"
    t.integer  "approver_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "weight"
    t.integer  "expect"
    t.integer  "self_point"
  end

  add_index "job_developments", ["approver_id"], name: "index_job_developments_on_approver_id", using: :btree
  add_index "job_developments", ["evaluation_id"], name: "index_job_developments_on_evaluation_id", using: :btree
  add_index "job_developments", ["job_template_id"], name: "index_job_developments_on_job_template_id", using: :btree
  add_index "job_developments", ["user_id"], name: "index_job_developments_on_user_id", using: :btree
  add_index "job_developments", ["workflow_state_updater_id"], name: "index_job_developments_on_workflow_state_updater_id", using: :btree

  create_table "job_plan_files", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "job_plan_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.text     "description"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_plan_files", ["job_plan_id"], name: "index_job_plan_files_on_job_plan_id", using: :btree
  add_index "job_plan_files", ["workflow_state_updater_id"], name: "index_job_plan_files_on_workflow_state_updater_id", using: :btree

  create_table "job_plan_logs", force: true do |t|
    t.integer  "job_plan_id"
    t.text     "name"
    t.integer  "expect"
    t.float    "weight"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_plan_logs", ["job_plan_id"], name: "index_job_plan_logs_on_job_plan_id", using: :btree

  create_table "job_plan_result_files", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "job_plan_result_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.text     "description"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_plan_result_files", ["job_plan_result_id"], name: "index_job_plan_result_files_on_job_plan_result_id", using: :btree
  add_index "job_plan_result_files", ["workflow_state_updater_id"], name: "index_job_plan_result_files_on_workflow_state_updater_id", using: :btree

  create_table "job_plan_results", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "user_id"
    t.integer  "evaluation_id"
    t.integer  "job_plan_id"
    t.integer  "job_result_template_id"
    t.text     "name"
    t.integer  "duration"
    t.float    "expect_qty"
    t.float    "qty"
    t.string   "unit"
    t.text     "description"
    t.integer  "approver_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_plan_results", ["approver_id"], name: "index_job_plan_results_on_approver_id", using: :btree
  add_index "job_plan_results", ["evaluation_id"], name: "index_job_plan_results_on_evaluation_id", using: :btree
  add_index "job_plan_results", ["job_plan_id"], name: "index_job_plan_results_on_job_plan_id", using: :btree
  add_index "job_plan_results", ["job_result_template_id"], name: "index_job_plan_results_on_job_result_template_id", using: :btree
  add_index "job_plan_results", ["user_id"], name: "index_job_plan_results_on_user_id", using: :btree
  add_index "job_plan_results", ["workflow_state_updater_id"], name: "index_job_plan_results_on_workflow_state_updater_id", using: :btree

  create_table "job_plans", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "user_id"
    t.integer  "evaluation_id"
    t.integer  "job_template_id"
    t.text     "name"
    t.integer  "duration"
    t.float    "expect_qty"
    t.float    "qty"
    t.string   "unit"
    t.text     "description"
    t.integer  "approver_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "weight"
    t.integer  "expect"
    t.integer  "self_point"
  end

  add_index "job_plans", ["approver_id"], name: "index_job_plans_on_approver_id", using: :btree
  add_index "job_plans", ["evaluation_id"], name: "index_job_plans_on_evaluation_id", using: :btree
  add_index "job_plans", ["job_template_id"], name: "index_job_plans_on_job_template_id", using: :btree
  add_index "job_plans", ["user_id"], name: "index_job_plans_on_user_id", using: :btree
  add_index "job_plans", ["workflow_state_updater_id"], name: "index_job_plans_on_workflow_state_updater_id", using: :btree

  create_table "job_result_templates", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "job_template_id"
    t.text     "name"
    t.string   "unit"
    t.integer  "duration"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_result_templates", ["job_template_id"], name: "index_job_result_templates_on_job_template_id", using: :btree
  add_index "job_result_templates", ["workflow_state_updater_id"], name: "index_job_result_templates_on_workflow_state_updater_id", using: :btree

  create_table "job_routine_files", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "job_routine_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.text     "description"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_routine_files", ["job_routine_id"], name: "index_job_routine_files_on_job_routine_id", using: :btree
  add_index "job_routine_files", ["workflow_state_updater_id"], name: "index_job_routine_files_on_workflow_state_updater_id", using: :btree

  create_table "job_routine_logs", force: true do |t|
    t.integer  "job_routine_id"
    t.text     "name"
    t.integer  "expect"
    t.float    "weight"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_routine_logs", ["job_routine_id"], name: "index_job_routine_logs_on_job_routine_id", using: :btree

  create_table "job_routine_result_files", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "job_routine_result_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.text     "description"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_routine_result_files", ["job_routine_result_id"], name: "index_job_routine_result_files_on_job_routine_result_id", using: :btree
  add_index "job_routine_result_files", ["workflow_state_updater_id"], name: "index_job_routine_result_files_on_workflow_state_updater_id", using: :btree

  create_table "job_routine_results", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "user_id"
    t.integer  "evaluation_id"
    t.integer  "job_routine_id"
    t.integer  "job_result_template_id"
    t.text     "name"
    t.integer  "duration"
    t.float    "expect_qty"
    t.float    "qty"
    t.string   "unit"
    t.text     "description"
    t.integer  "approver_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_routine_results", ["approver_id"], name: "index_job_routine_results_on_approver_id", using: :btree
  add_index "job_routine_results", ["evaluation_id"], name: "index_job_routine_results_on_evaluation_id", using: :btree
  add_index "job_routine_results", ["job_result_template_id"], name: "index_job_routine_results_on_job_result_template_id", using: :btree
  add_index "job_routine_results", ["job_routine_id"], name: "index_job_routine_results_on_job_routine_id", using: :btree
  add_index "job_routine_results", ["user_id"], name: "index_job_routine_results_on_user_id", using: :btree
  add_index "job_routine_results", ["workflow_state_updater_id"], name: "index_job_routine_results_on_workflow_state_updater_id", using: :btree

  create_table "job_routines", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "user_id"
    t.integer  "evaluation_id"
    t.integer  "job_template_id"
    t.text     "name"
    t.integer  "duration"
    t.float    "expect_qty"
    t.float    "qty"
    t.string   "unit"
    t.text     "description"
    t.integer  "approver_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "weight"
    t.integer  "expect"
    t.integer  "self_point"
  end

  add_index "job_routines", ["approver_id"], name: "index_job_routines_on_approver_id", using: :btree
  add_index "job_routines", ["evaluation_id"], name: "index_job_routines_on_evaluation_id", using: :btree
  add_index "job_routines", ["job_template_id"], name: "index_job_routines_on_job_template_id", using: :btree
  add_index "job_routines", ["user_id"], name: "index_job_routines_on_user_id", using: :btree
  add_index "job_routines", ["workflow_state_updater_id"], name: "index_job_routines_on_workflow_state_updater_id", using: :btree

  create_table "job_template_groups", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.text     "name"
    t.integer  "sorting"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_template_groups", ["workflow_state_updater_id"], name: "index_job_template_groups_on_workflow_state_updater_id", using: :btree

  create_table "job_templates", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "job_template_group_id"
    t.text     "name"
    t.string   "unit"
    t.integer  "duration"
    t.boolean  "is_job_routine"
    t.boolean  "is_job_vice"
    t.boolean  "is_job_development"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_job_plan"
  end

  add_index "job_templates", ["job_template_group_id"], name: "index_job_templates_on_job_template_group_id", using: :btree
  add_index "job_templates", ["workflow_state_updater_id"], name: "index_job_templates_on_workflow_state_updater_id", using: :btree

  create_table "job_vice_files", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "job_vice_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.text     "description"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_vice_files", ["job_vice_id"], name: "index_job_vice_files_on_job_vice_id", using: :btree
  add_index "job_vice_files", ["workflow_state_updater_id"], name: "index_job_vice_files_on_workflow_state_updater_id", using: :btree

  create_table "job_vice_logs", force: true do |t|
    t.integer  "job_vice_id"
    t.text     "name"
    t.integer  "expect"
    t.float    "weight"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_vice_logs", ["job_vice_id"], name: "index_job_vice_logs_on_job_vice_id", using: :btree

  create_table "job_vice_result_files", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "job_vice_result_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.text     "description"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_vice_result_files", ["job_vice_result_id"], name: "index_job_vice_result_files_on_job_vice_result_id", using: :btree
  add_index "job_vice_result_files", ["workflow_state_updater_id"], name: "index_job_vice_result_files_on_workflow_state_updater_id", using: :btree

  create_table "job_vice_results", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "user_id"
    t.integer  "evaluation_id"
    t.integer  "job_vice_id"
    t.integer  "job_result_template_id"
    t.text     "name"
    t.integer  "duration"
    t.float    "expect_qty"
    t.float    "qty"
    t.string   "unit"
    t.text     "description"
    t.integer  "approver_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_vice_results", ["approver_id"], name: "index_job_vice_results_on_approver_id", using: :btree
  add_index "job_vice_results", ["evaluation_id"], name: "index_job_vice_results_on_evaluation_id", using: :btree
  add_index "job_vice_results", ["job_result_template_id"], name: "index_job_vice_results_on_job_result_template_id", using: :btree
  add_index "job_vice_results", ["job_vice_id"], name: "index_job_vice_results_on_job_vice_id", using: :btree
  add_index "job_vice_results", ["user_id"], name: "index_job_vice_results_on_user_id", using: :btree
  add_index "job_vice_results", ["workflow_state_updater_id"], name: "index_job_vice_results_on_workflow_state_updater_id", using: :btree

  create_table "job_vices", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "user_id"
    t.integer  "evaluation_id"
    t.integer  "job_template_id"
    t.text     "name"
    t.integer  "duration"
    t.float    "expect_qty"
    t.float    "qty"
    t.string   "unit"
    t.text     "description"
    t.integer  "approver_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "weight"
    t.integer  "expect"
    t.integer  "self_point"
  end

  add_index "job_vices", ["approver_id"], name: "index_job_vices_on_approver_id", using: :btree
  add_index "job_vices", ["evaluation_id"], name: "index_job_vices_on_evaluation_id", using: :btree
  add_index "job_vices", ["job_template_id"], name: "index_job_vices_on_job_template_id", using: :btree
  add_index "job_vices", ["user_id"], name: "index_job_vices_on_user_id", using: :btree
  add_index "job_vices", ["workflow_state_updater_id"], name: "index_job_vices_on_workflow_state_updater_id", using: :btree

  create_table "kku_strategic_pillars", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "no"
    t.string   "name"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kku_strategic_pillars", ["workflow_state_updater_id"], name: "index_kku_strategic_pillars_on_workflow_state_updater_id", using: :btree

  create_table "kku_strategics", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "kku_strategic_pillar_id"
    t.integer  "no"
    t.string   "name"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kku_strategics", ["kku_strategic_pillar_id"], name: "index_kku_strategics_on_kku_strategic_pillar_id", using: :btree
  add_index "kku_strategics", ["workflow_state_updater_id"], name: "index_kku_strategics_on_workflow_state_updater_id", using: :btree

  create_table "kku_tactics", force: true do |t|
    t.string   "name",                      limit: nil
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "kku_strategic_id"
    t.integer  "no"
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
  end

  create_table "measures", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "tactic_id"
    t.integer  "no"
    t.string   "name"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measures", ["tactic_id"], name: "index_measures_on_tactic_id", using: :btree
  add_index "measures", ["workflow_state_updater_id"], name: "index_measures_on_workflow_state_updater_id", using: :btree

  create_table "message_receivers", force: true do |t|
    t.integer  "message_id"
    t.integer  "user_id"
    t.string   "receiver_type"
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_receivers", ["message_id"], name: "index_message_receivers_on_message_id", using: :btree
  add_index "message_receivers", ["user_id"], name: "index_message_receivers_on_user_id", using: :btree
  add_index "message_receivers", ["workflow_state_updater_id"], name: "index_message_receivers_on_workflow_state_updater_id", using: :btree

  create_table "messages", force: true do |t|
    t.integer  "message_id"
    t.integer  "user_id"
    t.text     "topic"
    t.text     "body"
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["message_id"], name: "index_messages_on_message_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree
  add_index "messages", ["workflow_state_updater_id"], name: "index_messages_on_workflow_state_updater_id", using: :btree

  create_table "news_calendars", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.text     "title"
    t.text     "detail"
    t.datetime "published_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news_calendars", ["workflow_state_updater_id"], name: "index_news_calendars_on_workflow_state_updater_id", using: :btree

  create_table "news_fronts", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.text     "title"
    t.text     "detail"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "published_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news_fronts", ["workflow_state_updater_id"], name: "index_news_fronts_on_workflow_state_updater_id", using: :btree

  create_table "news_images", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "published_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news_images", ["workflow_state_updater_id"], name: "index_news_images_on_workflow_state_updater_id", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.text     "description"
    t.string   "priority"
    t.string   "resource_class"
    t.integer  "resource_id"
    t.text     "url"
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["resource_id"], name: "index_notifications_on_resource_id", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree
  add_index "notifications", ["workflow_state_updater_id"], name: "index_notifications_on_workflow_state_updater_id", using: :btree

  create_table "objectives", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "project_id"
    t.integer  "sorting"
    t.text     "description"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "objectives", ["project_id"], name: "index_objectives_on_project_id", using: :btree
  add_index "objectives", ["workflow_state_updater_id"], name: "index_objectives_on_workflow_state_updater_id", using: :btree

  create_table "policies", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "policy_id"
    t.string   "code"
    t.text     "name"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "policies", ["policy_id"], name: "index_policies_on_policy_id", using: :btree
  add_index "policies", ["workflow_state_updater_id"], name: "index_policies_on_workflow_state_updater_id", using: :btree

  create_table "position_capacities", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "sorting"
    t.integer  "position_capacity_group_id"
    t.integer  "capacity_id"
    t.float    "weight"
    t.float    "expect"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "position_capacities", ["capacity_id"], name: "index_position_capacities_on_capacity_id", using: :btree
  add_index "position_capacities", ["position_capacity_group_id"], name: "index_position_capacities_on_position_capacity_group_id", using: :btree
  add_index "position_capacities", ["workflow_state_updater_id"], name: "index_position_capacities_on_workflow_state_updater_id", using: :btree

  create_table "position_capacity_groups", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "sorting"
    t.integer  "position_id"
    t.string   "name"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "position_capacity_groups", ["position_id"], name: "index_position_capacity_groups_on_position_id", using: :btree
  add_index "position_capacity_groups", ["workflow_state_updater_id"], name: "index_position_capacity_groups_on_workflow_state_updater_id", using: :btree

  create_table "position_capacity_users", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "position_capacity_id"
    t.integer  "user_id"
    t.integer  "evaluation_id"
    t.integer  "committee_id"
    t.string   "role"
    t.float    "expect"
    t.float    "weight"
    t.integer  "score"
    t.float    "score_real_expect"
    t.float    "score_real_100"
    t.float    "score_weight"
    t.float    "score_real"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "position_capacity_users", ["committee_id"], name: "index_position_capacity_users_on_committee_id", using: :btree
  add_index "position_capacity_users", ["evaluation_id"], name: "index_position_capacity_users_on_evaluation_id", using: :btree
  add_index "position_capacity_users", ["position_capacity_id"], name: "index_position_capacity_users_on_position_capacity_id", using: :btree
  add_index "position_capacity_users", ["user_id"], name: "index_position_capacity_users_on_user_id", using: :btree
  add_index "position_capacity_users", ["workflow_state_updater_id"], name: "index_position_capacity_users_on_workflow_state_updater_id", using: :btree

  create_table "position_levels", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.string   "name"
    t.integer  "sorting"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "position_levels", ["workflow_state_updater_id"], name: "index_position_levels_on_workflow_state_updater_id", using: :btree

  create_table "position_types", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.string   "name"
    t.integer  "sorting"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "position_types", ["workflow_state_updater_id"], name: "index_position_types_on_workflow_state_updater_id", using: :btree

  create_table "positions", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.string   "name"
    t.integer  "position_type_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position_level_id"
  end

  add_index "positions", ["position_level_id"], name: "index_positions_on_position_level_id", using: :btree
  add_index "positions", ["position_type_id"], name: "index_positions_on_position_type_id", using: :btree
  add_index "positions", ["workflow_state_updater_id"], name: "index_positions_on_workflow_state_updater_id", using: :btree

  create_table "problem_suggesstions", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "project_id"
    t.integer  "sorting"
    t.text     "description"
    t.text     "next_step"
    t.integer  "percent_of_task",           default: 0, null: false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "problem_suggesstions", ["project_id"], name: "index_problem_suggesstions_on_project_id", using: :btree
  add_index "problem_suggesstions", ["workflow_state_updater_id"], name: "index_problem_suggesstions_on_workflow_state_updater_id", using: :btree

  create_table "project_images", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "project_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_images", ["project_id"], name: "index_project_images_on_project_id", using: :btree
  add_index "project_images", ["workflow_state_updater_id"], name: "index_project_images_on_workflow_state_updater_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "project_id"
    t.string   "code"
    t.text     "name"
    t.integer  "policy_id"
    t.text     "rationale"
    t.text     "objective"
    t.date     "from_date"
    t.date     "to_date"
    t.float    "budget_amount"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "budget_plan_q1"
    t.float    "budget_plan_q2"
    t.float    "budget_plan_q3"
    t.float    "budget_plan_q4"
    t.integer  "budget_group_id"
    t.integer  "strategy_id"
    t.integer  "tactic_id"
    t.integer  "year"
    t.integer  "kku_strategic_pillar_id"
    t.integer  "kku_strategic_id"
    t.integer  "strategy_group_id"
    t.integer  "measure_id"
    t.boolean  "is_started",                default: false
    t.integer  "kku_tactic_id"
  end

  add_index "projects", ["budget_group_id"], name: "index_projects_on_budget_group_id", using: :btree
  add_index "projects", ["kku_strategic_id"], name: "index_projects_on_kku_strategic_id", using: :btree
  add_index "projects", ["kku_strategic_pillar_id"], name: "index_projects_on_kku_strategic_pillar_id", using: :btree
  add_index "projects", ["measure_id"], name: "index_projects_on_measure_id", using: :btree
  add_index "projects", ["policy_id"], name: "index_projects_on_policy_id", using: :btree
  add_index "projects", ["project_id"], name: "index_projects_on_project_id", using: :btree
  add_index "projects", ["strategy_group_id"], name: "index_projects_on_strategy_group_id", using: :btree
  add_index "projects", ["strategy_id"], name: "index_projects_on_strategy_id", using: :btree
  add_index "projects", ["tactic_id"], name: "index_projects_on_tactic_id", using: :btree
  add_index "projects", ["workflow_state_updater_id"], name: "index_projects_on_workflow_state_updater_id", using: :btree

  create_table "responsibles", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "project_id"
    t.integer  "sorting"
    t.integer  "user_id"
    t.string   "prefix"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "position"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "responsibility"
    t.integer  "percent_of_work",           default: 0
  end

  add_index "responsibles", ["project_id"], name: "index_responsibles_on_project_id", using: :btree
  add_index "responsibles", ["user_id"], name: "index_responsibles_on_user_id", using: :btree
  add_index "responsibles", ["workflow_state_updater_id"], name: "index_responsibles_on_workflow_state_updater_id", using: :btree

  create_table "running_numbers", force: true do |t|
    t.string   "prefix"
    t.integer  "year"
    t.integer  "mon"
    t.integer  "day"
    t.integer  "last_number"
    t.string   "suffix"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "section_users", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "section_id"
    t.integer  "user_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "section_users", ["section_id"], name: "index_section_users_on_section_id", using: :btree
  add_index "section_users", ["user_id"], name: "index_section_users_on_user_id", using: :btree
  add_index "section_users", ["workflow_state_updater_id"], name: "index_section_users_on_workflow_state_updater_id", using: :btree

  create_table "sections", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.string   "name"
    t.integer  "leader_id"
    t.integer  "vice_leader_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vice_director_id"
    t.integer  "vice_director2_id"
    t.integer  "vice_director3_id"
  end

  add_index "sections", ["leader_id"], name: "index_sections_on_leader_id", using: :btree
  add_index "sections", ["vice_director2_id"], name: "index_sections_on_vice_director2_id", using: :btree
  add_index "sections", ["vice_director3_id"], name: "index_sections_on_vice_director3_id", using: :btree
  add_index "sections", ["vice_director_id"], name: "index_sections_on_vice_director_id", using: :btree
  add_index "sections", ["vice_leader_id"], name: "index_sections_on_vice_leader_id", using: :btree
  add_index "sections", ["workflow_state_updater_id"], name: "index_sections_on_workflow_state_updater_id", using: :btree

  create_table "strategies", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "sorting"
    t.text     "name"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year"
    t.integer  "strategy_group_id"
  end

  add_index "strategies", ["strategy_group_id"], name: "index_strategies_on_strategy_group_id", using: :btree
  add_index "strategies", ["workflow_state_updater_id"], name: "index_strategies_on_workflow_state_updater_id", using: :btree

  create_table "strategy_groups", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "no"
    t.string   "name"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "strategy_groups", ["workflow_state_updater_id"], name: "index_strategy_groups_on_workflow_state_updater_id", using: :btree

  create_table "sub_budget_types", force: true do |t|
    t.string   "name",                      limit: nil
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "budget_type_id"
    t.string   "workflow_state_updater_id"
    t.string   "workflow_state"
    t.integer  "no"
  end

  create_table "tactics", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "sorting"
    t.integer  "strategy_id"
    t.text     "name"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tactics", ["strategy_id"], name: "index_tactics_on_strategy_id", using: :btree
  add_index "tactics", ["workflow_state_updater_id"], name: "index_tactics_on_workflow_state_updater_id", using: :btree

  create_table "tasks", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "sorting"
    t.string   "name"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "principle1"
    t.text     "principle2"
    t.text     "principle3"
    t.text     "principle4"
    t.text     "principle5"
  end

  add_index "tasks", ["workflow_state_updater_id"], name: "index_tasks_on_workflow_state_updater_id", using: :btree

  create_table "team_users", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "team_id"
    t.integer  "user_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_users", ["team_id"], name: "index_team_users_on_team_id", using: :btree
  add_index "team_users", ["user_id"], name: "index_team_users_on_user_id", using: :btree
  add_index "team_users", ["workflow_state_updater_id"], name: "index_team_users_on_workflow_state_updater_id", using: :btree

  create_table "teams", force: true do |t|
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.string   "name"
    t.integer  "leader_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["leader_id"], name: "index_teams_on_leader_id", using: :btree
  add_index "teams", ["workflow_state_updater_id"], name: "index_teams_on_workflow_state_updater_id", using: :btree

  create_table "ticket_attachments", force: true do |t|
    t.integer  "ticket_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ticket_attachments", ["ticket_id"], name: "index_ticket_attachments_on_ticket_id", using: :btree

  create_table "ticket_comment_attachments", force: true do |t|
    t.integer  "ticket_comment_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ticket_comment_attachments", ["ticket_comment_id"], name: "index_ticket_comment_attachments_on_ticket_comment_id", using: :btree

  create_table "ticket_comments", force: true do |t|
    t.integer  "ticket_id"
    t.text     "description"
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ticket_comments", ["ticket_id"], name: "index_ticket_comments_on_ticket_id", using: :btree
  add_index "ticket_comments", ["workflow_state_updater_id"], name: "index_ticket_comments_on_workflow_state_updater_id", using: :btree

  create_table "tickets", force: true do |t|
    t.string   "no"
    t.string   "name"
    t.text     "description"
    t.string   "priority"
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tickets", ["workflow_state_updater_id"], name: "index_tickets_on_workflow_state_updater_id", using: :btree

  create_table "tickets_users", force: true do |t|
    t.integer "ticket_id"
    t.integer "user_id"
  end

  add_index "tickets_users", ["ticket_id"], name: "index_tickets_users_on_ticket_id", using: :btree
  add_index "tickets_users", ["user_id"], name: "index_tickets_users_on_user_id", using: :btree

  create_table "user_access_logs", force: true do |t|
    t.integer  "user_id"
    t.string   "username"
    t.string   "ip"
    t.string   "controller_name"
    t.string   "action_name"
    t.text     "params"
    t.integer  "params_id"
    t.datetime "log_time"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_access_logs", ["user_id"], name: "index_user_access_logs_on_user_id", using: :btree

  create_table "user_groups", force: true do |t|
    t.string   "name"
    t.integer  "roles_mask"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username",                  default: "", null: false
    t.string   "pid"
    t.string   "prefix"
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "position_id"
    t.integer  "employee_type_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "email",                     default: "", null: false
    t.string   "encrypted_password",        default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",           default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.integer  "roles_mask"
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
    t.string   "locale"
    t.string   "timezone"
    t.string   "theme"
    t.integer  "user_group_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ldap_dn"
    t.string   "ldap_base"
    t.boolean  "is_except_evaluation"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "wage_rates", force: true do |t|
    t.float    "amount"
    t.integer  "no"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "sub_budget_type_id"
    t.string   "workflow_state"
    t.integer  "workflow_state_updater_id"
  end

  create_table "workflow_state_logs", force: true do |t|
    t.string   "resource_class"
    t.integer  "resource_id"
    t.string   "state_from"
    t.string   "state_to"
    t.string   "event"
    t.text     "serialized_object"
    t.text     "description"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
