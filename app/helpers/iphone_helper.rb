module IphoneHelper
  def render_project_hierarchy(project, level=0)
    html = ""
    html << "<li class='arrow'>"
    html << link_to("#{'&#187;' * level} &nbsp; #{h(project.name)}", iphone_project_path(project))
    html << "</li>"
    unless project.children.size == 0
      html << "<ul class='child-project rounded'>"
      project.children.each do |subproj|
        html << render_project_hierarchy(subproj, level + 1)
      end
      html << "</ul>"
    end
    html
  end
end
