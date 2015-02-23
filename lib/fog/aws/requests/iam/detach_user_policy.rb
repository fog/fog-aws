module Fog
  module AWS
    class IAM
      class Real
        require 'fog/aws/parsers/iam/basic'

        # Detaches a managed policy to a user
        #
        # ==== Parameters
        # * user_name<~String>: name of the user
        # * policy_arn<~String>: arn of the managed policy
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.aws.amazon.com/IAM/latest/APIReference/API_DetachUserPolicy.html
        #
        def detach_user_policy(user_name, policy_arn)
          request(
            'Action'          => 'DetachUserPolicy',
            'UserName'       => user_name,
            'PolicyArn'      => policy_arn,
            :parser           => Fog::Parsers::AWS::IAM::Basic.new
          )
        end
      end
    end
  end
end
