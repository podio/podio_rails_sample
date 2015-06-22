class TasksController < ApplicationController

  def index
    @tasks = Podio::Task.find_all(:responsible => 0, :completed => false) # 0 is a shortcut for current user
  end

  def show
    @task = Podio::Task.find(params[:id])
  end

end
