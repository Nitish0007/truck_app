class PreCheck < ApplicationRecord
  belongs_to :ride

  validates :truck_inspection, presence: true
  validates :driver_self_inspection, presence: true
  validate :validate_truck_inspection_json
  validate :validate_trailer_inspection_json

  def validate_truck_inspection_json
    validate_json_data_for(:truck_inspection)
  end

  def validate_trailer_inspection_json
    validate_json_data_for(:trailer_inspection)
  end

  private
  
  def validate_json_data_for field
    data = send(field).with_indifferent_access
    return if data.blank?

    data.each do |key, value|
      unless value.is_a?(Hash)
        errors.add(:base, "#{key} must be an Object with keys :status and optionally :comment")
        next
      end

      value.keys.each do |v|
        unless ["comment", "status"].include?(v)
          errors.add(:base, "#{key} must contain only 'status' and optionally 'comment'")
        end
      end

      status = value[:status]
      comment = value[:comment]

      unless ['ok', 'not ok'].include?(status)
        errors.add(:base, "'#{key}' status must be from 'ok' or 'not ok' options")
      end
      if status == 'ok' && comment.present?
        errors.add(:base, "'#{key}' comment should only be passed when status is 'not ok'")
      end

    end
  end

end