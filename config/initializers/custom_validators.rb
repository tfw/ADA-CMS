# module ActiveRecord
#   module Validations
#     module ClassMethods
#       class AtLeastOneValidator
#         def initialize(options)
#           @options = options
#         end
# 
#         def validate(record)
#           association = @options[:association]
#           record.errors.add :base, "#{record.class} must have at least one #{association.to_s.classify}" unless record.send(association).size > 0
#         end
#       end
# 
#       def validates_at_least_one association
#         validates_with AtLeastOneValidator, :association => association
#       end
#     end
#   end
# end
