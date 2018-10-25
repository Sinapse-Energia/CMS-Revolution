
# require 'mqtt'
require 'date'
class DevicesController < ApplicationController
  before_action :fetch_device, except: [:index, :create, :new]
  before_action :authorize
  
  def index
    @devices = Device.where(user_id: current_user.id)
  end

  def new
    @device = Device.new
    @devices = Device.all
  end

  def create
    
    @device = Device.new(device_params)
    @device.date_installation = Date.strptime(device_params[:date_installation], "%m/%d/%Y")
    if @device.save
      redirect_to :devices
    else
      redirect_to :devices
    end
  end

  def edit
    @devices = Device.find_by(id: params[:id])
    respond_to do |format|               
       format.js
    end
  end

  def update
    date = Date.strptime(device_params[:date_installation], "%m/%d/%Y")
    @device.update(name: device_params[:name] ,id_code: device_params[:id_code] ,id_communication: device_params[:id_communication] ,location: device_params[:location] ,longitude: device_params[:longitude] ,latitude: device_params[:latitude] ,altitude: device_params[:altitude] ,date_installation: date ,circuit_number: device_params[:circuit_number] ,name_street: device_params[:name_street] ,number_street: device_params[:number_street] ,power_installed: device_params[:power_installed] ,power_contracted: device_params[:power_contracted] ,id_supply_contract: device_params[:id_supply_contract] ,clock_brand: device_params[:clock_brand] ,clock_model: device_params[:clock_model] ,user_id: device_params[:user_id])
    redirect_to devices_path
  end
  
  def destroy
    @device = Device.find_by(id: params[:id])
    @device.destroy
    redirect_to :devices
  end

  def device_mqtt
    respond_to do |format|               
       format.js
    end 
  end
 
  def create_device
    @device = Device.new
    respond_to do |format|               
       format.js
    end 
  end

  def get_device
    @devices = Device.where(user_id: current_user.id)
    respond_to do |format|               
       format.js
       format.html
    end 
  end

 private

  def device_params
    params.require(:device).permit(:name, :id_code, :id_communication, :location, :longitude, :latitude, :altitude, :date_installation, :circuit_number, :name_street, :number_street, :power_installed, :power_contracted, :id_supply_contract, :clock_brand, :clock_model, :user_id)
  end

  def fetch_device
    @device = Device.find_by(id: params[:id])
  end

  end
