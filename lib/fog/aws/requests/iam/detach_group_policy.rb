module Fog
  module AWS
    class IAM
      class Real
        require 'fog/aws/parsers/iam/basic'

        # Detaches a managed policy from a group
        #
        # ==== Parameters
        # * group_name<~String>: name of the group
        # * policy_arn<~String>: arn of the managed policy
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.aws.amazon.com/IAM/latest/APIReference/API_DetachGroupPolicy.html
        #
        def detach_group_policy(group_name, policy_arn)
          request(
            'Action'          => 'DetachGroupPolicy',
            'GroupName'       => group_name,
            'PolicyArn'      => policy_arn,
            :parser           => Fog::Parsers::AWS::IAM::Basic.new
          )
        end
      end
    end
  end
end
