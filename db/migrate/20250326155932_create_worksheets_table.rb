class CreateWorksheetsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :worksheets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :ride, null: false, foreign_key: true

      t.bigint :delivery_doc_id
      t.bigint :pickup_doc_id
      t.bigint :start_kms
      t.bigint :end_kms
      t.datetime :started_on
      t.datetime :completed_on
    end
  end
end
