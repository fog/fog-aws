module Fog
  module AWS
    module RegionMethods
      def validate_aws_region(host, region)
        regions_list = %w(ap-northeast-1 ap-northeast-2 ap-southeast-1 ap-southeast-2 eu-west-1 us-east-1 us-east-2
                          us-west-1 us-west-2 sa-east-1 us-gov-west-1 eu-central-1 ap-south-1 ca-central-1)
        if host.end_with?('.amazonaws.com') && !regions_list.include?(region)
          raise ArgumentError, "Unknown region: #{region.inspect}"
        end
      end
    end
  end
end
