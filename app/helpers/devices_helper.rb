module DevicesHelper
  def devices_dropdown
    devices = Device.all.map{|d| [d.name, d.id ]}
    select_tag 'select device', options_for_select(devices << ['Create New Device', '0'], params[:device_id] || devices.first), class: 'form-control csdropdown', onchange: 'selected_device($(this))'
  end

  def tab_list
    [
      ['globalview', 'Global View'],
      ['mqttclient', 'MQTT Client'],
      ['management', 'Management']
    ]
  end
end
