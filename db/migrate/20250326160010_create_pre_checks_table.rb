class CreatePreChecksTable < ActiveRecord::Migration[7.1]
  def change
    create_table :pre_checks do |t|
      t.references :ride, null: false, foreign_key: true
      t.json :truck_inspection
      t.json :trailer_inspection
      t.json :driver_self_inspection

      t.timestamps
    end
  end
end
