module Fog
  module AWS
    class ELBV2
      class Mock
        def self.default_lb_attributes
          {
            "access_logs.s3.prefix"         => nil,
            "access_logs.s3.bucket"         => nil,
            "access_logs.s3.enabled"        => false,
            "deletion_protection.enabled"   => false,
            "idle_timeout.timeout_seconds"  => 60
          }
        end
      end
    end
  end
end
