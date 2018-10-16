
# require 'mqtt'
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
    if @device.save
      redirect_to :devices
    else
      redirect_to :back
    end
  end

  def edit
    @devices = Device.find_by(id: params[:id])
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