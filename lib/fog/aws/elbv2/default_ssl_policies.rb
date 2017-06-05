module Fog
  module AWS
    class ELBV2
      class Mock
        def self.default_ssl_policies
          Fog::JSON.decode(File.read(File.expand_path("../default_ssl_policies.json", __FILE__)))
        end
      end
    end
  end
end
