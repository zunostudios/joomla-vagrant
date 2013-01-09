require '/tmp/vagrant/config.rb'

name 'default'
description 'Default server for Joomlatools development.'

run_list %w(
  recipe[apt]
  recipe[mysql::server]
  recipe[php]
  recipe[php-custom]
  recipe[apache2]
  recipe[apache2::mod_php5]
  recipe[apache2-custom]
)

attributes = {
  :mysql => {
    :bind_address => '0.0.0.0',
    :allow_remote_root => true,
    :server_root_password => 'root',
    :server_repl_password => 'root',
    :server_debian_password => 'root'
  },
  :php => {
    :directives => {
      :display_errors => 'On'
    },
    :xdebug => {
      :directives => {
        :remote_autostart => 1,
        :remote_enable => 1,
        :remote_host => '192.168.51.10',
        :remote_port => 9001
      }
    }
  }
}

# Load custom configuration file
v_config = parse_vagrant_config

if v_config.has_key?('hosts')
  attributes[:apache] = {
    :sites => v_config['hosts']
  }
end

override_attributes(attributes)