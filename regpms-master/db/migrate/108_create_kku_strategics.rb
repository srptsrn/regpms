# encoding: utf-8
class CreateKkuStrategics < ActiveRecord::Migration
  def change
    create_table :kku_strategics do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :kku_strategic_pillar, index: true
      t.integer :no
      t.string :name

      t.userstamps
      t.timestamps
    end
    add_reference :projects, :kku_strategic, index: true
    
    reversible do |dir|
      dir.up do
        [
          [
            1, "Green and Smart Campus",
            [
              [1, "พัฒนาการเป็นมหาวิทยาลัยสีเขียว"], 
              [2, "เป็นอุทยานการเรียนรู้ตลอดชีวิตของสังคม"], 
              [3, "สร้างความเป็นเลิศในการบริหารจัดการ"], 
              [4, "พัฒนา ว.หนองคาย เป็นประตูสู่อนุภูมิภาคลุ่มน้ำโขง"], 
            ]
          ], 
          [
            2, "Excellence Academy",
            [
              [5, "เป็นองค์กรที่เป็นเลิศด้านการผลิตบัณฑิต"], 
              [6, "เป็นองค์กรที่เป็นเลิศด้านการวิจัย"], 
              [7, "พัฒนามหาวิทยาลัยไปสู่ความเป็นสากล"], 
            ]
          ], 
          [
            3, "Culture and Care Community",
            [
              [8, "เป็นศูนย์กลางการทำนุบำรุงศิลปะวัฒนธรรม"], 
              [9, "เป็นองค์กรที่มีความห่วงใยต่อสังคม"], 
            ]
          ], 
          [
            4, "Creative Economy and Society",
            [
              [10, "ศูนย์กลางของเศรษฐกิจสร้างสรรค์ของภูมิภาค"], 
            ]
          ]
        ].each do |data|
          
          kku_strategic_pillar = KkuStrategicPillar.where(["name = ?", data[1]]).first
          kku_strategic_pillar = KkuStrategicPillar.new if kku_strategic_pillar.nil?
          kku_strategic_pillar.no = data[0]
          kku_strategic_pillar.name = data[1]
          kku_strategic_pillar.workflow_state = :enabled
          kku_strategic_pillar.save
          
          data[2].each do |data2|
            
            kku_strategic = KkuStrategic.where(["name = ?", data2[1]]).first
            kku_strategic = KkuStrategic.new if kku_strategic.nil?
            kku_strategic.kku_strategic_pillar_id = kku_strategic_pillar.id
            kku_strategic.no = data2[0]
            kku_strategic.name = data2[1]
            kku_strategic.workflow_state = :enabled
            kku_strategic.save
            
          end
          
        end
      end
    end
  end
end
