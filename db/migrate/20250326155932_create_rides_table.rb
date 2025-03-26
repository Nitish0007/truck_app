class CreateRidesTable < ActiveRecord::Migration[7.1]
  def change
    create_table :rides do |t|
      t.references :user, null: false, foreign_key: true
      t.references :truck, null: false, foreign_key: true

      t.string :start_location, null: false
      t.string :end_location, null: false

      t.timestamps
    end
  end
end
