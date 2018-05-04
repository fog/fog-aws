module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/create_load_balancer'

        # Creates an Application Load Balancer.
        # http://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_CreateLoadBalancer.html
        #
        # ==== Parameters
        # * lb_name<~String> - Name for the new ELB -- must be unique
        #
        # ==== Optional parameters
        # * options<~Hash> - Options
        #   * :scheme<~String> - Scheme of the load balancer. Either "internal" or "internet-facing".
        #   * :ip_address_type<~String> - The type of IP addresses used by the subnets for the load balancer. The possible values are ipv4 (for IPv4 addresses) and dualstack (for IPv4 and IPv6 addresses). Internal load balancers must use ipv4.
        #   * :subnet_ids<~Array> - The IDs of the subnets to attach to the load balancer.
        #   * :security_group_ids<~Array> - The IDs of the security groups to assign to the load balancer.
        #   * :tags<~Hash> - Tags to assign to the load balancer.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'CreateLoadBalancerResult'<~Hash>:
        #       * 'LoadBalancers'<~Array>:
        #         * 'AvailabilityZones'<~Hash> - The Availability Zones for the load balancer.
        #         * 'CanonicalHostedZoneId'<~String> - The ID of the Amazon Route 53 hosted zone associated with the load balancer.
        #         * 'CreatedTime'<~String> - The date and time the load balancer was created.
        #         * 'DNSName'<~String> - The public DNS name of the load balancer.
        #         * 'IpAddressType'<~String> - The type of IP addresses used by the subnets for the load balancer.
        #         * 'LoadBalancerArn'<~String> - The Amazon Resource Name (ARN) of the load balancer.
        #         * 'LoadBalancerName'<~String> - The name of the load balancer.
        #         * 'Scheme'<~String> - Scheme of the load balancer.
        #         * 'SecurityGroups'<~Array> - The IDs of the security groups for the load balancer. Array of strings.
        #         * 'State'<~Hash> - The state of the load balancer.
        #           * 'Code'<~String> - The state code. Valid Values: "active", "provisioning", "failed"
        #           * 'Reason'<~String> - A description of the state.
        #         * 'Type'<~String> - The type of load balancer. The value is always "application".
        #         * 'VpcId'<~String> - The ID of the VPC for the load balancer.
        def create_load_balancer(lb_name, options = {})
          params = {}
          params.merge!(Fog::AWS.serialize_keys('Subnets', options[:subnet_ids])) if options[:subnet_ids]
          params.merge!(Fog::AWS.serialize_keys('SecurityGroups', options[:security_group_ids])) if options[:security_group_ids]

          if options[:tags]
            tags = options[:tags]
            params.merge!(Fog::AWS.serialize_keys('Tags', tags.map { |k, v| { 'Key' => k, 'Value' => v } }))
          end

          request({
            'Action'          => 'CreateLoadBalancer',
            'Name'            => lb_name,
            'Scheme'          => options[:scheme] || 'internet-facing',
            'IpAddressType'   => options[:ip_address_type] || 'ipv4',
            :parser           => Fog::Parsers::AWS::ELBV2::CreateLoadBalancer.new
          }.merge(params))
        end
      end

      class Mock
        require 'fog/aws/elbv2/default_lb_attributes'

        def create_load_balancer(lb_name, options = {})
          raise Fog::AWS::ELBV2::IdentifierTaken if self.data[:load_balancers].any? { |id, lb| lb['Name'] == lb_name }

          subnet_ids = options[:subnet_ids] || []

          raise Fog::AWS::ELBV2::ValidationError.new("You must specify subnets from at least two Availability Zones.") if subnet_ids.size < 2

          dns_name = Fog::AWS::ELBV2::Mock.dns_name(lb_name, @region)
          lb_id = Fog::AWS::Mock.arn('elasticloadbalancing', self.data[:owner_id], "loadbalancer/app/#{lb_name}", @region)

          subnets = Fog::Compute::AWS::Mock.data[region][@aws_access_key_id][:subnets].select {|e| subnet_ids.include?(e["subnetId"]) }

          region = Fog::Compute::AWS::Mock.data.keys.select do |region|
            subnets.any? { |subnet| subnet_ids.include?(subnet['subnetId']) }
          end.first
          region ||= 'us-east-1'

          availability_zones = subnets.inject({}) do |acc, sub|
            if acc[sub['availabilityZone']].nil?
              acc[sub['availabilityZone']] = [sub['subnetId']]
            else
              acc[sub['availabilityZone']] << sub['subnetId']
            end
            acc
          end
          
          vpc_id = subnets.first["vpcId"]

          default_sg = Fog::Compute::AWS::Mock.data[region][@aws_access_key_id][:security_groups].values.find { |sg|
            sg['groupName'] == 'default' && sg["vpcId"] == vpc_id
          }
          default_sg_group_ids = default_sg && [default_sg["groupId"]]

          canonical_hosted_zone_id = 'asdf'

          load_balancer_data = {
            'LoadBalancerArn' => lb_id,
            'LoadBalancerName' => lb_name,
            'Scheme' => options[:scheme] || 'internet-facing',
            'CreatedTime' => Time.now.strftime("%Y-%m-%dT%H:%M:%S%z"),
            'IpAddressType' => options[:ip_address_type] || 'ipv4',
            'AvailabilityZones' => availability_zones,
            'SecurityGroups' => options[:security_group_ids] || default_sg_group_ids,
            'CanonicalHostedZoneId' => canonical_hosted_zone_id,
            'DNSName' => dns_name,
            'VpcId' => vpc_id,
            'State' => { 'Code' => 'provisioning' },
            'Type' => 'application'
          }

          self.data[:load_balancers][lb_id] = load_balancer_data.merge(:attributes => Fog::AWS::ELBV2::Mock.default_lb_attributes)
          self.data[:tags][lb_id] = options[:tags] || {}

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'CreateLoadBalancerResult' => {
              'LoadBalancers' => [ load_balancer_data ]
            }
          }
          response
        end
      end
    end
  end
end
