class AddColumnEvaluationScoreCardsComment < ActiveRecord::Migration
  def change
    
    add_column :evaluation_score_cards, :comment1, :text
    add_column :evaluation_score_cards, :comment2, :text
        
  end
end
