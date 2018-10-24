class ReceiveMqttMessagesJob < ActiveJob::Base
	self.queue_adapter = :sucker_punch

  def perform()
    mqtt_client = SinapseMQTTClientSingleton.instance

    if mqtt_client.connected? then
   		mqtt_client.receive_messages_from_subscribed_topics do |topic, message|
		 		mqtt_client.messages_received.push("Message: " + message + " received in topic: " + topic)
		 
		 	# PROCESS the MESSAGE
			end
    end
  end
end