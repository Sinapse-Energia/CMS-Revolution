require 'sinapse_mqtt_client'
require 'singleton'

class SinapseMQTTClientSingleton < SinapseMQTTClientWrapper::SinapseMQTTClient
	include Singleton

	attr_reader :messages_received, :topics_subscribed, 

	def start_historical_variables_of_MQTT_client_singleton
		@messages_received = Array.new  #Array where the received messages are saved
		@topics_subscribed = Array.new
	end

end