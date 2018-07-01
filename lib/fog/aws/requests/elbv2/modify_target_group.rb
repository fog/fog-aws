module Fog
  module AWS
    class ELBV2

      module Both
        TARGET_GROUP_OPTIONS_MAPPING = {
          :target_type                    => 'TargetType',
          :healthy_threshold_count        => 'HealthyThresholdCount',
          :unhealthy_threshold_count      => 'UnhealthyThresholdCount',
          :health_check_interval_seconds  => 'HealthCheckIntervalSeconds',
          :health_check_path              => 'HealthCheckPath',
          :health_check_port              => 'HealthCheckPort',
          :health_check_protocol          => 'HealthCheckProtocol',
          :health_check_timeout_seconds   => 'HealthCheckTimeoutSeconds'
        }
      end

      class Real
        require 'fog/aws/parsers/elbv2/modify_target_group'

        # Modifies ELB Target Group
        #
        # ==== Parameters
        # * tg_id<~String> - The ARN of the target group
        #
        # ==== Optional parameters
        # * options<~Hash> -
        #   * :target_type<~String> - Type of the targets.
        #   * :matcher<~String> - The HTTP codes to use when checking for a successful response from a target. The default is 200. You can specify multiple values (for example, "200,202") or a range of values (for example, "200-299").
        #   * :healthy_threshold_count<~Integer> - The number of consecutive health checks successes required before considering an unhealthy target healthy. The default is 5.
        #   * :unhealthy_threshold_count<~Integer> - The number of consecutive health check failures required before considering a target unhealthy. The default is 2.
        #   * :health_check_interval_seconds<~Integer> - The approximate amount of time, in seconds, between health checks of an individual target. The default is 30 seconds.
        #   * :health_check_path<~String> - The ping path that is the destination on the targets for health checks. The default is "/".
        #   * :health_check_port<~String> - The port the load balancer uses when performing health checks on targets. The default is "traffic-port"
        #   * :health_check_protocol<~String> - The protocol the load balancer uses when performing health checks on targets. The default is the HTTP protocol.
        #   * :health_check_timeout_seconds<~Integer> - The amount of time, in seconds, during which no response from a target means a failed health check. The default is 5 seconds.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'ModifyTargetGroupResult'<~Hash>:
        #       * 'TargetGroups'<~Array>:
        #         * 'TargetType'<~String> - Type of the targets.
        #         * 'HealthCheckIntervalSeconds'<~Integer> - The approximate amount of time, in seconds, between health checks of an individual target.
        #         * 'HealthCheckPath'<~Integer> - The ping path that is the destination on the targets for health checks.
        #         * 'HealthCheckPort'<~String> - The port the load balancer uses when performing health checks on targets. The default is traffic-port, which indicates the port on which each target receives traffic from the load balancer.
        #         * 'HealthCheckProtocol'<~String> - The protocol the load balancer uses when performing health checks on targets. The default is the HTTP protocol.
        #         * 'HealthCheckTimeoutSeconds'<~Integer> - The amount of time, in seconds, during which no response from a target means a failed health check.
        #         * 'HealthyThresholdCount'<~Integer> - The number of consecutive health checks successes required before considering an unhealthy target healthy.
        #         * 'Matcher.HttpCode'<~String> - The HTTP codes to use when checking for a successful response from a target.
        #         * 'Name'<~String> - The name of the target group.
        #         * 'Port'<~Integer> - The port on which the targets receive traffic. This port is used unless you specify a port override when registering the target.
        #         * 'Protocol'<~String> - The protocol to use for routing traffic to the targets.
        #         * 'UnhealthyThresholdCount'<~Integer> - The number of consecutive health check failures required before considering a target unhealthy. The default is 2.
        #         * 'VpcId'<~String> - The identifier of the virtual private cloud (VPC).
        def modify_target_group(tg_id, options)
          params = {}
          params.merge!('Matcher.HttpCode' => options[:matcher]) if options[:matcher]
          Both::TARGET_GROUP_OPTIONS_MAPPING.each_pair do |key, target_group_key|
            params[target_group_key] = options[key] if options.has_key?(key)
          end
          request({
            'Action' => 'ModifyTargetGroup',
            'TargetGroupArn' => tg_id,
            :parser => Fog::Parsers::AWS::ELBV2::ModifyTargetGroup.new
          }.merge(params))
        end
      end

      class Mock
        def modify_target_group(tg_id, options)
          tg = self.data[:target_groups][tg_id]
          raise Fog::AWS::ELBV2::NotFound unless tg

          merge_data = {}

          merge_data['Matcher.HttpCode'] = options[:matcher] if options[:matcher]
          Both::TARGET_GROUP_OPTIONS_MAPPING.each_pair do |key, target_group_key|
            merge_data[target_group_key] = options[key] if options.has_key?(key)
          end

          tg.merge!(merge_data)

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'ModifyTargetGroupResult' => {
              'TargetGroups' => [tg]
            }
          }
          response
        end
      end
    end
  end
end
