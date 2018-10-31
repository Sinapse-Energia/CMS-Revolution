class ReceiveMqttMessagesJob < ActiveJob::Base
  include SuckerPunch::Job
  self.queue_adapter = :sucker_punch

  def perform()
    mqtt_client = SinapseMQTTClientSingleton.instance

    if mqtt_client.connected? then
   		mqtt_client.receive_messages_from_subscribed_topics do |topic, message|
        arr = [];
        arr = message.split("\;")
         OperationData.create!(I1: arr[0], I2: arr[1], I3: arr[2], IN: arr[3], U12: arr[4], U23: arr[5], U32: arr[6], V1N: arr[7], V2N: arr[8],V3N: arr[9],P1: arr[10],P2: arr[11],P3: arr[12],Q1: arr[13],Q2: arr[14],Q3: arr[15],FDP1: arr[16],FDP2: arr[17],FDP3: arr[18],FDPS1: arr[19],FDPS2: arr[20],FDPS3: arr[21],EP1: arr[22],EP2: arr[23],EP3: arr[24],EQ1: arr[25],EQ2: arr[26],EQ3: arr[27],ES1: arr[28],ES2: arr[29],ES3: arr[30],F: arr[31],TIMESTAMP: Time.at(arr[37].to_i))
          
		 		# mqtt_client.messages_received.push("Message: " + message + " received in topic: " + topic)
		   
		 	# PROCESS the MESSAGE
			end
    end
  end
end