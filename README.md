# ubuntu-web-ssh-docker

docker run -it --rm -e PASSWORD=kuku -p 9090:2222 -p 139:139 -p 445:445 -p 8888:443 -p 8989:8989 royi1000/webssh_ubuntu


## Browse to:
http://127.0.0.1:9090/ssh/host/127.0.0.1
## Files:
http://127.0.0.1:8989

### Samba/CIFS and https webdav is enabled too
