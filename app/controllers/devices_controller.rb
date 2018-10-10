
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
      redirect_to :devices
    else
      redirect_to new_device_path
    end
  end

  def edit
    @devices = Device.all
  end

  def update
    @device.update(device_params)
    redirect_to devices_path
  end
 
 private

  def device_params
    params.require(:device).permit(:name, :id_code, :id_communication, :location, :longitude, :latitude, :altitude, :date_installation, :circuit_number, :name_street, :number_street, :power_installed, :power_contracted, :id_supply_contract, :clock_brand, :clock_model)
  end

  def fetch_device
    @device = Device.find_by(id: params[:id])
  end

  end