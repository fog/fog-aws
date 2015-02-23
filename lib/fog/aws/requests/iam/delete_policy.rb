module Fog
  module AWS
    class IAM
      class Real
        require 'fog/aws/parsers/iam/basic'

        # Deletes a manged policy
        #
        # ==== Parameters
        # * policy_arn<~String>: arn of the policy
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.aws.amazon.com/IAM/latest/APIReference/API_DeletePolicy.html
        #
        def delete_policy(policy_arn)
          request(
            'Action'          => 'DeletePolicy',
            'PolicyArn'       => policy_arn,
            :parser           => Fog::Parsers::AWS::IAM::Basic.new
          )
        end
      end
    end
  end
end
