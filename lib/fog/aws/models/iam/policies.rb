require 'fog/aws/models/iam/policy'

module Fog
  module AWS
    class IAM
      class Policies < Fog::Collection
        model Fog::AWS::IAM::Policy

        attribute :username
        attribute :group_name

        def all
          requires_one :username, :group_name

          policies = if self.username
                       all_by_user(self.username)
                     else
                       all_by_group(self.group_name)
                     end

          load(policies) # data is an array of attribute hashes
        end

        def get(identity)
          requires_one :username, :group_name

          data = if self.username
                   service.get_user_policy(identity, self.username)
                 else
                   service.get_group_policy(identity, self.group_name)
                 end.body['Policy']

          new(data)
        rescue Fog::AWS::IAM::NotFound
          nil
        end

        def new(attributes = {})
          super(self.attributes.merge(attributes))
        end

        private

        # AWS method get_user_policy and list_group_policies only returns an array of policy names, this is kind of useless,
        # that's why it has to loop through the list to get the details of each element. I don't like it because it makes this method slow

        def all_by_group(group_name)
          response = service.list_group_policies(group_name)

          response.body['PolicyNames'].map do |policy_name|
            service.get_group_policy(policy_name, group_name).body['Policy']
          end
        end

        def all_by_user(username)
          response = service.list_user_policies(username)

          response.body['PolicyNames'].map do |policy_name|
            service.get_user_policy(policy_name, username).body['Policy']
          end
        end
      end
    end
  end
end
