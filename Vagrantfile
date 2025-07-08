# -*- mode: ruby -*-
# vi: set ft=ruby :

machines = {
  "master" => {"memory" => "1024", "cpu" => "1", "ip" => "100", "image" => "generic/ubuntu2204"},
  "node01" => {"memory" => "1024", "cpu" => "1", "ip" => "101", "image" => "generic/ubuntu2204"},
  "node02" => {"memory" => "1024", "cpu" => "1", "ip" => "102", "image" => "generic/ubuntu2204"}
}

Vagrant.configure("2") do |config|

  machines.each do |name, conf|
    config.vm.define "#{name}" do |machine|
      # Note: 'generic/ubuntu2204' is generally better for Hyper-V
      # than 'bento/ubuntu-22.04' as bento boxes are often VirtualBox specific.
      machine.vm.box = "#{conf["image"]}"
      machine.vm.hostname = "#{name}"

      # For Hyper-V, 'private_network' typically maps to an internal or private virtual switch.
      # You need to ensure a virtual switch named "VagrantPrivateSwitch" (or whatever you choose)
      # exists in Hyper-V Manager and is configured as "Internal" or "Private".
      machine.vm.network "private_network",
        ip: "10.10.10.#{conf["ip"]}",
        # REQUIRED: You MUST create a Virtual Switch in Hyper-V Manager with this name
        # and configure it as "Internal" or "Private".
        virtual_switch_name: "VagrantPrivateSwitch"

      machine.vm.provider "hyperv" do |hv|
        hv.vmname = "#{name}"
        # It's recommended to use integers for memory and cpu, not strings.
        hv.memory = conf["memory"].to_i
        hv.cpus = conf["cpu"].to_i
        # Optional: You might want to enable dynamic memory if your use case allows it.
        # hv.dynamic_memory = true
        # hv.maxmemory = 4096 # Example for max memory with dynamic memory
      end

      # Provisioning scripts remain the same
      machine.vm.provision "shell", path: "docker.sh"

      if "#{name}" == "master"
        machine.vm.provision "shell", path: "master.sh"
      else
        machine.vm.provision "shell", path: "worker.sh"
      end

    end
  end
end