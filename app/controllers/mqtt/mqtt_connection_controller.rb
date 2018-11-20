class Mqtt::MqttConnectionController < ApplicationController
	before_action :mqtt_params
	def connect
    mqtt_client = SinapseMQTTClientSingleton.instance
		mqtt_client.host = params[:mqtt][:url].to_s
		mqtt_client.port = params[:mqtt][:port].to_i
		mqtt_client.username = params[:mqtt][:username].to_s
		mqtt_client.password = params[:mqtt][:password].to_s
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
		subscribe_topic
		publish_message
		respond_to do |format|
      format.js {}
    end
	end

	def disconnect
		mqtt_client = SinapseMQTTClientSingleton.instance
		if mqtt_client.connected?
			mqtt_client.disconnect
			SubscribeTopic.where(user_id: current_user.id).delete_all
			json_data = {"status" => "200", "message" => "you are disconnected to the mqtt_client"}
		else
			json_data = {"status" => "404", "message" => "not connected with any mqtt_client"}
		end
		subscribe_topic
		publish_message
		respond_to do |format|
      format.js {}
    end
	end

	def publishing
		params.permit!
		mqtt_client = SinapseMQTTClientSingleton.instance

		if mqtt_client.connected?
		  #mqtt_client.publish(topic, message)
		  PublishMessage.create(topic:params[:mqtt_publish][:topic],message:params[:mqtt_publish][:message],user_id: current_user.id)
		  if PublishMessage.where(user_id: current_user.id).count > 10
		  	PublishMessage.first.delete
		  end
		  mqtt_client.publish(params[:mqtt_publish][:topic], params[:mqtt_publish][:message])  
		end
		subscribe_topic
		publish_message
		respond_to do |format|
      format.js {}
    end
	end

	def subscribe
		mqtt_client = SinapseMQTTClientSingleton.instance
	  topics = []
		subscribe_topic
		if subscribe_topic.where(topic:params[:mqtt_subscribe][:topic]).present?
		else
			if mqtt_client.connected?
			  #mqtt_client.subscribe(topic)
			  # topics = ["DEMOSTRADOR/CMC/PERIODIC"]
			  topics << params[:mqtt_subscribe][:topic]
			  SubscribeTopic.create(topic:params[:mqtt_subscribe][:topic],user_id:current_user.id)
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
			publish_message
			respond_to do |format|
	      format.js {}
	    end
	  end
	end

	def get_data
   @mqtt = OperationData.last
   subscribe_topic
   publish_message
    respond_to do |format|
       format.js
       format.html
    end
	end

	def back
		subscribe_topic
		publish_message
		respond_to do |format|
      format.js
    end
	end

	def last_messages_received
		@last_messages = OperationData.where(CMC_ID: params[:id]).order(created_at: :desc).limit(10)
		respond_to do |format|
      format.js
    end
	end

	def publish_actuator_message
		mqtt_client = SinapseMQTTClientSingleton.instance
		message_data = params[:data].each_slice(10).to_a
		message_data.each do |msg|
			topic = TEST_CMSR+"/CMC/ACT/"+msg[8]
			message = "11;ACT"+msg[0]+";""ACT"+msg[1]+";""ACT"+msg[2]+";""ACT"+msg[3]+";""ACT"+msg[4]+";""ACT"+msg[5]+";""ACT"+msg[6]+";TRUE"
			if mqtt_client.connected?
				#mqtt_client.publish(topic, message)
			  PublishActuator.create(topic:topic,message:message,user_id: current_user.id)
			  mqtt_client.publish(topic, message)
			end
		end
		@actuator_publish_message = PublishActuator.where(user_id: current_user.id)
		respond_to do |format|
      format.js
    end
	end

	private

	def mqtt_params
		params.permit!
	end

	def publish_message
		@publish_message = PublishMessage.where(user_id: current_user.id)
	end

	def subscribe_topic
		@subscribe_topic = SubscribeTopic.where(user_id: current_user.id)
	end
end
