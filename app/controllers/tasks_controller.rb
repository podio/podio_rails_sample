class TasksController < ApplicationController

  def index
    @tasks = Podio::Task.find_all
  end

  def show
    @task = Podio::Task.find(params[:id])
  end

end
