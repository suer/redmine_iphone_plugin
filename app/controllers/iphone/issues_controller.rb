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
    if params[:tracker_id]
      @tracker = Tracker.find(params[:tracker_id])
      @issues = @project.issues.all(:conditions => [ "tracker_id = ?", params[:tracker_id] ])
    else
      @issues = @project.issues
    end

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
    @issue.parent_issue_id = params[:parent_issue_id] unless params[:parent_issue_id].blank?
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
