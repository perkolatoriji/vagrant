echo "O-> Starting project check:"
echo o
echo "o-> grafana server up:"
curl 192.168.11.11:3000
echo o
echo "o-> nginx server up:"
curl 192.168.11.12 | grep CIG
echo o
echo "o-> apache2 server up:"
curl 192.168.11.13 | grep CIG
echo o
echo "o-> prometheus server up:"
curl 192.168.11.14:9090
echo o
echo "O-> project check finished."
