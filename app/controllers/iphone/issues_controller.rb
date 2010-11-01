class Iphone::IssuesController < ApplicationController
  unloadable
  layout "iphone"

  before_filter :find_issue, :only => [:show]
  before_filter :find_project
  helper :issues
  helper :journals
  helper :custom_fields
  helper :projects

  def index
    logger.info "++++++++++++++++++++++++++++++++++"
    if params[:tracker_id]
      @tracker = Tracker.find(params[:tracker_id])
      if params[:filter_status] == 'all'
        @issues = @project.issues.all(:conditions => [ "tracker_id = ?", params[:tracker_id]])
        logger.info "1++++++++++++++++++++++++++++++++++"
      elsif params[:filter_status].blank? or params[:filter_status] == 'open'
        @issues = @project.issues.all(:conditions => [ "tracker_id = ? and issue_statuses.is_closed = ?", params[:tracker_id], false])
        logger.info "2++++++++++++++++++++++++++++++++++"
      elsif params[:filter_status] == 'closed'
        @issues = @project.issues.all(:conditions => [ "tracker_id = ? and issue_statuses.is_closed = ?", params[:tracker_id], true])
        logger.info "3++++++++++++++++++++++++++++++++++"
      end
    else
      @issues = @project.issues
    end
    session[:filter_status] = params[:filter_status]

    @assigned_issues = Issue.visible.open.find(:all,
                                               :conditions => {:assigned_to_id => User.current.id},
                                               :include => [ :status, :project, :tracker, :priority ],
                                               :order => "#{IssuePriority.table_name}.position DESC, #{Issue.table_name}.updated_on DESC")
  end

  def show
    @journals = @issue.journals.find(:all, :include => [:user, :details], :order => "#{Journal.table_name}.created_on ASC")
    @journals.each_with_index {|j,i| j.indice = i+1}
    @journals.reverse! if User.current.wants_comments_in_reverse_order?
  end
  
  def new
    @issue = @project.issues.build
    unless params[:parent_issue_id].blank?
      @parent_issue = Issue.find(params[:parent_issue_id])
    end
  end
  
  def create
    @issue = @project.issues.build(params[:issue])
    @issue.author_id = User.current.id
    @issue.parent_issue_id = params[:parent_issue_id]
    if @issue.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to iphone_project_issues_path(@project, :tracker_id => @issue.tracker_id )
    else
      render :action => "new"
    end
  end

  private
  
    def find_issue
      @issue = Issue.find(params[:id])
    end

    def find_project
      @project = Project.find(params[:project_id])
    end
end
