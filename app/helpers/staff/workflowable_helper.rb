module Staff::WorkflowableHelper

	def workflow_icon(workflowable)
		if workflowable.published?
			image_tag("icons/flag_green.png", :title => "Published")
		else
			image_tag("icons/flag_orange.png", :title => "Draft, invisible to public")
		end
	end
end