module Workflowable

	PUBLISH = "publish"
	DRAFT 	= "draft"

	after_save :draft!

	def publish!
		state = PUBLISH
	end

	def draft!
		state = DRAFT
	end

	def published?
		state == PUBLISH
	end

	def draft?
		not published?
	end
end