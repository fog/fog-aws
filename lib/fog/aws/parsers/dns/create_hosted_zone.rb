module Fog
  module Parsers
    module AWS
      module DNS
        class CreateHostedZone < Fog::Parsers::Base
          def reset
            @hosted_zone = {}
            @change_info = {}
            @name_servers = []
            @response = {}
            @path = []
            @section = :hosted_zone
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
                @hosted_zone[name] = value.sub('/hostedzone/', '')
              when 'Name', 'CallerReference', 'Comment', 'PrivateZone'
                @hosted_zone[name]= value
              when 'HostedZone'
                @response['HostedZone'] = @hosted_zone
                @hosted_zone = {}
                @section = :change_info
              end
            elsif @section == :change_info
              case name
              when 'Id'
                @change_info[name]= value.sub('/change/', '')
              when 'Status', 'SubmittedAt'
                @change_info[name] = value
              when 'ChangeInfo'
                @response['ChangeInfo'] = @change_info
                @change_info = {}
                @section = :name_servers
              end
            elsif @section == :name_servers
              case name
              when 'NameServer'
                @name_servers << value
              when 'NameServers'
                @response['NameServers'] = @name_servers
                @name_servers = {}
              end
            end
          end
        end
      end
    end
  end
end
