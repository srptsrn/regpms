class CreateNewsImages < ActiveRecord::Migration
  def change
    create_table :news_images do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.attachment :image
      t.datetime :published_at

      t.userstamps
      t.timestamps
    end
  end
end
