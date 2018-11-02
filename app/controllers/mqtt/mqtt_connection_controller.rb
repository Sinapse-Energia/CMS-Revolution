class Mqtt::MqttConnectionController < ApplicationController
	before_action :mqtt_params, only: [:connect]

	def connect
    mqtt_client = SinapseMQTTClientSingleton.instance
		mqtt_client.host = params[:mqtt][:url].to_s
		mqtt_client.port = params[:mqtt][:port].to_i
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
			json_data = {"status" => "404", "message" => "unable to connected to the mqtt_client"}
		end
		respond_to do |format|
      format.js {}
    end
	end

	def disconnect
		mqtt_client = SinapseMQTTClientSingleton.instance
		if mqtt_client.connected?
			mqtt_client.disconnect
			json_data = {"status" => "200", "message" => "you are disconnected to the mqtt_client"}
		else
			json_data = {"status" => "404", "message" => "not connected with any mqtt_client"}
		end
		respond_to do |format|
      format.js {}
    end
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
		respond_to do |format|
      format.js {}
    end
	end

	def get_data
   @mqtt = OperationData.last
    respond_to do |format|
       format.js
       format.html
    end
	end

	def back
		respond_to do |format|
      format.js
    end
	end

	private

	def mqtt_params
		params.permit!
	end

end
