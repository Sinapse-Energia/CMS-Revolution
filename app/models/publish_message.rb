class PublishMessage
  include Mongoid::Document
  include Mongoid::Timestamps

  field :topic, type: String
  field :message , type: String
  field :user_id, type: Integer
end
