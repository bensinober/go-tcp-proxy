# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.box = "dduportal/boot2docker"
  config.vm.network :forwarded_port, guest: 9999, host: 9999
  config.vm.provision :docker do |d|

    # BUILD APP
    d.build_image "/vagrant",
      args: "-t digibib/build -f /vagrant/Dockerfile.build"

    # COPY COMPILED APP
    d.run "builder",
      image: "digibib/build",
      daemonize: false,
      args: "--rm -v /vagrant/build:/app",
      cmd: "cp cmd/tcp-proxy/tcp-proxy /app"
  end

  config.vm.provision :docker do |d|
    # BUILD MINIMAL DOCKER IMAGE WITH COMPILED APP
    d.build_image "/vagrant",
      args: "-t digibib/tcp-proxy -f /vagrant/Dockerfile"

    # RUN APP IN CONTAINER
    d.run "tcp-proxy",
      image: "digibib/tcp-proxy"
  
  end

end