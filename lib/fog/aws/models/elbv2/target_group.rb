module Fog
  module AWS
    class ELBV2
      class TargetGroup < Fog::Model
        identity  :id,                              :aliases => 'TargetGroupArn'
        attribute :name,                            :aliases => 'TargetGroupName'
        attribute :protocol,                        :aliases => 'Protocol'
        attribute :port,                            :aliases => 'Port'
        attribute :vpc_id,                          :aliases => 'VpcId'
        attribute :matcher,                         :aliases => 'Matcher.HttpCode'
        attribute :health_check_interval_seconds,   :aliases => 'HealthCheckIntervalSeconds'
        attribute :health_check_path,               :aliases => 'HealthCheckPath'
        attribute :health_check_port,               :aliases => 'HealthCheckPort'
        attribute :health_check_protocol,           :aliases => 'HealthCheckProtocol'
        attribute :health_check_timeout_seconds,    :aliases => 'HealthCheckTimeoutSeconds'
        attribute :healthy_threshold_count,         :aliases => 'HealthyThresholdCount'
        attribute :unhealthy_threshold_count,       :aliases => 'UnhealthyThresholdCount'
        attribute :load_balancer_arns,              :aliases => 'LoadBalancerArns'
        attribute :target_type,                     :aliases => 'TargetType'

        def register_targets(targets = [], targets_by_port = {})
          requires :id
          service.register_targets(id, targets, targets_by_port)
        end

        def deregister_targets(targets)
          requires :id
          service.deregister_targets(id, targets)
        end

        def targets(target_ids = [])
          requires :id
          service.describe_target_health(id, target_ids)
        end

        def tg_attributes
          requires :id
          service.describe_target_group_attributes(id).body['DescribeTargetGroupAttributesResult']['Attributes']
        end

        def tg_attributes=(attributes)
          pairs = attributes.map { |k, v| { 'Key' => k, 'Value' => v } }
          resp = service.modify_target_group_attributes(id, pairs)
          merge_attributes resp.body['ModifyTargetGroupAttributesResult']['Attributes']
        end

        def stickiness_enabled?
          tg_attributes['stickiness.enabled']
        end

        def stickiness_type # is always "lb_cookie"
          tg_attributes['stickiness.type']
        end

        def stickiness_duration
          tg_attributes['stickiness.lb_cookie.duration_seconds']
        end

        def deregistration_delay_timeout
          tg_attributes['deregistration_delay.timeout_seconds']
        end

        def enable_stickiness(duration = 86400)
          self.tg_attributes = {
            'stickiness.enabled' => true,
            'stickiness.lb_cookie.duration_seconds' => duration,
            'stickiness.type' => 'lb_cookie'
          }
        end

        def disable_stickiness
          self.tg_attributes = {'stickiness.enabled' => false}
        end

        def deregistration_delay_timeout=(timeout)
          self.tg_attributes = {'deregistration_delay.timeout_seconds' => timeout}
        end

        def target_health(target_ids = [])
          Fog::AWS::ELBV2::TargetHealthDescriptions.new(
            :service       => service,
            :target_group  => self,
            :target_ids    => target_ids
          )
        end

        def update(attributes)
          requires :id
          merge_attributes(attributes)
          resp = service.modify_target_group(id, self.attributes)
          merge_attributes resp.body['ModifyTargetGroupResult']['TargetGroups'].first
        end

        def save
          options = {
            :matcher => matcher,
            :healthy_threshold_count => healthy_threshold_count,
            :unhealthy_threshold_count => unhealthy_threshold_count,
            :health_check_interval_seconds => health_check_interval_seconds,
            :health_check_path => health_check_path,
            :health_check_port => health_check_port,
            :health_check_protocol => health_check_protocol,
            :health_check_timeout_seconds => health_check_timeout_seconds,
            :target_type => target_type
          }
          options.delete_if { |k, v| v.nil? }
          resp = service.create_target_group(name, port, vpc_id, options)
          merge_attributes(resp.body['CreateTargetGroupResult']['TargetGroups'].first)
        end

        def destroy
          service.delete_target_group(id)
        end
      end
    end
  end
end
