module Fog
  module AWS
    class ELBV2
      class LoadBalancer < Fog::Model
        identity  :id,                        :aliases => 'LoadBalancerArn'
        attribute :availability_zones,        :aliases => 'AvailabilityZones'
        attribute :canonical_hosted_zone_id,  :aliases => 'CanonicalHostedZoneId'
        attribute :created_at,                :aliases => 'CreatedTime'
        attribute :dns_name,                  :aliases => 'DNSName'
        attribute :ip_address_type,           :aliases => 'IpAddressType'
        attribute :name,                      :aliases => 'LoadBalancerName'
        attribute :scheme,                    :aliases => 'Scheme'
        attribute :security_group_ids,        :aliases => 'SecurityGroups'
        attribute :state,                     :aliases => 'State'
        attribute :type,                      :aliases => 'Type'
        attribute :vpc_id,                    :aliases => 'VpcId'

        attribute :subnet_ids
        attribute :tags_set

        IP_ADDRESS_TYPES     = ['ipv4', 'dualstack']
        SCHEMES              = ['internet-facing', 'internal']
        LOAD_BALANCER_STATES = ['active', 'provisioning', 'failed']

        def state_code
          state['Code']
        end

        def state_reason
          state['Reason']
        end

        def active?
          state_code == 'active'
        end

        def provisioning?
          state_code == 'provisioning'
        end

        def failed?
          state_code == 'failed'
        end

        def tags
          requires :id
          resp = service.describe_tags(id)
          resp.body['DescribeTagsResult']["TagDescriptions"].first["Tags"]
        end

        def add_tags(new_tags)
          requires :id
          service.add_tags(id, new_tags)
          tags
        end

        def remove_tags(tag_keys)
          requires :id
          service.remove_tags(id, tag_keys)
          tags
        end

        def lb_attributes
          requires :id
          data = service.describe_load_balancer_attributes(id).body['DescribeLoadBalancerAttributesResult']
          data['Attributes']
        end

        def s3_asset_logs_prefix
          lb_attributes['access_logs.s3.prefix']
        end

        def s3_access_logs_bucket
          lb_attributes['access_logs.s3.bucket']
        end

        def s3_access_logs_enabled?
          lb_attributes['access_logs.s3.enabled']
        end

        def deletion_protection_enabled?
          lb_attributes['deletion_protection.enabled']
        end

        def idle_timeout
          lb_attributes['idle_timeout.timeout_seconds']
        end

        def idle_timeout=(timeout)
          service.modify_load_balancer_attributes(id, 'idle_timeout.timeout_seconds' => timeout)
        end

        def enable_deletion_protection
          service.modify_load_balancer_attributes(id, 'deletion_protection.enabled' => true)
        end

        def disable_deletion_protection
          service.modify_load_balancer_attributes(id, 'deletion_protection.enabled' => false)
        end

        def enable_s3_access_logs(bucket, prefix)
          service.modify_load_balancer_attributes(id, 'access_logs.s3.enabled' => true, 'access_logs.s3.bucket' => bucket, 'access_logs.s3.prefix' => prefix)
        end

        def disable_s3_access_logs
          service.modify_load_balancer_attributes(id, 'access_logs.s3.enabled' => false, 'access_logs.s3.bucket' => nil, 'access_logs.s3.prefix' => nil)
        end

        def set_ip_address_type(type)
          raise ArgumentError, "IpAddressType must be one of: #{IP_ADDRESS_TYPES.join(', ')}, got: #{type}" unless IP_ADDRESS_TYPES.include?(type)
          requires :id
          resp = service.set_ip_address_type(id, type)
          merge_attributes(:ip_address_type => resp.body['SetIpAddressTypeResult']['IpAddressType'])
        end

        def set_security_groups(security_groups)
          requires :id
          resp = service.set_security_groups(id, security_groups)
          merge_attributes(:security_group_ids => resp.body['SetSecurityGroupsResult']['SecurityGroups'])
        end

        def set_subnets(subnet_ids)
          requires :id
          resp = service.set_subnets(id, subnet_ids)
          merge_attributes(:availability_zones => resp.body['SetSubnetsResult']['AvailabilityZones'])
          merge_attributes(:subnet_ids => self.availability_zones.values.flatten)
        end

        def listeners
          requires :id
          Fog::AWS::ELBV2::Listeners.new(
            :service          => service,
            :load_balancer    => self
          )
        end

        def create_listener(port, default_target_group_id, protocol = 'HTTP', ssl_policy = nil, certificate_id = nil)
          listeners.create(
            :load_balancer_id => identity,
            :port => port,
            :default_actions => [{'TargetGroupArn' => default_target_group_id, 'Type' => 'forward'}],
            :procotol => protocol,
            :ssl_policy => ssl_policy,
            :certificates => certificate_id ? [{'CertificateArn' => certificate_id}] : []
          )
        end

        def target_groups
          requires :id
          Fog::AWS::ELBV2::TargetGroups.new(
            :service          => service,
            :load_balancer    => self
          )
        end

        def destroy
          requires :id
          service.delete_load_balancer(id)
        end

        def ready?
          # ELB requests are synchronous
          true
        end

        def save
          options = {
            :scheme => scheme,
            :ip_address_type => ip_address_type
          }
          options[:subnet_ids] = subnet_ids if subnet_ids && subnet_ids.any?
          options[:security_group_ids] = security_group_ids if security_group_ids && security_group_ids.any?
          options[:tags] = tags_set if tags_set && tags_set.any?
          resp = service.create_load_balancer(name, options)
          merge_attributes(resp.body['CreateLoadBalancerResult']['LoadBalancers'].first)
        end
      end
    end
  end
end
