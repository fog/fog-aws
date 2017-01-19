include AWS::IAM::Formats

Shindo.tests("AWS::IAM | instance profile requests", ['aws']) do
  tests('success') do
    profile_name = uniq_id('fog-instance-profile')
    tests("#create_instance_profile('#{profile_name}')").formats(INSTANCE_PROFILE_RESULT) do
      Fog::AWS[:iam].create_instance_profile(profile_name).body
    end

    tests("#get_instance_profile('#{profile_name}')").formats(INSTANCE_PROFILE_RESULT) do
      Fog::AWS[:iam].get_instance_profile(profile_name).body
    end

    @role = Fog::AWS[:iam].roles.create(:rolename => uniq_id('instance-profile-role'))

    tests("#add_role_to_instance_profile('#{@role.rolename}', '#{profile_name}')").formats(BASIC) do
      Fog::AWS[:iam].add_role_to_instance_profile(@role.rolename, profile_name).body
    end

    tests("#remove_role_from_instance_profile('#{@role.rolename}', '#{profile_name}')").formats(BASIC) do
      Fog::AWS[:iam].remove_role_from_instance_profile(@role.rolename, profile_name).body
    end

    @role.destroy

    tests("#delete_instance_profile('#{profile_name}')").formats(BASIC) do
      Fog::AWS[:iam].delete_instance_profile(profile_name).body
    end
  end
end
