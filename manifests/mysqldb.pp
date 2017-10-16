define grq::mysqldb ($user, $password, $admin_user, $admin_password, $sql_file="") {
  exec { "create-${name}-db":
    path => ["/bin", "/usr/bin"],
    unless => "mysql -u${admin_user} -p${admin_password} ${name}",
    command => "mysql -u${admin_user} -p${admin_password} -e \"create database ${name};\"",
    require => Service["mariadb"],
  }

  exec { "grant-${name}-db":
    path => ["/bin", "/usr/bin"],
    unless => "mysql -u${user} -p${password} ${name}",
    command => "mysql -u${admin_user} -p${admin_password} -e \"grant all on ${name}.* to ${user}@localhost identified by '$password';\"",
    require => [Service["mariadb"], Exec["create-${name}-db"]]
  }

  if $sql_file != "" {
    exec { "import-${name}-db":
      path    => ["/bin", "/usr/bin"],
      command => "mysql -u${admin_user} -p${admin_password} ${name} < ${sql_file}",
      require => [Service["mariadb"], Exec["create-${name}-db"]]
    }
  }
}
