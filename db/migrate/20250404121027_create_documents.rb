class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.references :user, foreign_key: true, null: true
      t.references :truck, foreign_key: true, null: true
      t.references :worksheet, foreign_key: true, null: true

      t.string :source_class # to track which class it belongs to, e.g. User, Truck, worksheet, etc.
      t.string :document_type # to track which document type it is, example : license, visa, passport, pickup, delivery, etc.

      t.timestamps
    end
  end
end
