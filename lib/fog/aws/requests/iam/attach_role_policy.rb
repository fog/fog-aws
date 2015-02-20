module Fog
  module AWS
    class IAM
      class Real
        require 'fog/aws/parsers/iam/basic'

        # Attaches a managed policy to a role
        #
        # ==== Parameters
        # * role_name<~String>: name of the role
        # * policy_arn<~String>: arn of the managed policy
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.aws.amazon.com/IAM/latest/APIReference/API_AttachRolePolicy.html
        #
        def attach_role_policy(role_name, policy_arn)
          request(
            'Action'          => 'AttachRolePolicy',
            'RoleName'       => role_name,
            'PolicyArn'      => policy_arn,
            :parser           => Fog::Parsers::AWS::IAM::Basic.new
          )
        end
      end
    end
  end
end
