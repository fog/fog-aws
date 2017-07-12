module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/describe_load_balancers'

        # Describe all or specified load balancers
        #
        # ==== Parameters
        # * ids<~Array> - List of load balancer ARNs to describe, defaults to all.
        # * options<~Hash>
        #   * :names<~Array> - List of load balancer names to describe, defaults to all.
        #   * :marker<String> - Indicates where to begin in your list of load balancers
        #   * :page_size<~Integer> - The maximum number of results to return with this call. Range is 1...400.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'DescribeLoadBalancersResult'<~Hash>:
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
        #     * 'NextMarker'<~String> - Marker to specify for next page
        def describe_load_balancers(ids = [], options = {})
          ids = [*ids]
          params = {}
          params['Marker'] = options[:marker] if options[:marker]
          params['PageSize'] = options[:page_size] if options[:page_size]
          params.merge!(Fog::AWS.serialize_keys('LoadBalancerArns', ids)) if ids.any?
          params.merge!(Fog::AWS.serialize_keys('Names', options[:names])) if options[:names]
          request({
            'Action'  => 'DescribeLoadBalancers',
            :parser   => Fog::Parsers::AWS::ELBV2::DescribeLoadBalancers.new
          }.merge!(params))
        end
      end

      class Mock
        def describe_load_balancers(ids = [], options = {})
          ids = [*ids]
          load_balancers = self.data[:load_balancers]
          load_balancers = ids.any? ? load_balancers.values_at(*ids) : load_balancers.values
          load_balancers = load_balancers.select do |lb|
            options[:names].include?(lb['LoadBalancerName'])
          end if options[:names]

          marker = options.fetch('Marker', 0).to_i
          if load_balancers.count - marker > 400
            next_marker = marker + 400
            load_balancers = load_balancers[marker...next_marker]
          else
            next_marker = nil
          end

          load_balancers = load_balancers.map { |lb|
            raise Fog::AWS::ELBV2::NotFound unless lb
            h = lb.dup
            h.delete(:attributes)
            h
          }

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'DescribeLoadBalancersResult' => {
              'LoadBalancers' => load_balancers
            }
          }

          if next_marker
            response.body['DescribeLoadBalancersResult']['NextMarker'] = next_marker.to_s
          end

          response
        end
      end
    end
  end
end
