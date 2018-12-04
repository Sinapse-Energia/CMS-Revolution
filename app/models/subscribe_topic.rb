class SubscribeTopic
  include Mongoid::Document
  include Mongoid::Timestamps

  field :periodic_topic, type: String
  field :measurement_topic, type: String
  field :alert_topic, type: String
  field :debug_topic, type: String
  field :user_id, type: Integer
end
