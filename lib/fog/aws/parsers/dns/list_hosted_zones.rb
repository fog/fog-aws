module Fog
  module Parsers
    module AWS
      module DNS
        class ListHostedZones < Fog::Parsers::Base
          def reset
            @hosted_zones = []
            @zone = {}
            @response = {}
            @path = []
          end

          def start_element(name, attrs = [])
            super
            @path << name
          end

          def end_element(name)
            @path.pop
            # Route 53 nests other structures inside <HostedZone> (e.g.
            # <Features><ChangeGuardrails><ChangeGuardrail><Name>), so ignore anything
            # that is not a direct child of <HostedZone> or <Config>.
            return if @path.include?('HostedZone') && !%w[HostedZone Config].include?(@path.last)

            case name
            when 'Id'
              @zone[name] = value.sub('/hostedzone/', '')
            when 'Name', 'CallerReference', 'Comment', 'PrivateZone'
              @zone[name] = value
            when 'ResourceRecordSetCount'
              @zone['ResourceRecordSetCount'] = value.to_i
            when 'HostedZone'
              @hosted_zones << @zone
              @zone = {}
            when 'HostedZones'
              @response['HostedZones'] = @hosted_zones
            when 'MaxItems'
              @response[name] = value.to_i
            when 'IsTruncated', 'Marker', 'NextMarker'
              @response[name] = value
            end
          end
        end
      end
    end
  end
end
