echo "O-> Starting project check:"
echo .
echo "o-> grafana server up:"
curl -s 192.168.11.11:3000 --connect-timeout 2
echo "o-- you can access grafana via: http://192.168.11.11:3000"
echo .
echo "o-> nginx server up:"
curl -s 192.168.11.12 --connect-timeout 2 | grep "<title>" 
echo "o-- you can access nginx via: http://192.168.11.12"
echo .
echo "o-> apache2 server up:"
curl -s 192.168.11.13 --connect-timeout 2 | grep "<title>"
echo "o-- you can access apache2 via: http://192.168.11.13"
echo .
echo "o-> prometheus server up:"
curl -s 192.168.11.14:9090 --connect-timeout 2
echo "o-- you can access prometheus via: http://192.168.11.14:9090/graph"
echo .
echo "o-> prometheus-pushgateway up:"
curl -s 192.168.11.14:9091 --connect-timeout 2 | grep  "<title>"
echo "o-- you can access prometheus-pushgateway via: http://192.168.11.14:9091"
echo .
echo "o-> prometheus-alertmanager up:"
curl -s 192.168.11.14:9093 --connect-timeout 2 | grep  "<title>"
echo "o-- you can access prometheus-alertmanager via: http://192.168.11.14:9093"
echo .
echo "o-> prometheus-blackbox-exporter up:"
curl -s 192.168.11.14:9115/metrics --connect-timeout 2 | grep "HEAD" | head -n 1
echo "o-- you can access prometheus-blackbox-exporter via: http://192.168.11.14:9115"
echo "o-- you can access prometheus-blackbox-exporter metrics via: http://192.168.11.14:9115/metrics"
echo .
#echo "o-> prometheus-cert-exporter up:"
#curl -s 192.168.11.14:9117/metrics | grep "certificate" | head -n 1
#echo "o-- you can access prometheus-cert-exporter metrics via: http://192.168.11.14:9117/metrics"
#echo .
echo "O-> project check finished."

