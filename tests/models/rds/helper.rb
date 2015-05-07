def rds_default_server_params
  {
    :allocated_storage       => 5,
    :backup_retention_period => 0,
    :engine                  => 'mysql',
    :version                 => '5.6.22',
    :id                      => uniq_id,
    :master_username         => 'foguser',
    :password                => 'fogpassword',
    :flavor_id               => 'db.m3.medium',
  }
end
