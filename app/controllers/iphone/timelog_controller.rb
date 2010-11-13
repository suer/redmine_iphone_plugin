class Iphone::TimelogController < ApplicationController
  unloadable
  
  layout "iphone"

  helper :timelog

  def new
    @project = Project.find(params[:project_id])
    @issue = Issue.find(params[:issue_id]) if params[:issue_id]

    @time_entry = TimeEntry.new(:project => @project, :issue => @issue, :user => User.current, :spent_on => User.current.today)
  end

  def report
  end

  def create
    @project = Project.find(params[:project_id])
    @issue = Issue.find(params[:issue_id]) if params[:issue_id]
    logger.info "++++++++++++++++++++++++++"
    logger.info params[:issue_id]

    @time_entry = TimeEntry.new(:project => @project, :issue => @issue, :user => User.current, :spent_on => User.current.today)
    @time_entry.attributes = params[:time_entry]

    if @time_entry.save
      flash[:notice] = l(:notice_successful_update)
    end

    redirect_to :controller => "projects", :action => 'show', :id => @time_entry.project
  end
end
