module OrbHelper

  # Workflow events
  def event_btn_class(event)
    case event
    when :disable, :unlock, :unpublish
      "btn-default"
    when :lock, :reopen, :reply, :reply_and_reopen, :edit_inplace, :open, :confirm, :print
      "btn-primary"
    when :reply_and_resolve, :resolve, :save, :save_change, :submit, :new, :send, :reply_n_fix, :finish
      "btn-success"
    when :enable, :publish, :read, :submit_and_publish, :show, :download, :search, :draft, :archive
      "btn-info"
    when :reject, :trash, :edit, :reply_n_open, :project_approve, :project_expense
      "btn-warning"
    when :terminate, :delete, :reply_n_close, :unconfirm
      "btn-danger"
    else
      "btn-default"
    end
  end

  def event_icon_tag(event)
    case event
    when :approve, :confirm, :finish
      raw %Q{<i class="fa fa-check"></i>}
    when :back
      raw %Q{<i class="fa fa-arrow-left"></i>}
    when :cancel, :unconfirm
      raw %Q{<i class="fa fa-ban"></i>}
    when :close
      raw %Q{<i class="fa fa-lock"></i>}
    when :delete, :destroy, :terminate
      raw %Q{<i class="fa fa-trash-o"></i>}
    when :disable
      raw %Q{<i class="fa fa-minus-circle"></i>}
    when :download
      raw %Q{<i class="fa fa-download"></i>}
    when :edit
      raw %Q{<i class="fa fa-pencil"></i>}
    when :edit_inplace
      raw %Q{<i class="fa fa-pencil"></i>}
    when :enable, :project_approve
      raw %Q{<i class="fa fa-check-circle"></i>}
    when :project_expense
      raw %Q{<i class="fa fa-money"></i>}
    when :lock
      raw %Q{<i class="fa fa-lock"></i>}
    when :new
      raw %Q{<i class="fa fa-plus"></i>}
    when :publish, :submit_and_publish
      raw %Q{<i class="fa fa-globe"></i>}
    when :read
      raw %Q{<i class="fa fa-eye"></i>}
    when :reopen, :reply_and_reopen, :reply_n_reopen, :change_to_draft, :change_to_enable, :change_to_project_expense
      raw %Q{<i class="fa fa-undo"></i>}
    when :reply
      raw %Q{<i class="fa fa-reply"></i>}
    when :resolve, :reply_and_resolve, :reply_n_close
      raw %Q{<i class="fa fa-check-square-o"></i>}
    when :save, :save_change, :submit
      raw %Q{<i class="fa fa-hdd-o"></i>}
    when :show
      raw %Q{<i class="fa fa-eye"></i>}
    when :search
      raw %Q{<i class="fa fa-search"></i>}
    when :unpublish 
      raw %Q{<i class="fa fa-ban"></i>}
    when :reject
      raw %Q{<i class="fa fa-arrow-left"></i>}
    when :restore
      raw %Q{<i class="fa fa-undo"></i>}
    when :unlock
      raw %Q{<i class="fa fa-unlock"></i>}
    when :trash
      raw %Q{<i class="fa fa-trash-o"></i>}
    when :send
      raw %Q{<i class="fa fa-send"></i>}
    when :open, :reply_n_open 
      raw %Q{<i class="fa fa-ticket"></i>}
    when :draft
      raw %Q{<i class="entypo-doc-text"></i>}
    when :archive
      raw %Q{<i class="entypo-archive"></i>}
    when :fix, :reply_n_fix
      raw %Q{<i class="fa fa-wrench"></i>}
    when :print
      raw %Q{<i class="fa fa-print"></i>}
    else
      ""
    end
  end

  def state_btn_class(state)
    case state
    when :disabled, :history, :inactive, :unpublished, :unpublished_locked, :unseen
      "btn-default"
    when :locked, :published_locked, :reopened, :replied, :confirmed, :printed
      "btn-primary"
    when :active, :current, :new, :opened, :resolved, :saved, :replied_n_fixed, :finished
      "btn-success"
    when :approved, :draft, :enabled, :published, :published_locked, :seen, :archived
      "btn-info"
    when :rejected, :trashed, :fixed, :replied_n_opened, :project_approved, :project_expensed
      "btn-warning"
    when :canceled, :closed, :terminated, :replied_n_closed
      "btn-danger"
    else
      "btn-default"
    end
  end

  def state_label_class(state)
    case state
    when :disabled, :history, :inactive, :unpublished, :unpublished_locked, :unseen
      "label-default"
    when :locked, :published_locked, :reopened, :replied, :archived
      "label-info"
    when :active, :current, :new, :opened, :resolved, :saved, :finished
      "label-success"
    when :approved, :draft, :enabled, :published, :published_locked, :seen, :confirmed, :printed
      "label-primary"
    when :rejected, :project_approved, :project_expensed
      "label-warning"
    when :canceled, :closed, :terminated, :trashed
      "label-danger"
    else
      "label-default"
    end
  end
  
end
