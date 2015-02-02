module Fog
  module AWS
    class IAM
      class Real
        require 'fog/aws/parsers/iam/list_roles'

        # Lists roles
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'Marker'<~String>: used to paginate subsequent requests
        #   * 'MaxItems'<~Integer>: limit results to this number per page
        #   * 'PathPrefix'<~String>: prefix for filtering results
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * Roles<~Array> -
        #       role<~Hash>:
        #         * 'Arn'<~String> -
        #         * 'AssumeRolePolicyDocument'<~String<
        #         * 'Path'<~String> -
        #         * 'RoleId'<~String> -
        #         * 'RoleName'<~String> -
        #     * 'IsTruncated<~Boolean> - Whether or not results were truncated
        #     * 'Marker'<~String> - appears when IsTruncated is true as the next marker to use
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_ListRoles.html
        #
        def list_roles(options={})
          request({
            'Action'    => 'ListRoles',
            :parser     => Fog::Parsers::AWS::IAM::ListRoles.new
          }.merge!(options))
        end
      end

      class Mock
        def list_roles(options={})
          Excon::Response.new.tap do |response|
            response.body = {
              'Roles' => data[:roles].map do |role, data|
                {
                  'Arn'                      => data[:arn].strip,
                  'AssumeRolePolicyDocument' => Fog::JSON.encode(data[:assume_role_policy_document]),
                  'RoleId'                   => data[:role_id],
                  'Path'                     => data[:path],
                  'RoleName'                 => role,
                  'CreateDate'               => data[:create_date],
                }
              end,
              'RequestId' => Fog::AWS::Mock.request_id,
              'IsTruncated' => false,
            }
            response.status = 200
          end
        end
      end
    end
  end
end
