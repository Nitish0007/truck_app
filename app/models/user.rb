class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  enum role: { admin: 0, driver: 1 }
  
  has_many :rides
  has_many :worksheets
  has_many :documents

  def license
    documents.licenses.first
  end

  def passport
    documents.passports.first
  end

  def visa
    documents.visas.first
  end

  def medical_certificate
    documents.medical_certificates.first
  end

  def police_check
    documents.police_checks.first
  end

  def license_history
    documents.license_histories.first
  end
end