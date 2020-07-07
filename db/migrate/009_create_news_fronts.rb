class CreateNewsFronts < ActiveRecord::Migration
  def change
    create_table :news_fronts do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.text :title
      t.text :detail
      t.attachment :image
      t.datetime :published_at

      t.userstamps
      t.timestamps
    end
  end
end
