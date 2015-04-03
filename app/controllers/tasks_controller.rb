class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, except: :complete
  before_action :set_all_users, except: :destroy
  before_action :set_task, only: [:edit, :update, :destroy]

  def new
    @task = @project.tasks.build
  end

  def edit
    if current_user.id == @task.assigned_user_id || 
       current_user.id == @task.user_id
    else
      flash[:danger] = "You are not authorized to edit this task"
      redirect_to @project
    end
  end

  def create
    @task = @project.tasks.build(task_params)
    if @task.save
      flash[:success] = "Task Created"
      redirect_to @project
    else
      flash[:danger] = "Please fill in every field and ensure the due date is in the future."
      render :new
    end
  end

  def update
    if current_user.id == @task.assigned_user_id || 
       current_user.id == @task.user_id
      if @task.update(task_params)
        flash[:success] = "Updated the task: '#{@task.name}'"
        redirect_to @project
      else
        flash[:danger] = "Please fill in every field and ensure the due date is in the future."
        render :edit
      end
    else
      flash[:danger] = "You are not authorized to edit this task"
      redirect_to @project
    end
  end

  def destroy
    if current_user.id == @task.assigned_user_id || 
       current_user.id == @task.user_id  
      @task.destroy
      flash[:success] = "Deleted the task named: '#{@task.name}'"
      redirect_to @project
    else
      flash[:danger] = "You are not authorized to delete this task"
      redirect_to @project
    end
  end

  def complete
    @task = Task.find(params[:id])
    @task.toggle
    respond_to do |format|
      format.html { redirect_to request.referrer }
      format.js
    end
  end

  private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:name, :description, :due_date, :project_id, :user_id, :assigned_user_id, :complete, :priority)
    end

    def set_all_users
      @user_options = User.all.map{|u| [ u.first_name + " " + u.last_name, u.id ] }
    end
end
    
