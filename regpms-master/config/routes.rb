Rails.application.routes.draw do
  
  resources :edpex_kku_items

  resources :edpex_kkus

  resources :edpex_kku_groups

  namespace :settings do
    resources :strategy_groups
  end

  namespace :settings do
    resources :kku_strategics
    resources :kku_strategic_pillars
  end

  get '/salary/setting' => 'assess#salary_setting', as: :salary_setting_assess
  post '/salary/setting/save' => 'assess#save_salary_setting', as: :save_salary_setting_assess
  
  get '/salary/calculator/:role' => 'assess#salary_calculator', as: :salary_calculator_assess
  post '/salary/calculator/:role/save' => 'assess#save_salary_calculator', as: :save_salary_calculator_assess
  
  resources :evaluation_salary_up_users
  resources :evaluation_salary_ups

  namespace :settings do
    resources :base_salaries
  end

  get '/cards/summary(/:role)' => 'assess#cards_summary', as: :cards_summary_assess
  post '/cards/summary(/:role)/save' => 'assess#save_cards_summary', as: :save_cards_summary_assess
  get '/cards/assess(/:role)' => 'assess#cards', as: :cards_assess
  post '/cards/assess/:role/save' => 'assess#save_cards', as: :save_cards_assess
  
  resources :evaluation_score_cards

  get '/director/confirm/:evaluation_id' => 'director_confirms#index', as: :director_confirms
  get '/director/confirm/:evaluation_id/:user_id' => 'director_confirms#pd', as: :pd_director_confirms
  post '/director/confirm/:evaluation_id/:user_id/confirm' => 'director_confirms#confirm', as: :confirm_director_confirms
  
  post '/director/confirm/:evaluation_id/:user_id/add_job_plan' => 'director_confirms#add_job_plan', as: :add_job_plan_director_confirms
  get '/director/confirm/:evaluation_id/:user_id/edit_job_plan' => 'director_confirms#edit_job_plan', as: :edit_job_plan_director_confirms
  post '/director/confirm/:evaluation_id/:user_id/update_job_plan' => 'director_confirms#update_job_plan', as: :update_job_plan_director_confirms
  post '/director/confirm/:evaluation_id/:user_id/remove_job_plan' => 'director_confirms#remove_job_plan', as: :remove_job_plan_director_confirms
  post '/director/confirm/:evaluation_id/:user_id/chose_job_template_group_job_plan' => 'director_confirms#chose_job_template_group_job_plan', as: :chose_job_template_group_job_plan_director_confirms
  
  post '/director/confirm/:evaluation_id/:user_id/add_job_routine' => 'director_confirms#add_job_routine', as: :add_job_routine_director_confirms
  get '/director/confirm/:evaluation_id/:user_id/edit_job_routine' => 'director_confirms#edit_job_routine', as: :edit_job_routine_director_confirms
  post '/director/confirm/:evaluation_id/:user_id/update_job_routine' => 'director_confirms#update_job_routine', as: :update_job_routine_director_confirms
  post '/director/confirm/:evaluation_id/:user_id/remove_job_routine' => 'director_confirms#remove_job_routine', as: :remove_job_routine_director_confirms
  post '/director/confirm/:evaluation_id/:user_id/chose_job_template_group_job_routine' => 'director_confirms#chose_job_template_group_job_routine', as: :chose_job_template_group_job_routine_director_confirms
  
  post '/director/confirm/:evaluation_id/:user_id/add_job_vice' => 'director_confirms#add_job_vice', as: :add_job_vice_director_confirms
  get '/director/confirm/:evaluation_id/:user_id/edit_job_vice' => 'director_confirms#edit_job_vice', as: :edit_job_vice_director_confirms
  post '/director/confirm/:evaluation_id/:user_id/update_job_vice' => 'director_confirms#update_job_vice', as: :update_job_vice_director_confirms
  post '/director/confirm/:evaluation_id/:user_id/remove_job_vice' => 'director_confirms#remove_job_vice', as: :remove_job_vice_director_confirms
  post '/director/confirm/:evaluation_id/:user_id/chose_job_template_group_job_vice' => 'director_confirms#chose_job_template_group_job_vice', as: :chose_job_template_group_job_vice_director_confirms
  
  post '/director/confirm/:evaluation_id/:user_id/add_job_development' => 'director_confirms#add_job_development', as: :add_job_development_director_confirms
  get '/director/confirm/:evaluation_id/:user_id/edit_job_development' => 'director_confirms#edit_job_development', as: :edit_job_development_director_confirms
  post '/director/confirm/:evaluation_id/:user_id/update_job_development' => 'director_confirms#update_job_development', as: :update_job_development_director_confirms
  post '/director/confirm/:evaluation_id/:user_id/remove_job_development' => 'director_confirms#remove_job_development', as: :remove_job_development_director_confirms
  post '/director/confirm/:evaluation_id/:user_id/chose_job_template_group_job_development' => 'director_confirms#chose_job_template_group_job_development', as: :chose_job_template_group_job_development_director_confirms
    

  resources :e360_item_users

  resources :e360_users

  namespace :settings do
    resources :e360_items
    resources :measures do
      post :chose_strategy_group, on: :collection
      post :chose_strategy, on: :collection
    end
    resources :tactics do
      post :chose_strategy_group, on: :collection
    end
    resources :strategies
    resources :evaluation_principles
    resources :position_levels
    resources :employee_type_users
  end

  namespace :projects do
    
    resources :activity_files
    resources :objectives
    resources :project_images
    resources :problem_suggesstions
    resources :activities do
      get :export, on: :collection
    end
    resources :indicators
    resources :benefits
    resources :expenses do
      post :chose_project, on: :collection
      get :import, on: :collection
      post :import_save, on: :collection
    end
    resources :budgets
    resources :responsibles do
      post :chose_user, on: :collection
    end
  end

  resources :projects do
    post :chose_strategy_group, on: :collection
    post :chose_strategy, on: :collection
    post :chose_tactic, on: :collection
    post :chose_kku_strategic_pillar, on: :collection
    
    put :start_project, on: :member
    put :cancel_start_project, on: :member
  end

  resources :evaluation_users

  resources :employee_type_task_users

  resources :position_capacity_users

  namespace :settings do
    resources :budget_types
    resources :policies
    resources :budget_groups
    resources :job_result_templates
    resources :employee_type_tasks
    resources :employee_type_task_groups
    resources :tasks
    resources :position_capacity_groups
    resources :position_capacities
    resources :capacities
    resources :positions
    resources :position_types
    resources :team_users
    resources :teams
    resources :faculty_users
    resources :faculties
    resources :section_users
    resources :sections
    resources :evaluation_employee_types
    resources :employee_types
    resources :committees
    resources :evaluations
  end

  concern :destroy_with_ids do
    delete :index, on: :collection, action: :destroy
  end

  resources :assessment2s, concerns: :destroy_with_ids do 
    post :chose_user, on: :collection
  end

  resources :assessments, concerns: :destroy_with_ids do 
    post :chose_user, on: :collection
  end

  namespace :jobs do
    
    resources :job_development_result_files
    resources :job_development_results
    resources :job_vice_result_files
    resources :job_vice_results
    resources :job_routine_result_files
    resources :job_routine_results
    resources :job_plan_result_files
    resources :job_plan_results
    
    resources :job_plan_files, concerns: :destroy_with_ids
    resources :job_plans, concerns: :destroy_with_ids do 
      post :chose_job_template, on: :collection
      post :chose_job_template_group, on: :collection
    end
    
    resources :job_development_files, concerns: :destroy_with_ids
    resources :job_developments, concerns: :destroy_with_ids do 
      post :chose_job_template, on: :collection
      post :chose_job_template_group, on: :collection
    end
    
    resources :job_vice_files, concerns: :destroy_with_ids
    resources :job_vices, concerns: :destroy_with_ids do 
      post :chose_job_template, on: :collection
      post :chose_job_template_group, on: :collection
    end
    
    resources :job_routine_files, concerns: :destroy_with_ids
    resources :job_routines, concerns: :destroy_with_ids do 
      post :chose_job_template, on: :collection
      post :chose_job_template_group, on: :collection
    end
    
  end

  namespace :settings do
    resources :captains, concerns: :destroy_with_ids
    resources :evaluations, concerns: :destroy_with_ids
    resources :job_template_groups, concerns: :destroy_with_ids
    resources :job_templates, concerns: :destroy_with_ids
    resources :locations, concerns: :destroy_with_ids
    resources :positions, concerns: :destroy_with_ids
    resources :sections, concerns: :destroy_with_ids
  end

  resources :news_calendars, concerns: :destroy_with_ids

  resources :news_fronts, concerns: :destroy_with_ids

  resources :news_images, concerns: :destroy_with_ids
  
  # DEFAULT SYSTEM
  
  resources :tickets, concerns: :destroy_with_ids do
    post :comment, on: :collection
  end
  
  resources :messages, concerns: :destroy_with_ids

  resources :notifications, concerns: :destroy_with_ids do
    get :seen, on: :collection
  end

  resources :comments, concerns: :destroy_with_ids
  
  namespace :admin do
    resources :users, concerns: :destroy_with_ids
    resources :user_groups, concerns: :destroy_with_ids
  end

  devise_for :users, controllers: { sessions: "users/sessions", passwords: "users/passwords", registrations: "users/registrations" }

  namespace :users do
    resources :profiles, only: [:index, :show, :edit, :update] do
      get '', on: :collection, to: :show
      get :edit, on: :collection
    end
    resources :settings, only: [:update]
  end

  resources :user_access_logs, concerns: :destroy_with_ids
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  # root 'frontend#index'
  # get '/frontend/news(/:id)' => 'frontend#news', as: :news_frontend
  # post '/frontend/chose_date_news_calendar' => 'frontend#chose_date_news_calendar', as: :chose_date_news_calendar_frontend
  # post '/frontend/comment/:id/news_front' => 'frontend#comment_news_front', as: :comment_news_front_frontend

  root 'dashboards#index'
  get '/dashboards' => 'dashboards#index'
  get '/pd' => 'dashboards#pd'
  get '/pf' => 'dashboards#pf'
  get '/confirm' => 'dashboards#confirm'
  get '/dashboards/evaluation' => 'dashboards#evaluation', as: :evaluation_dashboards
  
  post '/change_current_evaluation' => 'dashboards#change_current_evaluation', as: :change_current_evaluation
  
  get '/search' => 'search#index'
  
  get '/manuals' => 'manuals#index', as: :manuals
  
  get '/orb/template', to: 'orb#template'
  get '/orb_frontend/template', to: 'orb_frontend#template'
  
  get '/systems/workflow_states' => 'systems#workflow_states'
  
  get '/documentary(/:year/:pid)' => 'documentaries#index', as: :documentary
  get '/documentary/:year/:pid/leaves' => 'documentaries#leaves', as: :leaves_documentary
  get '/documentary/:year/:pid/checkinouts' => 'documentaries#checkinouts', as: :checkinouts_documentary
  
  get '/e360s(/:role)' => 'e360s#index', as: :e360s
  get '/e360s/:role/user/:user_id' => 'e360s#user', as: :user_e360s
  post '/e360s/:role/e360_item_user_save' => 'e360s#e360_item_user_save', as: :e360_item_user_save_e360s
  
  get '/pds' => 'pds#index', as: :pds
  post '/pds/clone' => 'pds#clone', as: :clone_pds
  get '/pds/x' => 'pds#x', as: :x_pds
  get '/pds/x/:id' => 'pds#x_user', as: :x_user_pds
  get '/pds/print/:id' => 'pds#print', as: :print_pds
  post '/pds/confirm' => 'pds#confirm', as: :confirm_pds
  
  post '/pds/add_job_plan' => 'pds#add_job_plan', as: :add_job_plan_pds
  get '/pds/edit_job_plan' => 'pds#edit_job_plan', as: :edit_job_plan_pds
  post '/pds/update_job_plan' => 'pds#update_job_plan', as: :update_job_plan_pds
  post '/pds/remove_job_plan' => 'pds#remove_job_plan', as: :remove_job_plan_pds
  post '/pds/chose_job_template_group_job_plan' => 'pds#chose_job_template_group_job_plan', as: :chose_job_template_group_job_plan_pds
  
  post '/pds/add_job_routine' => 'pds#add_job_routine', as: :add_job_routine_pds
  get '/pds/edit_job_routine' => 'pds#edit_job_routine', as: :edit_job_routine_pds
  post '/pds/update_job_routine' => 'pds#update_job_routine', as: :update_job_routine_pds
  post '/pds/remove_job_routine' => 'pds#remove_job_routine', as: :remove_job_routine_pds
  post '/pds/chose_job_template_group_job_routine' => 'pds#chose_job_template_group_job_routine', as: :chose_job_template_group_job_routine_pds
  
  post '/pds/add_job_vice' => 'pds#add_job_vice', as: :add_job_vice_pds
  get '/pds/edit_job_vice' => 'pds#edit_job_vice', as: :edit_job_vice_pds
  post '/pds/update_job_vice' => 'pds#update_job_vice', as: :update_job_vice_pds
  post '/pds/remove_job_vice' => 'pds#remove_job_vice', as: :remove_job_vice_pds
  post '/pds/chose_job_template_group_job_vice' => 'pds#chose_job_template_group_job_vice', as: :chose_job_template_group_job_vice_pds
  
  post '/pds/add_job_development' => 'pds#add_job_development', as: :add_job_development_pds
  get '/pds/edit_job_development' => 'pds#edit_job_development', as: :edit_job_development_pds
  post '/pds/update_job_development' => 'pds#update_job_development', as: :update_job_development_pds
  post '/pds/remove_job_development' => 'pds#remove_job_development', as: :remove_job_development_pds
  post '/pds/chose_job_template_group_job_development' => 'pds#chose_job_template_group_job_development', as: :chose_job_template_group_job_development_pds
  
  get '/pfs' => 'pfs#index', as: :pfs
  get '/pfs/x' => 'pfs#x', as: :x_pfs
  get '/pfs/x/:id' => 'pfs#x_user', as: :x_user_pfs
  get '/pfs/print/:id' => 'pfs#print', as: :print_pfs
  
  post '/pfs/add_job_plan_result' => 'pfs#add_job_plan_result', as: :add_job_plan_result_pfs
  get '/pfs/edit_job_plan_result' => 'pfs#edit_job_plan_result', as: :edit_job_plan_result_pfs
  post '/pfs/update_job_plan_result' => 'pfs#update_job_plan_result', as: :update_job_plan_result_pfs
  post '/pfs/remove_job_plan_result' => 'pfs#remove_job_plan_result', as: :remove_job_plan_result_pfs
  post '/pfs/upload_job_plan_result' => 'pfs#upload_job_plan_result', as: :upload_job_plan_result_pfs
  get '/pfs/edit_job_plan_result_file' => 'pfs#edit_job_plan_result_file', as: :edit_job_plan_result_file_pfs
  post '/pfs/update_job_plan_result_file' => 'pfs#update_job_plan_result_file', as: :update_job_plan_result_file_pfs
  post '/pfs/remove_job_plan_result_file' => 'pfs#remove_job_plan_result_file', as: :remove_job_plan_result_file_pfs
  post '/pfs/update_job_plan_self_point' => 'pfs#update_job_plan_self_point', as: :update_job_plan_self_point_pfs
  
  post '/pfs/add_job_routine_result' => 'pfs#add_job_routine_result', as: :add_job_routine_result_pfs
  get '/pfs/edit_job_routine_result' => 'pfs#edit_job_routine_result', as: :edit_job_routine_result_pfs
  post '/pfs/update_job_routine_result' => 'pfs#update_job_routine_result', as: :update_job_routine_result_pfs
  post '/pfs/remove_job_routine_result' => 'pfs#remove_job_routine_result', as: :remove_job_routine_result_pfs
  post '/pfs/upload_job_routine_result' => 'pfs#upload_job_routine_result', as: :upload_job_routine_result_pfs
  get '/pfs/edit_job_routine_result_file' => 'pfs#edit_job_routine_result_file', as: :edit_job_routine_result_file_pfs
  post '/pfs/update_job_routine_result_file' => 'pfs#update_job_routine_result_file', as: :update_job_routine_result_file_pfs
  post '/pfs/remove_job_routine_result_file' => 'pfs#remove_job_routine_result_file', as: :remove_job_routine_result_file_pfs
  post '/pfs/update_job_routine_self_point' => 'pfs#update_job_routine_self_point', as: :update_job_routine_self_point_pfs
  
  post '/pfs/add_job_vice_result' => 'pfs#add_job_vice_result', as: :add_job_vice_result_pfs
  get '/pfs/edit_job_vice_result' => 'pfs#edit_job_vice_result', as: :edit_job_vice_result_pfs
  post '/pfs/update_job_vice_result' => 'pfs#update_job_vice_result', as: :update_job_vice_result_pfs
  post '/pfs/remove_job_vice_result' => 'pfs#remove_job_vice_result', as: :remove_job_vice_result_pfs
  post '/pfs/upload_job_vice_result' => 'pfs#upload_job_vice_result', as: :upload_job_vice_result_pfs
  get '/pfs/edit_job_vice_result_file' => 'pfs#edit_job_vice_result_file', as: :edit_job_vice_result_file_pfs
  post '/pfs/update_job_vice_result_file' => 'pfs#update_job_vice_result_file', as: :update_job_vice_result_file_pfs
  post '/pfs/remove_job_vice_result_file' => 'pfs#remove_job_vice_result_file', as: :remove_job_vice_result_file_pfs
  post '/pfs/update_job_vice_self_point' => 'pfs#update_job_vice_self_point', as: :update_job_vice_self_point_pfs
  
  post '/pfs/add_job_development_result' => 'pfs#add_job_development_result', as: :add_job_development_result_pfs
  get '/pfs/edit_job_development_result' => 'pfs#edit_job_development_result', as: :edit_job_development_result_pfs
  post '/pfs/update_job_development_result' => 'pfs#update_job_development_result', as: :update_job_development_result_pfs
  post '/pfs/remove_job_development_result' => 'pfs#remove_job_development_result', as: :remove_job_development_result_pfs
  post '/pfs/upload_job_development_result' => 'pfs#upload_job_development_result', as: :upload_job_development_result_pfs
  get '/pfs/edit_job_development_result_file' => 'pfs#edit_job_development_result_file', as: :edit_job_development_result_file_pfs
  post '/pfs/update_job_development_result_file' => 'pfs#update_job_development_result_file', as: :update_job_development_result_file_pfs
  post '/pfs/remove_job_development_result_file' => 'pfs#remove_job_development_result_file', as: :remove_job_development_result_file_pfs
  post '/pfs/update_job_development_self_point' => 'pfs#update_job_development_self_point', as: :update_job_development_self_point_pfs
  
  get '/confirms' => 'confirms#index', as: :confirms
  get '/confirms/:id' => 'confirms#user', as: :user_confirms
  post '/confirms/:id/confirm_selected' => 'confirms#confirm_selected', as: :confirm_selected_confirms
  get '/confirms/:id/job_plan/:job_plan_id/confirm' => 'confirms#confirm_job_plan', as: :confirm_job_plan_confirms
  get '/confirms/:id/job_routine/:job_routine_id/confirm' => 'confirms#confirm_job_routine', as: :confirm_job_routine_confirms
  get '/confirms/:id/job_vice/:job_vice_id/confirm' => 'confirms#confirm_job_vice', as: :confirm_job_vice_confirms
  get '/confirms/:id/job_development/:job_development_id/confirm' => 'confirms#confirm_job_development', as: :confirm_job_development_confirms
  get '/confirms/:id/job_plan/:job_plan_id/unconfirm' => 'confirms#unconfirm_job_plan', as: :unconfirm_job_plan_confirms
  get '/confirms/:id/job_routine/:job_routine_id/unconfirm' => 'confirms#unconfirm_job_routine', as: :unconfirm_job_routine_confirms
  get '/confirms/:id/job_vice/:job_vice_id/unconfirm' => 'confirms#unconfirm_job_vice', as: :unconfirm_job_vice_confirms
  get '/confirms/:id/job_development/:job_development_id/unconfirm' => 'confirms#unconfirm_job_development', as: :unconfirm_job_development_confirms
  
  get '/confirms/:id/job_plan_result/:job_plan_result_id/confirm' => 'confirms#confirm_job_plan_result', as: :confirm_job_plan_result_confirms
  get '/confirms/:id/job_routine_result/:job_routine_result_id/confirm' => 'confirms#confirm_job_routine_result', as: :confirm_job_routine_result_confirms
  get '/confirms/:id/job_vice_result/:job_vice_result_id/confirm' => 'confirms#confirm_job_vice_result', as: :confirm_job_vice_result_confirms
  get '/confirms/:id/job_development_result/:job_development_result_id/confirm' => 'confirms#confirm_job_development_result', as: :confirm_job_development_result_confirms
  get '/confirms/:id/job_plan_result/:job_plan_result_id/unconfirm' => 'confirms#unconfirm_job_plan_result', as: :unconfirm_job_plan_result_confirms
  get '/confirms/:id/job_routine_result/:job_routine_result_id/unconfirm' => 'confirms#unconfirm_job_routine_result', as: :unconfirm_job_routine_result_confirms
  get '/confirms/:id/job_vice_result/:job_vice_result_id/unconfirm' => 'confirms#unconfirm_job_vice_result', as: :unconfirm_job_vice_result_confirms
  get '/confirms/:id/job_development_result/:job_development_result_id/unconfirm' => 'confirms#unconfirm_job_development_result', as: :unconfirm_job_development_result_confirms
  
  get '/assess(/:role)' => 'assess#index', as: :assess

  get '/assess/:role/position/:position_id' => 'assess#position', as: :position_assess
  post '/assess/:role/position_capacity_user_save' => 'assess#position_capacity_user_save', as: :position_capacity_user_save_assess

  get '/assess/:role/employee_type/:employee_type_id' => 'assess#employee_type', as: :employee_type_assess
  post '/assess/:role/employee_type_task_user_save' => 'assess#employee_type_task_user_save', as: :employee_type_task_user_save_assess

  get '/assess/:role/user/:user_id' => 'assess#user', as: :user_assess
  post '/assess/:role/user_save' => 'assess#user_save', as: :user_save_assess

  get '/reports' => 'reports#index', as: :reports
  get '/reports/users' => 'reports#users', as: :users_reports
  get '/reports/user(/:id)' => 'reports#user', as: :user_reports
  get '/reports/user/:id/comment' => 'reports#comment', as: :comment_reports
  get '/reports/user/:id/r4' => 'reports#r4', as: :r4_reports
  get '/reports/employee_type(/:id)' => 'reports#employee_type', as: :employee_type_reports
  get '/reports/job_result_others' => 'reports#job_result_others', as: :job_result_others_reports
  
  get '/reports/projects/expenses' => 'reports/projects#expenses', as: :expenses_projects_reports
  get '/reports/projects/expenses_by_range' => 'reports/projects#expenses_by_range', as: :expenses_by_range_projects_reports
  get '/reports/planners/summary_indicator' => 'reports/planners#summary_indicator', as: :summary_indicator_planners_reports
  get '/reports/edpex_kku' => 'reports#edpex_kku_report', as: :edpex_kku_reports
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
