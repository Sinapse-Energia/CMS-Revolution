mqtt_client = SinapseMQTTClientSingleton.instance

if mqtt_client.connected?
  #mqtt_client.subscribe(topic)
  topics = ["DEMOSTRADOR/CMC/PERIODIC", "DEMOSTRADOR/CMC/PERIODIC"]
  if mqtt_client.connected?
    topics.each do |topic|  
      mqtt_client.subscribe(topic)
      mqtt_client.topics_subscribed.push(topic)
    end
  end
end