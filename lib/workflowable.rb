module Workflowable
	attr_accessor :transition_to

	PUBLISH = "publish"
	DRAFT 	= "draft"

	def self.included(base)
		base.send("before_save", :draft!, :unless => "transition_to == PUBLISH")
	end

	def publish!(user)
#		# p "#{user.to_s}: #{user.roles.first.name} - #{user.can_approve?}"
		if user.can_approve?
			self.state = PUBLISH
			transition_to = PUBLISH
		else
			false
		end
	end

	def draft!
		self.state = DRAFT
		transition_to = DRAFT
	end

	def published?
		self.state == PUBLISH
	end

	def draft?
		not published?
	end
end