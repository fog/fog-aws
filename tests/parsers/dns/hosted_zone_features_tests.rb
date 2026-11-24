require 'fog/xml'
require 'fog/aws/parsers/dns/list_hosted_zones'
require 'fog/aws/parsers/dns/get_hosted_zone'
require 'fog/aws/parsers/dns/create_hosted_zone'

HOSTED_ZONE_FEATURES = '<Features><AcceleratedRecoveryStatus>DISABLED</AcceleratedRecoveryStatus><ChangeHistory><Status>DISABLED</Status></ChangeHistory><ChangeGuardrails><ChangeGuardrail><Name>NS_OCCLUSION_CHECK</Name><Status>DISABLED</Status></ChangeGuardrail><ChangeGuardrail><Name>ACTIVE_DELEGATION_CHECK</Name><Status>DISABLED</Status></ChangeGuardrail></ChangeGuardrails></Features>'.freeze
HOSTED_ZONE_CONFIG = '<Config><Comment>a comment</Comment><PrivateZone>false</PrivateZone><HostedZoneTier>STANDARD</HostedZoneTier></Config>'.freeze

def hosted_zone_xml(features_first)
  fields = "<Id>/hostedzone/ZEXAMPLE</Id><Name>example.com.</Name><CallerReference>ref-1</CallerReference>#{HOSTED_ZONE_CONFIG}<ResourceRecordSetCount>3</ResourceRecordSetCount>"
  features_first ? "<HostedZone>#{HOSTED_ZONE_FEATURES}#{fields}</HostedZone>" : "<HostedZone>#{fields}#{HOSTED_ZONE_FEATURES}</HostedZone>"
end

def parse_dns(parser_class, xml)
  parser = Nokogiri::XML::SAX::Parser.new(parser_class.new)
  parser.parse(xml)
  parser.document.response
end

Shindo.tests('AWS::DNS | parsers | hosted zone Features', %w[aws dns parser]) do
  [false, true].each do |features_first|
    label = features_first ? 'Features before Name' : 'Features after Name'

    tests("list_hosted_zones (#{label})") do
      xml = %(<?xml version="1.0"?><ListHostedZonesResponse xmlns="https://route53.amazonaws.com/doc/2013-04-01/"><HostedZones>#{hosted_zone_xml(features_first)}</HostedZones><IsTruncated>false</IsTruncated><MaxItems>100</MaxItems></ListHostedZonesResponse>)
      response = parse_dns(Fog::Parsers::AWS::DNS::ListHostedZones, xml)
      zone = response['HostedZones'].first

      tests('Name').returns('example.com.') { zone['Name'] }
      tests('Id').returns('ZEXAMPLE') { zone['Id'] }
      tests('CallerReference').returns('ref-1') { zone['CallerReference'] }
      tests('Comment').returns('a comment') { zone['Comment'] }
      tests('PrivateZone').returns('false') { zone['PrivateZone'] }
      tests('ResourceRecordSetCount').returns(3) { zone['ResourceRecordSetCount'] }
      tests('MaxItems').returns(100) { response['MaxItems'] }
    end

    tests("get_hosted_zone (#{label})") do
      xml = %(<?xml version="1.0"?><GetHostedZoneResponse xmlns="https://route53.amazonaws.com/doc/2013-04-01/">#{hosted_zone_xml(features_first)}<DelegationSet><NameServers><NameServer>ns-1.example.net</NameServer></NameServers></DelegationSet></GetHostedZoneResponse>)
      response = parse_dns(Fog::Parsers::AWS::DNS::GetHostedZone, xml)
      zone = response['HostedZone']

      tests('Name').returns('example.com.') { zone['Name'] }
      tests('Id').returns('ZEXAMPLE') { zone['Id'] }
      tests('Comment').returns('a comment') { zone['Comment'] }
      tests('ResourceRecordSetCount').returns(3) { zone['ResourceRecordSetCount'] }
      tests('NameServers').returns(['ns-1.example.net']) { response['NameServers'] }
    end

    tests("create_hosted_zone (#{label})") do
      xml = %(<?xml version="1.0"?><CreateHostedZoneResponse xmlns="https://route53.amazonaws.com/doc/2013-04-01/">#{hosted_zone_xml(features_first)}<ChangeInfo><Id>/change/C1</Id><Status>PENDING</Status><SubmittedAt>2026-11-24T00:00:00Z</SubmittedAt></ChangeInfo><DelegationSet><NameServers><NameServer>ns-1.example.net</NameServer></NameServers></DelegationSet></CreateHostedZoneResponse>)
      response = parse_dns(Fog::Parsers::AWS::DNS::CreateHostedZone, xml)

      tests('Name').returns('example.com.') { response['HostedZone']['Name'] }
      tests('Id').returns('ZEXAMPLE') { response['HostedZone']['Id'] }
      tests('ChangeInfo Id').returns('C1') { response['ChangeInfo']['Id'] }
      tests('NameServers').returns(['ns-1.example.net']) { response['NameServers'] }
    end
  end
end
