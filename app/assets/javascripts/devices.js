//require channels

var initiated = false;

function selected_device(event) {
  var device_id = event.val();
  if(device_id == "0"){
    window.location.href = window.location.origin + "/devices/new"
  }else {
    $.ajax({
      url: "/devices/" + device_id + "/get_device",
      type: 'GET',
      dataType: 'html',
      success: function (data) {
        device_tabs(data);
      }
    });
  }
}

function connectMqtt_device(event){
  var method = event.text().replace(/\s/g, '');
  var data = $('#mqtt_frm').serialize();
  var params = $('#mqtt_frm').serializeArray();
  var device_id = event.data('id');
  $.ajax({
    url: "/devices/"+ device_id +"/"+ method +"",
    type: 'POST',
    dataType: 'json',
    data: data,
    success: function( data ){
      device_tabs(data['attachmentPartial']);
      $('.alert-success').fadeIn();
      $('.alert-success').text(data['message']);
      setTimeout(function () {
        $('.alert-success').delay(3000).fadeOut(1000);
      }, 3000);
      if(method == 'connect'){
        device_connect(params);
      }else if(method == 'disconnect'){
        $('#subscribe-table-body').html('');
          demolish_connection();
      }

    }
  });
}

function device_tabs(data) {
  var activ_tab = $('li.js-device-li.active a').attr('aria-controls');
  $('#deviceTabs').html(data);
  $('#deviceTabs .tab-pane.active').removeClass('active');
  $('#deviceTabs #' + activ_tab).addClass('active');
  $.mCustomScrollbar.defaults.scrollButtons.enable = true;
  $.mCustomScrollbar.defaults.axis = "yx";
  $(".roundscroll").mCustomScrollbar({theme: "rounded"});
}

function device_connect(params) {
  channel_params = {};
  $.each(params, function(index, value) {
    if(index > 1){
      var name = value['name'].split('[');
      name = name[1].split(']')[0];
      channel_params[name] = value['value']
    }
  });
  var device_id = $('.device-connect').data('id');
  device_message(device_id, channel_params);
}

$(document).on('turbolinks:load', function() {
  $.mCustomScrollbar.defaults.scrollButtons.enable = true;
  $.mCustomScrollbar.defaults.axis = "yx";
  $(".roundscroll").mCustomScrollbar({theme: "rounded"});
  var status = $('.status .status-area').text().replace(/\s/g, '');
  if (status == 'Connected'){
    var params = $('#mqtt_frm').serializeArray();
    device_connect(params);
  }
});