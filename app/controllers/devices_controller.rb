
# require 'mqtt'
class DevicesController < ApplicationController
  before_action :fetch_device, except: [:index, :create, :new]
  before_action :authorize
  def index
    @devices = Device.all
  end

  def new
    @device = Device.new
    @devices = Device.all
  end

  def create
     @device = Device.new(device_params)
    if @device.save
      # @device.create_mqtt_broker
      redirect_to :devices
    else
      redirect_to new_device_path
    end
  end

  def edit
    @devices = Device.all
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
    redirect_to new_device_path
  end

  # MQTT device connect operations
  
 private

  def device_params
    params.require(:device).permit(:name, :id_code, :id_communication, :location, :longitude, :latitude, :altitude, :date_installation, :circuit_number, :name_street, :number_street, :power_installed, :power_contracted, :id_supply_contract, :clock_brand, :clock_model)
  end
end