App.device = App.cable.subscriptions.create("DevicesChannel", {
  connected: function(){
    //Called when the subscription is ready for use on the server
  },
  disconnected: function(){
    //Called when the subscription has been terminated by the server
  },
  received: function(data){
    console.log('in Devise');
    //Called when there's incoming data on the websocket for this channel
  }
});