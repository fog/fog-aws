module Fog
  module Compute
    class AWS
      class Real
        require 'fog/aws/parsers/compute/describe_spot_price_history'

        # Describe all or specified spot price history
        #
        # ==== Parameters
        # * filters<~Hash> - List of filters to limit results with
        #   * filters and/or the following
        #     * 'AvailabilityZone'<~String> - availability zone of offering
        #     * 'InstanceType'<~Array> - instance types of offering
        #     * 'ProductDescription'<~Array> - basic product descriptions
        #     * 'StartTime'<~Time> - The date and time, up to the past 90 days, from which to start retrieving the price history data
        #     * 'EndTime'<~Time> - The date and time, up to the current date, from which to stop retrieving the price history data
        #     * 'MaxResults'<~Integer> - The maximum number of results to return for the request in a single page
        #     * 'NextToken'<~String> - The token to retrieve the next page of results
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'spotPriceHistorySet'<~Array>:
        #       * 'availabilityZone'<~String> - availability zone for instance
        #       * 'instanceType'<~String> - the type of instance
        #       * 'productDescription'<~String> - general description of AMI
        #       * 'spotPrice'<~Float> - maximum price to launch one or more instances
        #       * 'timestamp'<~Time> - date and time of request creation
        #     * 'nextToken'<~String> - token to retrieve the next page of results
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-DescribeSpotPriceHistory.html]
        def describe_spot_price_history(filters = {})
          params = {}

          for key in %w(AvailabilityZone StartTime EndTime MaxResults NextToken)
            if filters.is_a?(Hash) && filters.key?(key)
              params[key] = filters.delete(key)
            end
          end

          if instance_types = filters.delete('InstanceType')
            params.merge!(Fog::AWS.indexed_param('InstanceType', [*instance_types]))
          end

          if product_descriptions = filters.delete('ProductDescription')
            params.merge!(Fog::AWS.indexed_param('ProductDescription', [*product_descriptions]))
          end

          params.merge!(Fog::AWS.indexed_filters(filters))

          request({
            'Action'    => 'DescribeSpotPriceHistory',
            :idempotent => true,
            :parser     => Fog::Parsers::Compute::AWS::DescribeSpotPriceHistory.new
          }.merge!(params))
        end
      end
    end
  end
end
