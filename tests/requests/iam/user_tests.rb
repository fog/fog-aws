Shindo.tests('AWS::IAM | user requests', ['aws']) do

  begin
    Fog::AWS[:iam].delete_group('fog_user_tests')
  rescue Fog::AWS::IAM::NotFound
  end

  begin
    Fog::AWS[:iam].delete_user('fog_user').body
  rescue Fog::AWS::IAM::NotFound
  end

  Fog::AWS[:iam].create_group('fog_user_tests')


  tests("#create_user('fog_user')").data_matches_schema(AWS::IAM::Formats::CREATE_USER) do
    Fog::AWS[:iam].create_user('fog_user').body
  end

  tests("#list_users").data_matches_schema(AWS::IAM::Formats::LIST_USER) do
    Fog::AWS[:iam].list_users.body
  end

  tests("#get_user('fog_user')").data_matches_schema(AWS::IAM::Formats::GET_USER) do
    Fog::AWS[:iam].get_user('fog_user').body
  end

  tests("#get_user").data_matches_schema(AWS::IAM::Formats::GET_CURRENT_USER) do
    Fog::AWS[:iam].get_user.body
  end

  tests("#add_user_to_group('fog_user_tests', 'fog_user')").data_matches_schema(AWS::IAM::Formats::BASIC) do
    Fog::AWS[:iam].add_user_to_group('fog_user_tests', 'fog_user').body
  end

  tests("#list_groups_for_user('fog_user')").data_matches_schema(AWS::IAM::Formats::GROUPS) do
    Fog::AWS[:iam].list_groups_for_user('fog_user').body
  end

  tests("#remove_user_from_group('fog_user_tests', 'fog_user')").data_matches_schema(AWS::IAM::Formats::BASIC) do
    Fog::AWS[:iam].remove_user_from_group('fog_user_tests', 'fog_user').body
  end

  tests("#delete_user('fog_user')").data_matches_schema(AWS::IAM::Formats::BASIC) do
    Fog::AWS[:iam].delete_user('fog_user').body
  end

  Fog::AWS[:iam].delete_group('fog_user_tests')

end
