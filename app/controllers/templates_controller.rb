class TemplatesController < ApplicationController
  def index
    @templates = Template.all
    @template = Template.first
  end

  def new
    @template = Template.new
    @templates = Template.all
  end

  def create
    @template = Template.new(template_params)

    file = params[:template][:hardware_json].read
    data = JSON.parse(file)
    @template.hardware_json = data

    if @template.save
      redirect_to :templates
    else
      redirect_back
    end
  end

  def edit
    @template = Template.find_by(id: params[:id])
    @templates = Template.all
  end

  def update
    @template = Template.find_by(id: params[:id])
    if params[:template][:hardware_json].present?
      # For template edit when upload json
      file = params[:template][:hardware_json].read
      data = JSON.parse(file)
      @template.update(name: params[:template][:name], hardware_json: data)
    else
      # Normal template updation
      @template.update(template_params)
    end
    redirect_to :templates
  end

  def get_template
    @templates = Template.all
    @template = Template.find_by_id(params[:id])
    render partial: 'templates/index', locals: {template: @template}
  end

  private

  def template_params
    params.require(:template).permit(:name, :json_name, :hardware_json, :image)
  end
end
