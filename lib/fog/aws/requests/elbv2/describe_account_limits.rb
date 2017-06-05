module Fog
  module AWS
    class ELBV2
      class Real
        # Describes the current Elastic Load Balancing resource limits for the AWS account.
        # http://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_DescribeAccountLimits.html
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * :marker<~String> - The marker for the next set of results.
        #   * :page_size<~Integer> - The maximum number of results to return with this call. Range is 1...400.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'DescribeAccountLimitsResult'<~Hash>:
        #       * 'Limits'<~Hash>:
        #         * 'application-load-balancers'<~Integer>
        #         * 'listeners-per-application-load-balancer'<~Integer>
        #         * 'rules-per-application-load-balancer'<~Integer>
        #         * 'target-groups'<~Integer>
        #         * 'targets-per-application-load-balancer'<~Integer>
        #     * 'NextMarker'<~String> - Marker to specify for next page
        require 'fog/aws/parsers/elbv2/describe_account_limits'
        def describe_account_limits(options = {})
          params = {}
          params['Marker'] = options[:marker] if options[:marker]
          params['PageSize'] = options[:page_size] if options[:page_size]

          request({
            'Action'  => 'DescribeAccountLimits',
            :parser   => Fog::Parsers::AWS::ELBV2::DescribeAccountLimits.new
          }.merge(params))
        end
      end

      class Mock
        require 'fog/aws/elbv2/default_account_limits'
        def describe_account_limits(options = {})
          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'DescribeAccountLimitsResult' => {
              'Limits' => Fog::AWS::ELBV2::Mock.default_account_limits
            }
          }

          response
        end
      end
    end
  end
end
