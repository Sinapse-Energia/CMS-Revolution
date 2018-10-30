class Mqtt::MqttConnectionController < ApplicationController

	def connect
		mqtt_client = SinapseMQTTClientSingleton.instance
		mqtt_client.host = "soporte-tecnico.bitnamiapp.com"
		mqtt_client.port = 1883
		# mqtt_client.username = "user"
		# mqtt_client.password = "password"
		mqtt_client.installation_id = "DEMOSTRADOR"
		mqtt_client.ssl = false
		mqtt_client.keep_alive = 3600

		# Connect
		mqtt_client.connect()
		if mqtt_client.connected?
			json_data = {"status" => "200", "message" => "you are connected to the mqtt_client"}
		else
			json_data = {"status" => "404", "message" => "session timeout please try again"}
		end
		render json: json_data
	end

	def publishing
		mqtt_client = SinapseMQTTClientSingleton.instance

		if mqtt_client.connected?
		  #mqtt_client.publish(topic, message)
		  mqtt_client.publish("TEST_INSTALLATION/TEST_TOPIC", "TEST MESSAGE;")  
		end
	end

	def subscribe
		mqtt_client = SinapseMQTTClientSingleton.instance

		if mqtt_client.connected?
		  #mqtt_client.subscribe(topic)
		  topics = ["DEMOSTRADOR/CMC/PERIODIC"]
		  if mqtt_client.connected?
		    topics.each do |topic|
		      mqtt_client.subscribe(topic)
		      # mqtt_client.topics_subscribed.push(topic)
		    end
		  end
		  ReceiveMqttMessagesJob.new.async.perform()
		end
		if mqtt_client.connected?
			json_data = {"status" => "200", "message" => "you are subscribed to the mqtt_client"}
		else
			json_data = {"status" => "404", "message" => "unable to subscribe please try again"}
		end
		render json: json_data
	end

end
