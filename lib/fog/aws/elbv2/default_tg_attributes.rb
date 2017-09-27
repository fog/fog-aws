module Fog
  module AWS
    class ELBV2
      class Mock
        def self.default_tg_attributes
          {
            "stickiness.enabled"                    => false,
            "deregistration_delay.timeout_seconds"  => 300,
            "stickiness.type"                       => "lb_cookie",
            "stickiness.lb_cookie.duration_seconds" => 86400
          }
        end
      end
    end
  end
end
