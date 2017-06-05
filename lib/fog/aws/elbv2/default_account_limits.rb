module Fog
  module AWS
    class ELBV2
      class Mock
        def self.default_account_limits
          {
            "application-load-balancers"              => 20,
            "target-groups"                           => 200,
            "targets-per-application-load-balancer"   => 1000,
            "listeners-per-application-load-balancer" => 10,
            "rules-per-application-load-balancer"     => 100
          }
        end
      end
    end
  end
end
