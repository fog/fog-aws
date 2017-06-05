module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/describe_ssl_policies'

        # Describes the specified policies or all policies used for SSL negotiation.
        #
        # ==== Parameters
        # * names<~Array> - The names of the policies. Array of strings.
        # * options<~Hash>
        #   * :marker<~String> - The marker for the next set of results.
        #   * :page_size<~Integer> - The maximum number of results to return with this call. Range is 1...400.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'DescribeSSLPoliciesResult'<~Hash>:
        #       * 'SslPolicies'<~Array>:
        #         * 'Ciphers'<~Array>:
        #           * 'Name'<~String> - The name of the cipher.
        #           * 'Priority'<~String> - The priority of the cipher.
        #         * 'Name'<~String> - The name of the policy.
        #         * 'SslProtocols'<~Array> - The protocols, array of strings.
        #     * 'NextMarker'<~String> - Marker to specify for next page
        def describe_ssl_policies(names = [], options = {})
          params = {}
          params['Marker'] = options[:marker] if options[:marker]
          params['PageSize'] = options[:page_size] if options[:page_size]
          params.merge!(Fog::AWS.serialize_keys('Names', names))
          request({
            'Action' => 'DescribeSSLPolicies',
            :parser => Fog::Parsers::AWS::ELBV2::DescribeSslPolicies.new
          }.merge(params))
        end
      end

      class Mock
        def describe_ssl_policies(names = [], options = {})
          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'DescribeSSLPoliciesResult' => {
              'SslPolicies' => self.data[:ssl_policies]
            }
          }
          response
        end
      end
    end
  end
end
