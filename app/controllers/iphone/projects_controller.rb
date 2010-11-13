class Iphone::ProjectsController < ApplicationController
  unloadable
  layout "iphone"

  before_filter :find_project

  def show
    cond = @project.project_condition(Setting.display_subprojects_issues?)
    TimeEntry.visible_by(User.current) do
      @total_hours = TimeEntry.sum(:hours, :include => :project, :conditions => cond).to_f
    end
  end
  
  def activity
    cond = ARCondition.new
    cond << @project.project_condition(Setting.display_subprojects_issues?)
    cond << ["issue_id = ?", params[:issue_id]] if params[:issue_id]

    TimeEntry.visible_by(User.current) do
      @entries = TimeEntry.find(:all, 
        :include => [:project, :activity, :user, {:issue => :tracker}],
        :conditions => cond.conditions)
    end
    
    # TODO : sort need be DESC
  end
  
  private

    def find_project
      @project = Project.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_404
    end

end
