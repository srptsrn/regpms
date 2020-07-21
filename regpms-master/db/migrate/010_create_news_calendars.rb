class CreateNewsCalendars < ActiveRecord::Migration
  def change
    create_table :news_calendars do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.datetime :start_at
      t.datetime :end_at
      t.text :title
      t.text :detail
      t.datetime :published_at

      t.userstamps
      t.timestamps
    end
  end
end
