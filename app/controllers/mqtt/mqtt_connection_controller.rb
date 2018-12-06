class Mqtt::MqttConnectionController < ApplicationController
	before_action :mqtt_params
	def connect
    	mqtt_client = SinapseMQTTClientSingleton.instance
		@devices = Device.where(user_id: current_user.id)
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
			subscribes = SubscribeTopic.where(user_id: current_user.id)
			if (subscribes.count > 0) 
				subscribes.each do |sub|
				  	ReceiveMqttMessagesJob.new.async.perform(current_user) #kshitiz wanted this here
					mqtt_client.subscribe(sub.periodic_topic)
				  	mqtt_client.subscribe(sub.measurement_topic)
				  	mqtt_client.subscribe(sub.alert_topic)
				  	mqtt_client.subscribe(sub.debug_topic)
				end
			end
		end
		@last_messages = OperationData.where(user_id: current_user.id, created_at: Time.now-20*60..Time.now).order(created_at: :desc).limit(10)
		subscribe_topic
		publish_message
		respond_to do |format|
	      format.js {}
	    end
	end

	def disconnect
		mqtt_client = SinapseMQTTClientSingleton.instance
		@devices = Device.where(user_id: current_user.id)
		if mqtt_client.connected?
			mqtt_client.disconnect
			# SubscribeTopic.where(user_id: current_user.id).delete_all
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
		flag = false
		if mqtt_client.connected?
		  #mqtt_client.publish(topic, message)
		  PublishMessage.create(topic:params[:mqtt_publish][:topic],message:params[:mqtt_publish][:message],user_id: current_user.id)
		  if PublishMessage.where(user_id: current_user.id).count > 10
		  	PublishMessage.first.delete
		  end
		  mqtt_client.publish(params[:mqtt_publish][:topic], params[:mqtt_publish][:message])
		  flag = true
		end
		subscribe_topic
		publish_message
		if flag == true
			@notice = "Message is been published"
			respond_to do |format|
	      format.js
	    end
    else
			@notice = "Please check your connection reconnect the mqtt client to publish message"
	  end
	end

	def subscribe
		@last_messages = OperationData.where(user_id: current_user.id, created_at: Time.now-20*60..Time.now).order(created_at: :desc).limit(10)
		mqtt_client = SinapseMQTTClientSingleton.instance
	  topics = []
	  flag = false
		subscribe_topic
		if subscribe_topic.where(topic:params[:mqtt_subscribe][:topic]).present?
		else
			if mqtt_client.connected?
				#mqtt_client.subscribe(topic)
			  # topics = ["DEMOSTRADOR/CMC/PERIODIC"]
			  topic = params[:mqtt_subscribe][:topic]
			  periodic_topic = topic+"/CMC/PERIODIC"
			  measurement_topic = topic+"/CMC/MEASUREMENTS"
			  alert_topic = topic+"/CMC/ALERTS"
			  debug_topic = topic+"/CMC/DEBUG"
			  SubscribeTopic.create(periodic_topic:periodic_topic, measurement_topic:measurement_topic, alert_topic:alert_topic, debug_topic:debug_topic, user_id:current_user.id)
		  	mqtt_client.subscribe(periodic_topic)
		  	mqtt_client.subscribe(measurement_topic)
		  	mqtt_client.subscribe(alert_topic)
		  	mqtt_client.subscribe(debug_topic)
			  ReceiveMqttMessagesJob.new.async.perform(current_user)
			  flag = true
			end
			publish_message
			if flag == true
				@notice = "Topic Have been Subscribed"
				respond_to do |format|
		      format.js
		    end
	    else
				@notice = "Please check your connection reconnect the mqtt client to subscribe topic"
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
		flag = false
		message_data.each do |msg|
			topic = "TEST_CMSR"+"/CMC/ACT/"+msg[9]
			message = "11;ACT"+msg[0]+";""ACT"+msg[1]+";""ACT"+msg[2]+";""ACT"+msg[3]+";""ACT"+msg[4]+";""ACT"+msg[5]+";""ACT"+msg[6]+";TRUE"
			
			if mqtt_client.connected?
				#mqtt_client.publish(topic, message)
				device = Device.where(id_code: msg[8])
				
				if ( device[0].r1 != msg[0] || device[0].r2 != msg[1] || device[0].r3 != msg[2] || device[0].r4 != msg[3] || device[0].r5 != msg[4] || device[0].r6 != msg[5] || device[0].r7 != msg[6])
			  		
			  		PublishActuator.create(topic:topic,message:message,user_id: current_user.id)

					device[0].update(r1: msg[0],r2: msg[1],r3: msg[2],r4: msg[3],r5: msg[4],r6: msg[5],r7: msg[6])


					mqtt_client.publish(topic, message)
				else

				end	
			else
				flag = true
			end
		end
		@actuator_publish_message = PublishActuator.where(user_id: current_user.id).order(created_at: :desc)
		if flag == false
			@notice = "Message send successfully"
			respond_to do |format|
	      format.js
	    end
    else
			@notice = "Please check your connection message not send"
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
