class CreateTrucksTable < ActiveRecord::Migration[7.1]
  def change
    create_table :trucks do |t|
      t.string :registration_number, null: false
      t.string :model
      t.sring :make
      t.bigint :image_id

      t.timestamps
    end
  end
end
