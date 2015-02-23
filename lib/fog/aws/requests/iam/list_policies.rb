module Fog
  module AWS
    class IAM
      class Real
        require 'fog/aws/parsers/iam/list_managed_policies'

        # Lists managed policies
        #
        # ==== Parameters
        # * options <~Hash>: options that filter the result set
        #   * Marker <~String>
        #   * MaxItems <~Integer>
        #   * OnlyAttached <~Boolean>
        #   * PathPrefix <~String>
        #   * Scope <~String>
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'RequestId'<~String> - Id of the request
        #     * 'IsTruncated'<~Boolean> 
        #     * 'Marker'<~String>
        #     * 'Policies'<~Array>:
        #       * Arn
        #       * AttachmentCount
        #       * CreateDate
        #       * DefaultVersionId
        #       * Description
        #       * IsAttachable
        #       * Path
        #       * PolicyId
        #       * PolicyName
        #       * UpdateDate
        # ==== See Also
        # http://docs.aws.amazon.com/IAM/latest/APIReference/API_ListPolicies.html
        #
        def list_policies(options={})
          request({
            'Action'          => 'ListPolicies',
            :parser           => Fog::Parsers::AWS::IAM::ListManagedPolicies.new
          }.merge(options))
        end
      end

      
    end
  end
end
