module Fog
  module AWS
    class AutoScaling
      class Real
        require 'fog/aws/parsers/auto_scaling/put_scaling_policy'

        # Creates or updates a policy for an Auto Scaling group. To update an
        # existing policy, use the existing policy name and set the
        # parameter(s) you want to change. Any existing parameter not changed
        # in an update to an existing policy is not changed in this update
        # request.
        #
        # ==== Parameters
        # * auto_scaling_group_name<~String> - The name or ARN of the Auto
        #   Scaling group.
        # * policy_name<~String> - The name of the policy you want to create or
        #   update.
        # * options<~Hash>:
        #   * 'Cooldown'<~Integer> - The amount of time, in seconds, after a
        #     scaling activity completes before any further trigger-related
        #     scaling activities can start
        #   * 'AdjustmentType'<~String> - The valid values are ChangeInCapacity, ExactCapacity, and PercentChangeInCapacity
        #     The param is supported by SimpleScaling and StepScaling policy types
        #   * 'EstimatedInstanceWarmup'<~Integer> - The estimated time, in seconds,
        #     until a newly launched instance can contribute to the CloudWatch metrics.
        #     The default is to use the value specified for the default cooldown period for the group.
        #     This parameter is supported if the policy type is StepScaling or TargetTrackingScaling.
        #   * 'MetricAggregationType'<~String> - The aggregation type for the CloudWatch metrics.
        #     The valid values are Minimum, Maximum, and Average. If the aggregation type is null, the value is treated as Average.
        #     This parameter is supported if the policy type is StepScaling.
        #   * 'MinAdjustmentMagnitude'<~String> - The minimum number of instances to scale.
        #     If the value of AdjustmentType is PercentChangeInCapacity,
        #     the scaling policy changes the DesiredCapacity of the Auto Scaling group by at least this many instances.
        #     Otherwise, the error is ValidationError.
        #     This parameter is supported if the policy type is SimpleScaling or StepScaling.
        #   * 'MinAdjustmentStep'<~String> - This parameter has been deprecated.
        #     Available for backward compatibility. Use MinAdjustmentMagnitude instead.
        #   * 'PolicyType'<~String> - The policy type. The valid values are SimpleScaling, StepScaling, and TargetTrackingScaling.
        #     If the policy type is null, the value is treated as SimpleScaling.
        #   * 'ScalingAdjustment'<~Integer> - The amount by which to scale, based on the specified adjustment type.
        #     A positive value adds to the current capacity while a negative number removes from the current capacity.
        #     This parameter is required if the policy type is SimpleScaling and not supported otherwise.
        #   * 'StepAdjustments'<~Array> - A set of adjustments that enable you to scale based on the size of the alarm breach.
        #     This parameter is required if the policy type is StepScaling and not supported otherwise.
        #     Each element of the array should be of type StepAdjustment:
        #       * 'stepAdjustment'<~Hash>:
        #         * 'MetricIntervalLowerBound'<~Float> - The lower bound for the difference between the alarm threshold
        #           and the CloudWatch metric.
        #           If the metric value is above the breach threshold, the lower bound is inclusive
        #           (the metric must be greater than or equal to the threshold plus the lower bound).
        #           Otherwise, it is exclusive (the metric must be greater than the threshold plus the lower bound).
        #           A null value indicates negative infinity.
        #         * 'MetricIntervalUpperBound'<~Float> - The upper bound for the difference between the alarm threshold
        #           and the CloudWatch metric. If the metric value is above the breach threshold,
        #           the upper bound is exclusive (the metric must be less than the threshold plus the upper bound).
        #           Otherwise, it is inclusive (the metric must be less than or equal to the threshold plus the upper bound).
        #           A null value indicates positive infinity.
        #           The upper bound must be greater than the lower bound.
        #         * 'ScalingAdjustment'<~Integer> - The amount by which to scale, based on the specified adjustment type.
        #           A positive value adds to the current capacity while a negative number removes from the current capacity.
        #   * 'TargetTrackingConfiguration'<~Hash> - A target tracking policy configuration
        #     This parameter is required if the policy type is TargetTrackingScaling and not supported otherwise.
        #     * 'CustomizedMetricSpecification'<~Hash> - A customized metric.
        #       * 'MetricName'<~String> - The name of the metric
        #       * 'Namespace'<~String> - The namespace of the metric
        #       * 'Statistic'<~String> - The statistic of the metric.
        #       * 'Unit'<~String> - The unit of the metric
        #       * 'Dimensions'<~Array> - Array of metric dimension objects
        #         * 'metricDimension'<~Hash>:
        #           * 'Value'<~String> - The value of the dimension
        #           * 'Name'<~String> - The name of the dimension
        #     * 'DisableScaleIn'<~Boolean> - Indicates whether scale in by the target tracking policy is disabled.
        #       If scale in is disabled, the target tracking policy won't remove instances from the Auto Scaling group.
        #       Otherwise, the target tracking policy can remove instances from the Auto Scaling group.
        #       The default is disabled.
        #     * 'TargetValue'<~Float> - The target value for the metric
        #     * 'PredefinedMetricSpecification'<~Hash> - A predefined metric. You can specify either a predefined metric
        #       or a customized metric.
        #       * 'PredefinedMetricType'<~String> - The metric type.
        #       * 'ResourceLabel'<~String> - Identifies the resource associated with the metric type.
        #         Should be defined if predefined metric type is ALBRequestCountPerTarget
        #
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'PutScalingPolicyResult'<~Hash>:
        #       * 'PolicyARN'<~String> - A policy's Amazon Resource Name (ARN).
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AutoScaling/latest/APIReference/API_PutScalingPolicy.html
        #
        def put_scaling_policy(auto_scaling_group_name, policy_name, options = {})
          if steps = options.delete('StepAdjustments')
            options.merge!(AWS.indexed_param('StepAdjustments.member.%d.MetricIntervalLowerBound', steps.map { |step| step['MetricIntervalLowerBound']}))
            options.merge!(AWS.indexed_param('StepAdjustments.member.%d.MetricIntervalUpperBound', steps.map { |step| step['MetricIntervalUpperBound']}))
            options.merge!(AWS.indexed_param('StepAdjustments.member.%d.ScalingAdjustment', steps.map { |step| step['ScalingAdjustment']}))
          end
          request({
            'Action'               => 'PutScalingPolicy',
            'AutoScalingGroupName' => auto_scaling_group_name,
            'PolicyName'           => policy_name,
            :parser                => Fog::Parsers::AWS::AutoScaling::PutScalingPolicy.new
          }.merge!(options))
        end
      end

      class Mock
        def put_scaling_policy(auto_scaling_group_name, policy_name, options = {})
          unless self.data[:auto_scaling_groups].key?(auto_scaling_group_name)
            raise Fog::AWS::AutoScaling::ValidationError.new('Auto Scaling Group name not found - null')
          end

          data = case options[:type]
                 when 'StepScaling'
                   data_for_step_policy
                 when 'TargetTrackingScaling'
                   data_for_target_policy
                 else
                   data_for_simple_policy
                 end
          data.merge!(common_data(auto_scaling_group_name, policy_name))
          self.data[:scaling_policies][policy_name] = data.merge!(options)

          response = Excon::Response.new
          response.status = 200
          response.body = {
            'ResponseMetadata' => { 'RequestId' => Fog::AWS::Mock.request_id }
          }
          response
        end

        private

        def common_data(group_name, policy_name)
          {
            'PolicyName'           => policy_name,
            'AutoScalingGroupName' => group_name,
            'PolicyARN'            => Fog::AWS::Mock.arn('autoscaling', self.data[:owner_id], "scalingPolicy:00000000-0000-0000-0000-000000000000:autoScalingGroupName/#{group_name}:policyName/#{policy_name}", self.region),
          }
        end

        def data_for_simple_policy
          {
            'AdjustmentType'         => 'ChangeInCapacity',
            'Cooldown'               => 0,
            'MinAdjustmentMagnitude' => 1,
            'ScalingAdjustment'      => 1
          }
        end

        def data_for_step_policy
          {
            'AdjustmentType'          => 'ChangeInCapacity',
            'EstimatedInstanceWarmup' => 0,
            'MinAdjustmentMagnitude'  => 1,
            'MetricAggregationType'   => 'Average',
            'StepAdjustments'         => [
              {
                'MetricIntervalLowerBound' => 0,
                'MetricIntervalUpperBound' => nil,
                'ScalingAdjustment'        => 1
              }
            ]
          }
        end

        def data_for_target_policy
          {
            'EstimatedInstanceWarmup'     => 0,
            'TargetTrackingConfiguration' => {
              'DisableScaleIn'                => false,
              'TargetValue'                   => 50,
              'PredefinedMetricSpecification' => {
                'PredefinedMetricType' => 'ASGAverageCPUUtilization'
              }
            }
          }
        end
      end
    end
  end
end
