Shindo.tests("AWS::RDS | servers", ['aws', 'rds']) do

  collection_tests(Fog::AWS[:rds].servers, rds_default_server_params) do
    @instance.wait_for { ready? }
  end

  tests("#restore").succeeds do
    instance_id = uniq_id("fog-snapshot-test")
    instance = Fog::AWS[:rds].servers.create(rds_default_server_params.merge(:id => instance_id))
    instance.wait_for { ready? }

    snapshot_id = uniq_id('fog-snapshot-test')
    @snapshot = instance.snapshots.create(:id => snapshot_id )
    instance.destroy

    db_name = uniq_id('fog-db-name')
    @restored_from_snapshot_instance = Fog::AWS[:rds].servers.restore('source_snapshot_id' => snapshot_id, 'id' => db_name, 'flavor_id' => 'db.m3.medium')

    db_name = uniq_id('fog-db-name')
    @restored_from_pit_instance = Fog::AWS[:rds].servers.restore('use_latest_restorable_time' => true, 'id' => db_name, 'source_db_name' => instance.id, flavor_id => 'db.m3.medium')
  end

  if Fog.mocking? && @restored_from_snapshot_instance.respond_to?(:ready?)
    @restored_from_snapshot_instance.wait_for { ready? }
  end

  @snapshot.destroy
  @restored_from_snapshot_instance.destroy
end
