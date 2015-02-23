module Fog
  module AWS
    class IAM
      class Real
        require 'fog/aws/parsers/iam/basic'

        # Attaches a managed policy to a group
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
        # http://docs.aws.amazon.com/IAM/latest/APIReference/API_AttachGroupPolicy.html
        #
        def attach_group_policy(group_name, policy_arn)
          request(
            'Action'          => 'AttachGroupPolicy',
            'GroupName'       => group_name,
            'PolicyArn'      => policy_arn,
            :parser           => Fog::Parsers::AWS::IAM::Basic.new
          )
        end
      end
    end
  end
end
