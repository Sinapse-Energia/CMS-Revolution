class ReceiveMqttMessagesJob < ActiveJob::Base
  include SuckerPunch::Job
  self.queue_adapter = :sucker_punch

  def perform()
    mqtt_client = SinapseMQTTClientSingleton.instance

    if mqtt_client.connected? then
   		mqtt_client.receive_messages_from_subscribed_topics do |topic, message|
        arr = [];
        arr = message.split("\;")
        if topic.include?("PERIODIC") || topic.include?("MEASUREMENTS")
          OperationData.create!(L3_READ_METERING_R: arr[0], CMC_ID: arr[1], I1: arr[2], I2: arr[3], I3: arr[4], IN: arr[5], U12: arr[6], U23: arr[7], U32: arr[8], V1N: arr[9], V2N: arr[10],V3N: arr[11],P1: arr[12],P2: arr[13],P3: arr[14],Q1: arr[15],Q2: arr[16],Q3: arr[17],S1: arr[18],S2: arr[19],S3: arr[20],FDP1: arr[21],FDP2: arr[22],FDP3: arr[23],FDPS1: arr[24],FDPS2: arr[25],FDPS3: arr[26],EP1: arr[27],EP2: arr[28],EP3: arr[29],EQ1: arr[30],EQ2: arr[31],EQ3: arr[32],ES1: arr[33],ES2: arr[34],ES3: arr[35],F: arr[36],TIMESTAMP: Time.at(arr[37].to_i),topic: topic, user_id: current_user.id)
        end
          
		 		# mqtt_client.messages_received.push("Message: " + message + " received in topic: " + topic)
		   
		 	# PROCESS the MESSAGE
			end
    end
  end
end