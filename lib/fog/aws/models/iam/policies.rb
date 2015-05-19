require 'fog/aws/models/iam/policy'

module Fog
  module AWS
    class IAM
      class Policies < Fog::Collection
        model Fog::AWS::IAM::Policy

        attribute :username

        def all
          requires :username
          # AWS method get_user_policy only returns an array of policy names, this is kind of useless,
          # that's why it has to loop through the list to get the details of each element. I don't like it because it makes this method slow
          policy_names = service.list_user_policies(self.username).body['PolicyNames'] # it returns an array
          policies = policy_names.map do |policy_name|
            service.get_user_policy(policy_name, self.username).body['Policy']
          end
          load(policies) # data is an array of attribute hashes
        end

        def get(identity)
          requires :username

          data = service.get_user_policy(identity, self.username).body['Policy']
          new(data) # data is an attribute hash
        rescue Fog::AWS::IAM::NotFound
          nil
        end

        def new(attributes = {})
          super({ :username => self.username }.merge!(attributes))
        end
      end
    end
  end
end
