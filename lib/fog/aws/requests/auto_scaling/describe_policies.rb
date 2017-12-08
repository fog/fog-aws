module Fog
  module AWS
    class AutoScaling
      class Real
        require 'fog/aws/parsers/auto_scaling/describe_policies'

        # Returns descriptions of what each policy does. This action supports
        # pagination. If the response includes a token, there are more records
        # available. To get the additional records, repeat the request with the
        # response token as the NextToken parameter.
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'AutoScalingGroupName'<~String> - The name of the Auto Scaling
        #     group.
        #   * 'MaxRecords'<~Integer> - The maximum number of policies that will
        #     be described with each call.
        #   * 'NextToken'<~String> - The token returned by a previous call to
        #     indicate that there is more data available.
        #   * PolicyTypes<~Array> - A list of policy types to be
        #     described. If this list is omitted, policies of all types are
        #     described. If an auto scaling group name is provided, the results
        #     are limited to that group. Valid values are SimpleScaling and StepScaling
        #   * PolicyNames<~Array> - A list of policy names or policy ARNs to be
        #     described. If this list is omitted, all policy names are
        #     described. If an auto scaling group name is provided, the results
        #     are limited to that group.The list of requested policy names
        #     cannot contain more than 50 items. If unknown policy names are
        #     requested, they are ignored with no error.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'DescribePoliciesResult'<~Hash>:
        #       * 'ScalingPolicies'<~Array>:
        #         * 'Alarms'<~Array>:
        #           * 'AlarmARN'<~String> - The Amazon Resource Name (ARN) of
        #             the alarm.
        #           * 'AlarmName'<~String> - The name of the alarm.
        #         * 'AutoScalingGroupName'<~String> - The name of the Auto
        #           Scaling group associated with this scaling policy.
        #         * 'PolicyARN'<~String> - The Amazon Resource Name (ARN) of
        #           the policy.
        #         * 'PolicyName'<~String> - The name of the scaling policy.
        #         * 'Cooldown'<~Integer> - The amount of time, in seconds, after a
        #           scaling activity completes before any further trigger-related
        #           scaling activities can start
        #         * 'AdjustmentType'<~String> - The valid values are ChangeInCapacity, ExactCapacity, and PercentChangeInCapacity
        #           The param is supported by SimpleScaling and StepScaling policy types
        #         * 'EstimatedInstanceWarmup'<~Integer> - The estimated time, in seconds,
        #           until a newly launched instance can contribute to the CloudWatch metrics.
        #           The default is to use the value specified for the default cooldown period for the group.
        #           This parameter is supported if the policy type is StepScaling or TargetTrackingScaling.
        #         * 'MetricAggregationType'<~String> - The aggregation type for the CloudWatch metrics.
        #           The valid values are Minimum, Maximum, and Average. If the aggregation type is null, the value is treated as Average.
        #           This parameter is supported if the policy type is StepScaling.
        #         * 'MinAdjustmentMagnitude'<~String> - The minimum number of instances to scale.
        #           If the value of AdjustmentType is PercentChangeInCapacity,
        #           the scaling policy changes the DesiredCapacity of the Auto Scaling group by at least this many instances.
        #           Otherwise, the error is ValidationError.
        #           This parameter is supported if the policy type is SimpleScaling or StepScaling.
        #         * 'MinAdjustmentStep'<~String> - This parameter has been deprecated.
        #           Available for backward compatibility. Use MinAdjustmentMagnitude instead.
        #         * 'PolicyType'<~String> - The policy type. The valid values are SimpleScaling, StepScaling, and TargetTrackingScaling.
        #           If the policy type is null, the value is treated as SimpleScaling.
        #         * 'ScalingAdjustment'<~Integer> - The amount by which to scale, based on the specified adjustment type.
        #           A positive value adds to the current capacity while a negative number removes from the current capacity.
        #           This parameter is required if the policy type is SimpleScaling and not supported otherwise.
        #         * 'StepAdjustments'<~Array> - A set of adjustments that enable you to scale based on the size of the alarm breach.
        #           This parameter is required if the policy type is StepScaling and not supported otherwise.
        #           Each element of the array should be of type StepAdjustment:
        #             * 'stepAdjustment'<~Hash>:
        #               * 'MetricIntervalLowerBound'<~Float> - The lower bound for the difference between the alarm threshold
        #                 and the CloudWatch metric.
        #                 If the metric value is above the breach threshold, the lower bound is inclusive
        #                 (the metric must be greater than or equal to the threshold plus the lower bound).
        #                 Otherwise, it is exclusive (the metric must be greater than the threshold plus the lower bound).
        #                 A null value indicates negative infinity.
        #               * 'MetricIntervalUpperBound'<~Float> - The upper bound for the difference between the alarm threshold
        #                 and the CloudWatch metric. If the metric value is above the breach threshold,
        #                 the upper bound is exclusive (the metric must be less than the threshold plus the upper bound).
        #                 Otherwise, it is inclusive (the metric must be less than or equal to the threshold plus the upper bound).
        #                 A null value indicates positive infinity.
        #                 The upper bound must be greater than the lower bound.
        #               * 'ScalingAdjustment'<~Integer> - The amount by which to scale, based on the specified adjustment type.
        #                 A positive value adds to the current capacity while a negative number removes from the current capacity.
        #         * 'TargetTrackingConfiguration'<~Hash> - A target tracking policy configuration
        #           This parameter is required if the policy type is TargetTrackingScaling and not supported otherwise.
        #           * 'CustomizedMetricSpecification'<~Hash> - A customized metric.
        #             * 'MetricName'<~String> - The name of the metric
        #             * 'Namespace'<~String> - The namespace of the metric
        #             * 'Statistic'<~String> - The statistic of the metric.
        #             * 'Unit'<~String> - The unit of the metric
        #             * 'Dimensions'<~Array> - Array of metric dimension objects
        #               * 'metricDimension'<~Hash>:
        #                 * 'Value'<~String> - The value of the dimension
        #                 * 'Name'<~String> - The name of the dimension
        #           * 'DisableScaleIn'<~Boolean> - Indicates whether scale in by the target tracking policy is disabled.
        #             If scale in is disabled, the target tracking policy won't remove instances from the Auto Scaling group.
        #             Otherwise, the target tracking policy can remove instances from the Auto Scaling group.
        #             The default is disabled.
        #           * 'TargetValue'<~Float> - The target value for the metric
        #           * 'PredefinedMetricSpecification'<~Hash> - A predefined metric. You can specify either a predefined metric
        #             or a customized metric.
        #             * 'PredefinedMetricType'<~String> - The metric type.
        #             * 'ResourceLabel'<~String> - Identifies the resource associated with the metric type.
        #               Should be defined if predefined metric type is ALBRequestCountPerTarget
        #       * 'NextToken'<~String> - Acts as a paging mechanism for large
        #         result sets. Set to a non-empty string if there are
        #         additional results waiting to be returned. Pass this in to
        #         subsequent calls to return additional results.
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AutoScaling/latest/APIReference/API_DescribePolicies.html
        #
        def describe_policies(options = {})
          if policy_names = options.delete('PolicyNames')
            options.merge!(AWS.indexed_param('PolicyNames.member.%d', [*policy_names]))
          end
          if policy_types = options.delete('PolicyTypes')
            options.merge!(AWS.indexed_param('PolicyTypes.member.%d', [*policy_types]))
          end
          request({
            'Action' => 'DescribePolicies',
            :parser  => Fog::Parsers::AWS::AutoScaling::DescribePolicies.new
          }.merge!(options))
        end
      end

      class Mock
        def describe_policies(options = {})
          results = { 'ScalingPolicies' => [] }
          policy_set = self.data[:scaling_policies]

          for opt_key, opt_value in options
            if opt_key == 'PolicyNames' && opt_value != nil && opt_value != ''
              policy_set = policy_set.reject do |asp_name, _asp_data|
                ![*options['PolicyNames']].include?(asp_name)
              end
            elsif opt_key == 'PolicyTypes' && opt_value != nil && opt_value != ''
              policy_set = policy_set.reject do |asp_name, _asp_data|
                !([*options['PolicyTypes']] & %w(SimpleScaling StepScaling)).include?(asp_name)
              end
            elsif opt_key == 'AutoScalingGroupName' && opt_value != nil && opt_value != ''
              policy_set = policy_set.reject do |_asp_name, asp_data|
                options['AutoScalingGroupName'] != asp_data['AutoScalingGroupName']
              end
            end
          end

          policy_set.each do |asp_name, asp_data|
            results['ScalingPolicies'] << {
              'PolicyName' => asp_name,
              'Alarms'     => []
            }.merge!(asp_data)
          end
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'DescribePoliciesResult' => results,
            'ResponseMetadata' => { 'RequestId' => Fog::AWS::Mock.request_id }
          }
          response
        end
      end
    end
  end
end
