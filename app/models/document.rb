class Document < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :truck, optional: true
  belongs_to :worksheet, optional: true

  has_one_attached :file

  scope :licenses, -> { where(source_class: 'user', document_type: 'license') }
  scope :visas, -> { where(source_class: 'user', document_type: 'visa') }
  scope :passports, -> { where(source_class: 'user', document_type: 'passport') }
  scope :police_checks, -> { where(source_class: 'user', document_type: 'police_check') }
  scope :license_histories, -> { where(source_class: 'user', document_type: 'license_history') }
  scope :medical_certificates, -> { where(source_class: 'user', document_type: 'medical_certificate') }
  scope :worksheet_docs, -> { where(source_class: 'ride', document_type: 'worksheet') }

  def self.generate_pre_signed_upload_url byte_size, content_type, file_name, checksum
    folder = nil
    folder = "pdfs" if content_type.include?('pdf')
    folder = "images" if content_type.include?('image')

    key = folder.nil ? "#{SecureRandom.uuid}_#{file_name}" : "#{folder}/#{SecureRandom.uuid}_#{file_name}"
    blob = ActiveStorage::Blob.create_before_direct_upload!(
      key: key,
      filename: file_name,
      content_type: content_type,
      byte_size: byte_size,
      checksum: checksum
    )

    return [blob.service_url_for_direct_upload, blob.signed_id]
  end

  def file_url
    file.url(expires_in: 30.minutes)
  end
end