# Setting up a load balancer

[Using haproxy and nginx on DO](https://www.youtube.com/watch?v=dRU7rqqX7ho)

1. Set up load balancer and two web servers on DO, in same region with private
   networking
2. in LB, `apt-get install haproxy -y`
3. on W1 and W2, `apt-get install nginx -y`
4. on W1 and W2, `mkdir /srv/www`
5. on W1 and W2, `vim /srv/www/index.html` and add host name in HTML in index
5. on W1 and W2, `chown www-data:www-data /srv/www/ -R`
5. on W1 and W2, `rm /etc/nginx/sites-enabled/default`
5. on W1 and W2, `vim /etc/nginx/sites-enabled/tutorial`
  * in nginx config
```
server {
  listen 80;
  root /srv/www;
}
```
5. on W1 and W2, `service nginx reload` and `curl localhost`
6. on LB, `vim /etc/haproxy/haproxy.cfg`
  * add
```
frontend tutorial_in
        bind *:80
        default_backend tutorial_http

backend tutorial_http
        balance roundrobin
        mode http
        server web1 <<web1 private IP>>:80 check
        server web2 <<web2 private IP>>:80 check
```
7. on LB, `service haproxy reload`
