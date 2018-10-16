
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
    @same_id_code = Device.find_by(id_code: params[:id_code])
    @same_id_communication = Device.find_by(id_communication: params[:id_communication])
    @device = Device.new(device_params)
    if @same_id_communication
      flash[:notice] = "Duplicate Communication ID"
    elsif @same_id_code
      flash[:notice] = "Duplicate ID Code"
    else
      if @device.save
        redirect_to :devices
      else
        redirect_to new_device_path
      end
    end
  end

  def edit
    @devices = Device.all
    respond_to do |format|               
       format.js
    end
  end

  def update
    @device.update(device_params)
    redirect_to devices_path
  end
  
  def destroy
    @device = Device.find_by(id: params[:id])
    @device.destroy
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
    
    @devices = Device.all
    respond_to do |format|               
       format.js
       format.html
    end 
  end

 private

  def device_params
    params.require(:device).permit(:name, :id_code, :id_communication, :location, :longitude, :latitude, :altitude, :date_installation, :circuit_number, :name_street, :number_street, :power_installed, :power_contracted, :id_supply_contract, :clock_brand, :clock_model)
  end

  def fetch_device
    @device = Device.find_by(id: params[:id])
  end

  end
