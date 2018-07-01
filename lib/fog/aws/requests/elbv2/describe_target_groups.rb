module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/describe_target_groups'

        # Describes the specified target groups or all of your target groups. By default, all target groups are described. Alternatively, you can specify one of the following to filter the results: the ARN of the load balancer, the names of one or more target groups, or the ARNs of one or more target groups.
        #
        # ==== Parameters
        # * lb_id<~String> - The Amazon Resource Name (ARN) of the load balancer.s
        # * tg_ids<~Array> - The Amazon Resource Names (ARN) of the target groups. Array of strings.
        #
        # ==== Optional parameters
        # * options<~Hash>
        #   * :names<~Array> - The names of the target groups. Array of strings.
        #   * :marker<~String> - The marker for the next set of results.
        #   * :page_size<~Integer> - The maximum number of results to return with this call. Range is 1...400.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'DescribeTargetGroupsResult'<~Hash>:
        #       * 'TargetGroups'<~Array>:
        #         * 'HealthCheckIntervalSeconds'<~Integer> - The approximate amount of time, in seconds, between health checks of an individual target.
        #         * 'HealthCheckPath'<~Integer> - The ping path that is the destination on the targets for health checks.
        #         * 'HealthCheckPort'<~String> - The port the load balancer uses when performing health checks on targets. The default is traffic-port, which indicates the port on which each target receives traffic from the load balancer.
        #         * 'HealthCheckProtocol'<~String> - The protocol the load balancer uses when performing health checks on targets. The default is the HTTP protocol.
        #         * 'HealthCheckTimeoutSeconds'<~Integer> - The amount of time, in seconds, during which no response from a target means a failed health check.
        #         * 'HealthyThresholdCount'<~Integer> - The number of consecutive health checks successes required before considering an unhealthy target healthy.
        #         * 'Matcher.HttpCode'<~String> - The HTTP codes to use when checking for a successful response from a target.
        #         * 'Name'<~String> - The name of the target group.
        #         * 'TargetType'<~String> - Type of the targets.
        #         * 'Port'<~Integer> - The port on which the targets receive traffic. This port is used unless you specify a port override when registering the target.
        #         * 'Protocol'<~String> - The protocol to use for routing traffic to the targets.
        #         * 'UnhealthyThresholdCount'<~Integer> - The number of consecutive health check failures required before considering a target unhealthy. The default is 2.
        #         * 'VpcId'<~String> - The identifier of the virtual private cloud (VPC).
        def describe_target_groups(lb_id = nil, tg_ids = [], options = {})
          tg_ids = [*tg_ids]
          params = {}
          params['Marker'] = options[:marker] if options[:marker]
          params['PageSize'] = options[:page_size] if options[:page_size]
          params['LoadBalancerArn'] = lb_id if lb_id
          params.merge!(Fog::AWS.serialize_keys('TargetGroupArns', tg_ids)) if tg_ids.any?
          params.merge!(Fog::AWS.serialize_keys('Names', options[:names])) if options[:names]
          request({
            'Action' => 'DescribeTargetGroups',
            :parser => Fog::Parsers::AWS::ELBV2::DescribeTargetGroups.new
          }.merge(params))
        end
      end

      class Mock
        def describe_target_groups(lb_id = nil, tg_ids = [], options = {})
          tg_ids = [*tg_ids]
          target_groups = self.data[:target_groups]
          target_groups = tg_ids.any? ? target_groups.values_at(*tg_ids) : target_groups.values
          target_groups = target_groups.select { |target_group|
            target_group['LoadBalancerArn'] == lb_id
          } if lb_id
          target_groups = target_groups.select { |target_group|
            options[:names].include?(target_group['TargetGroupName'])
          } if options[:names]

          target_groups = target_groups.map { |target_group|
            raise Fog::AWS::ELBV2::TargetGroupNotFound unless target_group
            d = target_group.dup
            d.delete(:attributes)
            d.delete(:targets)
            d.delete(:target_healths)
            d
          }

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'DescribeTargetGroupsResult' => {
              'TargetGroups' => target_groups
            }
          }
          response
        end
      end
    end
  end
end
