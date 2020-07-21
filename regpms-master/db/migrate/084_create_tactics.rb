# encoding: utf-8

class CreateTactics < ActiveRecord::Migration
  def change
    create_table :tactics do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.integer :sorting
      t.references :strategy, index: true
      t.text :name

      t.userstamps
      t.timestamps
    end
    
    add_reference :projects, :strategy, index: true
    add_reference :projects, :tactic, index: true
    
    reversible do |dir|
      dir.up do
        [
          [
            1, "การสร้างความเป็นเลิศในการบริหารจัดการ",
            [
              [1, "พัฒนาระบบการบริหารและการจัดการองค์กรเพื่อความเป็นเลิศ"], 
              [2, "พัฒนาระบบบริหารทรัพยากรบุคคลเพื่อสนับสนุนความเป็นเลิศขององค์กร"], 
              [3, "การส่งเสริมระบบประกันคุณภาพที่ดีตามมาตรฐานสากล"]
            ]
          ],
          [
            2, "เป็นองค์กรสนับสนุนการผลิตบัณฑิตเพื่อความเป็นเลิศ",
            [
              [1, "การสนับสนุนการพัฒนาหลักสูตรและการเรียนการสอนที่สามารถผลิตบัณฑิตที่มีคุณภาพ"], 
              [2, "การพัฒนาระบบรับเข้าศึกษาที่หลากหลาย"]
            ]
          ]
        ].each do |data|
          strategy = Strategy.where(["sorting = ?", data[0]]).first
          strategy = Strategy.new if strategy.nil?
          strategy.sorting = data[0]
          strategy.name = data[1]
          strategy.workflow_state = :enabled
          if strategy.save
            data[2].each do |dataa|
              tactic = Tactic.where(["strategy_id = ? AND sorting = ?", strategy.id, dataa[0]]).first
              tactic = Tactic.new if tactic.nil?
              tactic.strategy_id = strategy.id
              tactic.sorting = dataa[0]
              tactic.name = dataa[1]
              tactic.workflow_state = :enabled
              tactic.save
            end
          end
        end
      end
      dir.down do

      end
    end
  end
end
