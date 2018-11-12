class User < ApplicationRecord
  has_secure_password
  validates_uniqueness_of :email
  before_create :generate_access_token
  has_many :urls
  

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "120x120>" }, default_url: "/assets/missing_device.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  private
  def generate_access_token
    begin
      self.token = SecureRandom.hex
    end while self.class.exists?(token: token)
  end
end