class RemoveColumns < ActiveRecord::Migration[7.1]
  def change
    # remove doc_ids from users
    remove_column :users, :license_id, :bigint
    remove_column :users, :visa_id, :bigint
    remove_column :users, :passport_id, :bigint
    remove_column :users, :medical_certificate_id, :bigint
    remove_column :users, :police_check_id, :bigint
    remove_column :users, :license_history_id, :bigint

    # remove doc_ids from trucks
    remove_column :trucks, :image_id, :bigint

    # remove doc_ids from worksheets
    remove_column :worksheets, :delivery_doc_id, :bigint
    remove_column :worksheets, :pickup_doc_id, :bigint
  end
end
