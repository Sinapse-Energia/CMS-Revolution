var channel;
function subscribe(device_id, params){
    App.devices = App.cable.subscriptions.create({
        channel: 'DevicesChannel',
        device_id: device_id
    },
    {
        connected: function() {},
        disconnected: function() {},
        received: function(data) {
            $('#subscribe-table-body').append(
                "<tr>" +
                "<td>" + data['topic'] + "</td>" +
                "<td>" + data['msg'] + "</td>" +
                "<td>" + data['hours'] + "</td>" +
                "</tr>"
            );
        },
        start_messeging: function(data, params) {
            return this.perform('start_messeging', {
                device_id: device_id,
                config: params
            });
        }
    });
}

function establish_communication(device_id, params){
  channel = App.devices;
  App.devices.start_messeging(device_id, params);
}

function demolish_connection(){
  channel.unsubscribe();
}

function device_message(device_id, params, to_start = true) {
  if(to_start){
      subscribe(device_id, params);
      establish_communication(device_id, params)
  }
}
