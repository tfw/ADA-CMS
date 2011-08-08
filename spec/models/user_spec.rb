require 'spec_helper'

describe User do

	specify "that discovering a role for a user removes previous role memberships, and creates the role in the CMS if necessary" do
		role = Inkling::Role.make
		user = User.make
		role << user

		User.register_in_role(user, "foo")

		user.roles.count.should == 1
		user.roles.first.should == Inkling::Role.find_by_name("foo")
	end
end
