$ip = (wsl sh -c "hostname -I").Split(" ")[0]
netsh interface portproxy add v4tov4 listenport=2375 connectport=2375 connectaddress=$ip
wsl sh -c "sudo dockerd -H tcp://$ip"