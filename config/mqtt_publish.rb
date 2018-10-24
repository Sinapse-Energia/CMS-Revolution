mqtt_client = SinapseMQTTClientSingleton.instance

if mqtt_client.connected?
  #mqtt_client.publish(topic, message)
  mqtt_client.publish("TEST_INSTALLATION/TEST_TOPIC", "TEST MESSAGE;")  
end