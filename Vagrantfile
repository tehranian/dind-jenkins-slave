Vagrant.configure(2) do |config|

    config.vm.define "jenkins-master" do |jenkins|
        jenkins.vm.box = "phusion/ubuntu-14.04-amd64"
        jenkins.vm.network "forwarded_port", guest: 8080, host: 8082
        jenkins.vm.provider "virtualbox" do |vb|
            vb.memory = "1024"
        end
        jenkins.vm.network "private_network", ip: '192.168.33.2'
        jenkins.vm.host_name = "jenkins.vagrant"
        jenkins.vm.provision "shell", inline: <<-SHELL
            wget -q -O - http://pkg.jenkins-ci.org/debian-stable/jenkins-ci.org.key | sudo apt-key add -
            sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
            sudo apt-get update
            sudo apt-get install -y jenkins
            sudo service jenkins start
        SHELL
    end

    config.vm.define "docker-slave" do |slave|
        slave.vm.box = "phusion/ubuntu-14.04-amd64"
        slave.vm.provider "virtualbox" do |vb|
            vb.memory = "1024"
        end
        slave.vm.network "private_network", ip: '192.168.33.3'
        slave.vm.host_name = "docker-slave.vagrant"
        slave.vm.provision "shell", inline: <<-SHELL
            echo deb https://get.docker.com/ubuntu docker main | \
                sudo tee /etc/apt/sources.list.d/docker.list
            sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 \
                --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
            sudo apt-get update
            sudo apt-get install -y lxc-docker
            sudo usermod -aG docker vagrant
            echo "DOCKER_OPTS='-H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock'" | \
                sudo tee /etc/default/docker
            sudo service docker restart
        SHELL
    end
end
