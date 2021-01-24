echo "O-> Starting project check:"
echo .
echo "o-> grafana server up:"
curl -s 192.168.11.11:3000
echo "o-- you can access grafana via: http://192.168.11.11:3000"
echo .
echo "o-> nginx server up:"
curl -s 192.168.11.12 | grep "<title>" 
echo "o-- you can access nginx via: http://192.168.11.12"
echo .
echo "o-> apache2 server up:"
curl -s 192.168.11.13 | grep "<title>"
echo "o-- you can access apache2 via: http://192.168.11.13"
echo .
echo "o-> prometheus server up:"
curl -s 192.168.11.14:9090
echo "o-- you can access prometheus via: http://192.168.11.14:9090/graph"
echo .
echo "o-> prometheus-pushgateway up:"
curl -s 192.168.11.14:9091 | grep  "<title>"
echo "o-- you can access prometheus-pushgateway via: http://192.168.11.14:9091"
echo .
echo "o-> prometheus-alertmanager up:"
curl -s 192.168.11.14:9093 | grep  "<title>"
echo "o-- you can access prometheus-alertmanager via: http://192.168.11.14:9093"
echo .
#echo "o-> prometheus-cert-exporter up:"
#curl -s 192.168.11.14:9117/metrics | grep "certificate" | head -n 1
#echo "o-- you can access prometheus-cert-exporter metrics via: http://192.168.11.14:9117/metrics"
echo .
echo "O-> project check finished."

