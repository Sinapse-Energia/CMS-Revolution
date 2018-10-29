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

# Start basic singleton variables
mqtt_client.start_historical_variables_of_MQTT_client_singleton


# Test connection and then disconnect

# if mqtt_client.connected?
#   mqtt_client.disconnect
# end