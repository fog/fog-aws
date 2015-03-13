Shindo.tests('Fog::DNS[:aws] | change_resource_record_sets', ['aws', 'dns']) do
  @r53_connection = Fog::DNS[:aws]

  tests('success') do
    test('#elb_hosted_zone_mapping from DNS name') do
      zone_id = Fog::DNS::AWS.hosted_zone_for_alias_target('arbitrary-sub-domain.eu-west-1.elb.amazonaws.com')
      zone_id == Fog::DNS::AWS.elb_hosted_zone_mapping['eu-west-1']
    end
  end
end
