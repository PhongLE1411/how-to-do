# How to run docker on Windows without Docker Desktop
##### Table of Contents 
  [1. Why Isn't Docker Desktop Used](#1-why-not-docker-desktop-used)
  [2. Prerequisites](#2-prerequisites)
  [3. Setup WSL2](#3-setup-wsl2)
  [4. Setup Docker on Ubuntu](#4-setup-docker-on-ubuntu)
  [5. How to run "docker commands" on Windows](#5-how-to-run-docker-commands-on-windows)
  [6. Configure VSCode to access to WSL2 docker](#6-configure-vscode-to-access-to-wsl2-docker)
  [7. Making everything works without knowing IP](#7-making-everything-works-without-knowing-ip)

## 1. Why Not Docker Desktop
Since Docker announced a new subscription for Docker Desktop for personal use, educational institutions, non-commercial open-source projects and small businesses, other enterprises need to acquire licences for all installations of Docker Desktop.

Docker Desktop is licensed under the Docker Subscription Service Agreement. When you download and install Docker Desktop, you will be asked to agree to the updated terms.

Our Docker Subscription Service Agreement states:

- Docker Desktop is free for small businesses (fewer than 250 employees AND less than $10 million in annual revenue), personal use, education, and non-commercial open source projects.
- Otherwise, it requires a paid subscription for professional use.
- Paid subscriptions are also required for government entities.
- The Docker Pro, Team, and Business subscriptions include commercial use of Docker Desktop.

## 2. Prerequisites
Before you install the Docker Desktop WSL 2 backend, you must complete the following steps:

1. Automaticaly instalation by using "wsl --install".
  - Windows OS must be Windows 10, version 1903 or higher or Windows 11.
    > [System.Environment]::OSVersion.Version

    ![OS version](https://github.com/PhongLE1411/how-to-do/blob/main/resources/prerequisties.png)
3. Manually installation
  - Enable WSL 2 feature on Windows. For detailed instructions, refer to the [Microsoft documentation](https://docs.microsoft.com/en-us/windows/wsl/install-win10).
  - Download and install the [Linux kernel update package](https://docs.microsoft.com/windows/wsl/wsl2-kernel).

## 3. Install WSL2
### 3.1  On Windows 10, version 1903 or higher or Windows 11
  1- Open Start on Windows

  2- Search for Command Prompt, right-click the top result, and select the Run as administrator option.

  3- If your Windows version is lower Windows 10, version 1903, you should turn on some Windows features and set WSL version to version 2

  Enable the Windows Subsystem for Linux

  > dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

  ![Enable the Windows Subsystem for Linux](https://github.com/PhongLE1411/how-to-do/blob/main/resources/wsl-install-manual-enable-feature-Windows-Subsystem-Linux.png)
  
  ![Enable the Windows Subsystem for Linux](https://github.com/PhongLE1411/how-to-do/blob/main/resources/wsl-install-manual-enable-feature-Windows-Subsystem-Linux-02.png)
  

  Enable Virtual Machine feature

  > dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

  ![VirtualMachinePlatform](https://github.com/PhongLE1411/how-to-do/blob/main/resources/wsl-install-manual-enable-feature-VirtualMachinePlatform.png)
  
  ![VirtualMachinePlatform](https://github.com/PhongLE1411/how-to-do/blob/main/resources/wsl-install-manual-enable-feature-VirtualMachinePlatform-02.png)

  Set WSL version to version 2 (Make sure WSL is version 2)

  > Wsl --set-default-version 2

4- Type the following command to install the WSL and press Enter:
  > wsl --install

The --install command performs the following actions:

  - Enables the optional WSL and Virtual Machine Platform components
  - Downloads and installs the latest Linux kernel
  - Sets WSL 2 as the default
  - Downloads and installs the Ubuntu Linux distribution (reboot may be required)

This command will enable the features necessary to run WSL and install the Ubuntu distribution of Linux. (This default distribution can be changed https://learn.microsoft.com/en-us/windows/wsl/basic-commands#install-a-specific-linux-distribution)

View available distro list: 
> wsl --list --online

> **_NOTE:_**  The above command only works if WSL is not installed at all, if you run wsl --install and see the WSL help text, please try running wsl --list --online to see a list of available distros and run wsl --install -d <DistroName> to install a distro.
![WSL2 Installation auto](https://github.com/PhongLE1411/how-to-do/blob/main/resources/wsl-install-auto.png)

You will need to restart your machine during this installation process.
Once the process of installing your Linux distribution with WSL is complete, open the distribution (Ubuntu by default) using the Start menu. You will be asked to create a User Name and Password for your Linux distribution.


![WSL2 Installation](https://github.com/PhongLE1411/how-to-do/blob/main/resources/wsl-install-auto-user.png)

### 3.2 Update & Update packages
> sudo apt update && sudo apt upgrade
Continue with [Y]

Check wsl version

> wsl --list --verbose
## 4. Setup Docker on Ubuntu
Run wsl -e sh "install-docker.sh" file by wsl from Windows terminal. You are able to run line by line the script in the file.

Continue with [Y]

![Setup Docker on Ubuntu](https://github.com/PhongLE1411/how-to-do/blob/main/resources/docker-install-start.png)

![Setup Docker on Ubuntu](https://github.com/PhongLE1411/how-to-do/blob/main/resources/docker-install-finish.png)

- Check docker info: 
> docker info

If you get the error, please try start docker (*sudo service docker start*) then checking again.

![docker info](https://github.com/PhongLE1411/how-to-do/blob/main/resources/docker-checking.png)

## 5. How to run "docker commands" on Windows via WSL
### 5.1 Run on Ubuntu
To use directly the Distro commands:

1- Open the Distro from Start

  ![Distro from Start](https://github.com/PhongLE1411/how-to-do/blob/main/resources/run-docker-from-01.png)

  ![Distro from Start](https://github.com/PhongLE1411/how-to-do/blob/main/resources/run-docker-from-01-02.png)

2- Navigate Distro via WSL

  Type *wsl* then enter

  ![Navigate Distro via WSL](https://github.com/PhongLE1411/how-to-do/blob/main/resources/run-docker-from-02.png)

### 5.2 Run via WSL
![Run via WSL](https://github.com/PhongLE1411/how-to-do/blob/main/resources/run-docker-test-from-wsl.png)

### 5.3 Run on Windows terminal
- Get IP address in WSL2
  > sudo apt install net-tools
  
  > echo `ifconfig eth0 | sed -nre '/^[^ ]+/{N;s/^([^ ]+).*inet *([^ ]+).*/\2/p}'`

  ![install net-tools](https://github.com/PhongLE1411/how-to-do/blob/main/resources/install-net-tools.png)
- Launch dockerd
  In WSL, there is no systemd or other init system. So we need to launch manually docker with the automatic collect of the IP address
  > sudo dockerd -H `ifconfig eth0 | sed -nre '/^[^ ]+/{N;s/^([^ ]+).*inet *([^ ]+).*/\2/p}'`

  If getting the error as below, please stop docker service (sudo service docker stop) then re-run the above command.

  ![Start docker with error](https://github.com/PhongLE1411/how-to-do/blob/main/resources/start-dockerd-error.png)
  
  ![Start docker successful](https://github.com/PhongLE1411/how-to-do/blob/main/resources/start-dockerd-success.png)
  
- Test docker command
  > docker -H `ifconfig eth0 | sed -nre '/^[^ ]+/{N;s/^([^ ]+).*inet *([^ ]+).*/\2/p}'` run --rm hello-world

  ![Run docker command from wsl](https://github.com/PhongLE1411/how-to-do/blob/main/resources/run-docker-test-from-wsl.png)

##  6. Installing Docker.exe on Windows
  - Download Docker.exe and Add Environement Variables (You will need to restart your machine)
    + Visit [this link](https://download.docker.com/win/static/stable/x86_64/) and download that latest version. E.g.: [docker-20.10.21.zip](https://download.docker.com/win/static/stable/x86_64/docker-20.10.21.zip)
    + Extract the zip file to a folder (docker folder) then adding a Environment variable as below:

    ![Adding a Environment variable](https://github.com/PhongLE1411/how-to-do/blob/main/resources/windows-add-environment-variable.png)

  - Check if docker is working

    Check docker version in Windowns terminal

    ![Check docker version](https://github.com/PhongLE1411/how-to-do/blob/main/resources/windows-check-docker-version.png)
  - Test docker on Windows
    + Start dockerd

      Open a terminal in Wsl2 and execute:

      sudo dockerd -H `ifconfig eth0 | sed -nre '/^[^ ]+/{N;s/^([^ ]+).*inet *([^ ]+).*/\2/p}'`

    + Run a container

      With a IP which is got above step. E.g.: 172.23.90.78

      Open Windows terminal and execute:

      > docker -H tcp://172.23.90.78 run --rm hello-world

      ![Test docker on Windows](https://github.com/PhongLE1411/how-to-do/blob/main/resources/windows-test-run-docker.png)

## 7. Configure VSCode to access to WSL2 docker
 If you launch Visual Code and you select the docker extension, you'll get error in the panel asking if docker is installed... Yes of course it's installed but not configured to access to WSL2.

 ![Docker extension load fail](https://github.com/PhongLE1411/how-to-do/blob/main/resources/vscode-docker-load-fail.png)

 To do so, click on the icon (?) on the top right of the section "Containers" and select "Edit settings..."

![Docker extension edit setting](https://github.com/PhongLE1411/how-to-do/blob/main/resources/vscode-docker-edit-setting.png)

You'll get around 56 settings and you search for "Docker:Host" where you put the line "tcp://172.23.90.78:2375" where you can replace the highlighted ip address by the one you got before.
Once done, you come back to the panel and you click on "refresh" icon (top right of each sections) and you would get information from your dockerd running in WSL2.

![Docker extension edit host setting](https://github.com/PhongLE1411/how-to-do/blob/main/resources/vscode-docker-edit-host.png)

## 8. Making everything works without knowing IP
Now, how to run dockerd and docker without copy&paste IP address in command line nor VSCode.

In WSL2, it's not possible to assign IP address but, I can use the windows port forwarding to redirect a local port from the host to a specific one of my distribution. Hence I could put "tcp://localhost:2375" in VsCode and the calls will be redirected to dockerd running in WSL2-Ubuntu.

For this, I run the powershell script lines in windows terminal running as administrator :

> $ip = (wsl sh -c "hostname -I").Split(" ")[0]
netsh interface portproxy add v4tov4 listenport=2375 connectport=2375 connectaddress=$ip
wsl sh -c "sudo dockerd -H tcp://$ip"

Explanation :

- First, I collect the IP address of my default distro with the wsl command.
- Second, I set the port forwarding 2375 to my distro
- Third, I launch in my distro dockerd with the IP

When executing these lines you'll be prompted to enter your distro password (sudo) and I'll see after the log of dockerd. Everything will work fine when I'll see the message "API listen on 172.23.90.78:2375".

In parallel, in a windows terminal opened in my distro, I can check with top or htop if dockerd processes are running.

In VSCode, I update my Docker:Host setting with *tcp://localhost:2375* :

![Docker extension edit host setting](https://github.com/PhongLE1411/how-to-do/blob/main/resources/vscode-docker-edit-host-localhost.png)

Now I can know create a dedicated powershell script with the previous line : start_docker.ps1

In a windows terminal running with administrator privileges, I set the Execution policy with :

> Set-ExecutionPolicy RemoteSigned

And every time I want to run dockerd, I launch the start_docker.ps1 script:


![Run fail](https://github.com/PhongLE1411/how-to-do/blob/main/resources/vscode-docker-start-ps-fail.png)

If you get the error as above, please stop current docker, then run powershell again.

![Run success](https://github.com/PhongLE1411/how-to-do/blob/main/resources/vscode-docker-start-ps-success.png)

And if you see API Listen on 172.23.90.78:2375

Everything works !

Now, I want to use docker without -H parameter, for this, I add a new system environment variable called DOCKER_HOST set to tcp://localhost:2375

![Add System variable](https://github.com/PhongLE1411/how-to-do/blob/main/resources/windows-add-system-variable.png)

Finally, in a windows terminal, I can simply run a command like this:
> docker image ls

![Finally](https://github.com/PhongLE1411/how-to-do/blob/main/resources/final.png)

## 9. References

1. https://docs.docker.com/engine/install/ubuntu/
2. https://docs.docker.com/desktop/windows/wsl/
3. https://learn.microsoft.com/en-us/windows/wsl/setup/environment#set-up-your-linux-username-and-password
4. https://dev.to/_nicolas_louis_/how-to-run-docker-on-windows-without-docker-desktop-hik
5. https://pureinfotech.com/install-windows-subsystem-linux-2-windows-10/
6. https://pureinfotech.com/uninstall-wsl-windows-11/
7. https://pureinfotech.com/install-wsl-windows-11/
8. https://download.docker.com/
9. https://community.chocolatey.org/packages/docker-cli
10. https://www.omgubuntu.co.uk/how-to-install-wsl2-on-windows-10
11. https://dev.solita.fi/2021/12/21/docker-on-wsl2-without-docker-desktop.html