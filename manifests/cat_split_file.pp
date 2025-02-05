define grq::cat_split_file($split_file=$title, $install_dir, $owner, $group) {

  # cat the split file parts
  exec { "cat $split_file.*":
    creates => "$install_dir/$split_file",
    path    => ["/bin", "/usr/bin"],
    command => "cat /etc/puppet/modules/grq/files/$split_file.* > $install_dir/$split_file",
  }
}
