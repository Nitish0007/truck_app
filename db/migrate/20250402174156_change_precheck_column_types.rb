class ChangePrecheckColumnTypes < ActiveRecord::Migration[7.1]
  def change
    change_column :pre_checks, :truck_inspection, :jsonb, using: "truck_inspection::jsonb"
    change_column :pre_checks, :trailer_inspection, :jsonb, using: "trailer_inspection::jsonb"
    change_column :pre_checks, :driver_self_inspection, :jsonb, using: "driver_self_inspection::jsonb"
  end
end
