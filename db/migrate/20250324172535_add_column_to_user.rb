class AddColumnToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :name, :string
    add_column :users, :license_number, :string
    add_column :users, :phone, :string
    add_column :users, :license_expiry_date, :datetime
    add_column :users, :role, :integer, default: 1, null: false

    # document ids (documents will be stored in another tables only references are here)
    add_column :users, :license_id, :bigint
    add_column :users, :visa_id, :bigint
    add_column :users, :passport_id, :bigint
    add_column :users, :medical_certificate_id, :bigint
    add_column :users, :police_check_id, :bigint
    add_column :users, :license_history_id, :bigint
  end
end
