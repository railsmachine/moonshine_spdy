require 'pathname'

module Spdy
  def self.included(manifest)
    manifest.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods
    def spdy_configuration
      configuration[:spdy][rails_env.to_sym]
    end

    def spdy_template_dir
      @spdy_template_dir ||= Pathname.new(__FILE__).dirname.dirname.join('templates')
    end
  end

  # Define options for this plugin via the <tt>configure</tt> method
  # in your application manifest:
  #
  #   configure(:spdy => {:foo => true})
  #
  # Then include the plugin and call the recipe(s) you need:
  #
  #  recipe :spdy
  def spdy
    configure(
      :spdy => {
        :enabled => true,
        :inherit_vhost_config => true,
        :cache_path => '/var/mod_spdy/cache/',
        :log_path => '/var/log/spdy',
        :file_prefix => '/var/mod_spdy/files/',
        :enabled_filters => [],
        :disabled_filters => [],
        :forbid_filters => [],
        :extra_domains => []
      }
    )
    # dependencies for install
    package 'wget',                 :ensure => :installed
    package "apache2-threaded-dev", :ensure => :installed

    file "/usr/local/src",          :ensure => :directory

    arch = Facter.value(:architecture)
    if arch == "x86_64"
      arch = "amd64"
    end

    url = "https://dl-ssl.google.com/dl/linux/direct/mod-spdy-beta_current_#{arch}.deb"

    exec 'download_spdy',
      :command => "wget #{url}",
      :cwd => "/usr/local/src",
      :unless => "test -f /usr/local/src/mod-spdy-beta_current_#{arch}.deb"

    exec 'install_spdy',
      :command => [
        "dpkg --force-confold -i mod-spdy-beta_current_#{arch}.deb",
        "apt-get -f install"
      ].join(' && '),
      :cwd => "/usr/local/src",
      :require => [
        package('wget'),
        package("apache2-mpm-worker"),
        package("apache2-threaded-dev"),
        exec('download_spdy')
      ],
      :unless => "dpkg -s mod-spdy-beta"

#    file "/etc/apache2/mods-available/spdy.conf",
#      :ensure => :present,
#      :content => template(File.join(File.dirname(__FILE__), '..', 'templates', 'spdy.conf.erb')),
#      :require => [ exec('install_spdy') ],
#      :notify => service('apache2'),
#      :alias => "spdy_conf"

    # a2enmod 'spdy', :require => [ exec('install_spdy'), file('spdy_conf') ]
    a2enmod 'spdy', :require => [ exec('install_spdy') ]
  end
end
