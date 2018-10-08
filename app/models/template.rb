class Template < ApplicationRecord
  has_many :devices

  # has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "120x120#" },
  #                   :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  #                   :url => "/system/:attachment/:id/:style/:filename",
  #                   :default_url => "/assets/template-1.png"

  # validates_attachment_content_type :image, content_type: ["image/png", "image/jpg", "image/jpeg"]
end
