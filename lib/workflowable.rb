module Workflowable

	PUBLISH = "publish"
	DRAFT 	= "draft"

	def self.included(base)
		base.send("before_save", :draft!, :unless => "self.draft?")
	end

	def publish!(user)
		if (user.roles & permitted_roles).any?
			self.state = PUBLISH
			self.save!
			debugger
			puts "+"
		else
			false
		end
	end

	def draft!
		self.state = DRAFT
	end

	def published?
		self.state == PUBLISH
	end

	def draft?
		not published?
	end

	private
	def permitted_roles
		[Inkling::Role.find_by_name("administrator"),
		Inkling::Role.find_by_name("Manager"),
		Inkling::Role.find_by_name("Publisher"),
		Inkling::Role.find_by_name("Approver")]
	end
end