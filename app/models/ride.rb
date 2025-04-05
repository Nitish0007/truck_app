class Ride < ApplicationRecord
  belongs_to :truck
  belongs_to :user # consider user as driver
  has_one :pre_check
  has_one :worksheet
  # accepts_nested_attributes_for :worksheet

  def ride_documents
    Documents.where(worksheet_id: self.worksheet.id) if self.worksheet.present?
  end
end