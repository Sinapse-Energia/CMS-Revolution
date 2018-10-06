
# require 'mqtt'
class DevicesController < ApplicationController
  before_action :fetch_device, except: [:index, :create, :new]

  def index
    fetch_data
  end

  def new
    @device = Device.new
    @devices = Device.all
    @templates = Template.all.map{|t| [t.name, t.id] }
  end

  def create
    @device = Device.new(device_params)
    if @device.save
      @device.create_mqtt_broker
      redirect_to :devices
    else
      redirect_back
    end
  end

  def edit
    @devices = Device.all
    @templates = Template.pluck(:name, :id)
  end

  def update
    if params[:device][:api_json].present?
      # For device management when upload json
      file = params[:device][:api_json].read
      data = JSON.parse(file)
      @device.update(api_json: data, template_id: params[:device][:template_id])
    else
      # Normal device updation
      @device.update(device_params)
    end
    redirect_to root_path
  end

  # MQTT device connect operations
  def connect
    begin
      if @device.api_json.present?
        if @device.mqtt_broker.connected == true
          render :json => {
                   message: 'Device already connected.'
                 }
        elsif
        @client = connect_mqtt_client

          # mqtt client publish and subscribe message
          @message = "Test message published at #{Time.now.strftime('%d-%m-%Y %H:%M:%S')}"
          @topic = @device.topic
          @client.publish(@topic, @message, retain= true)
          @client.subscribe(@topic)

          @templates = Template.pluck(:name, :id)
          if @client.connected?
            update_mqtt_details
            @device.mqtt_broker.update(connected: true)
            @device_tabs = render_to_string partial: 'devices/device_tabs',
                                            formats: :html,
                                            :locals => {device: @device, templates: @templates, message: @message, topic: @topic}
            render :json => {
                     :attachmentPartial => @device_tabs,
                     message: 'Device connected successfully.'
                   }
          end
        end
      else
        render :json => {
                 message: 'You didn\'t uploaded api_json, please upload it first'
               }
      end

    rescue MQTT::ProtocolException => mqtt_error
      render :json => {message: mqtt_error.message}
    rescue Exception => e
      render :json => {message: e.message}
    end
  end

  # MQTT device disconnect operations
  def disconnect
    begin
      if @device.mqtt_broker.connected == false
        render :json => {
                   message: 'Device already disconnected.',
               }
      else
        # device = Devices::ConnectService.new(params.dig(:mqtt_broker)).connect
        client = connect_mqtt_client
        @templates = Template.pluck(:name, :id)
        if client.connected?
          client.disconnect()
          @device.mqtt_broker.update(connected: false)
          @device_tabs = render_to_string partial: 'devices/device_tabs',
                                          formats: :html,
                                          :locals => {
                                            device: @device,
                                            templates: @templates
                                          }

          # Stop Thread
          Devices::CommunicationService.new(params.dig(:id), client, @device.topic).shutdown

          render :json => {
              :attachmentPartial => @device_tabs,
              message: 'Device disconnected successfully.'
          }
        end
      end
    rescue MQTT::ProtocolException => mqtt_error
      render :json => {message: mqtt_error.message}
    rescue Exception => e
      render :json => {message: e.message}
    end
  end

  def get_device
    @templates = Template.pluck(:name, :id)
    @message = "Test message published at #{Time.now.strftime('%d-%m-%Y %H:%M:%S')}"
    @topic = @device.topic
    render partial: 'device_tabs', locals: {device: @device, templates: @templates, message: @message, topic: @topic}
  end


  private

  def device_params
    params.require(:device).permit(:name, :interfaces_peripherals, :template_id, :user_id, :image)
  end

  def fetch_device
    @device = Device.find_by(id: params[:id])
  end

  def fetch_data
    @devices = Device.all.map{|d| [d.name, d.id] }
    @device = Device.find_by(id: @devices.first.last) rescue nil
    # @templates = Template.all.map{|t| [t.name, t.id] }
    @message = "Test message published at #{Time.now.strftime('%d-%m-%Y %H:%M:%S')}"
    if !@device.nil?
    	@topic = @device.topic
    else
        @topic = "DEFAULT_TOPIC"
    end
  end

  def connect_mqtt_client
    mqtt_broker = @device.mqtt_broker
    host = params[:mqtt_broker][:host]
    port = params[:mqtt_broker][:port]
    username = params[:mqtt_broker][:username]
    password = params[:mqtt_broker][:password]

    client_id = @device.client_id
    connection_params = {
      host: host,
      port: port,
      client_id: client_id
    }

    connection_params.merge!(
      username: username,
      password: password
    ) if username != '' && password != ''
    MQTT::Client.connect(connection_params)
  end

  def update_mqtt_details
    @device.mqtt_broker.update(host: params[:mqtt_broker][:host],
       port: params[:mqtt_broker][:port],
       username: params[:mqtt_broker][:username],
       password: params[:mqtt_broker][:password])
  end
end
