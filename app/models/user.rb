class User < ApplicationRecord
  has_secure_password
  validates_uniqueness_of :email, :phone
  before_create :generate_access_token
  has_many :urls
  private
  def generate_access_token
    begin
      self.token = SecureRandom.hex
    end while self.class.exists?(token: token)
  end
end