module Fog
  module Parsers
    module AWS
      module DNS
        class GetHostedZone < Fog::Parsers::Base
          def reset
            @hosted_zone = {}
            @name_servers = []
            @response = {}
            @path = []
            @section = :hosted_zone
            @vpcs = []
            @vpc = {}
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

            if @section == :hosted_zone
              case name
              when 'Id'
                @hosted_zone[name]= value.sub('/hostedzone/', '')
              when 'Name', 'CallerReference', 'Comment', 'PrivateZone', 'Config'
                @hosted_zone[name]= value
              when 'ResourceRecordSetCount'
                @hosted_zone['ResourceRecordSetCount'] = value.to_i
              when 'HostedZone'
                @response['HostedZone'] = @hosted_zone
                @hosted_zone = {}
                @section = :name_servers
              end
            elsif @section == :name_servers
              case name
              when 'NameServer'
                @name_servers << value
              when 'NameServers'
                @response['NameServers'] = @name_servers
                @name_servers = {}
              when 'VPCId', 'VPCRegion'
                @vpc[name] = value
              when 'VPC'
                @vpcs << @vpc
                @vpc = {}
              when 'VPCs'
                @response['HostedZone']['VPCs'] = @vpcs
                @vpcs = {}
                @section = :vpcs
              end
            end
          end
        end
      end
    end
  end
end
