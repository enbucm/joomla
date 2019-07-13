# Joomla Container by H5.Technology [no mysql]

```Dockerfile
docker run -d \
  --restart=always \
  --name myjoomla \
  -p 8080:80 \
  -v /dock/data/myjoomla/log:/var/log/apache2 \
  -v /dock/data/myjoomla/html:/var/www/html/joomla \
  enbucm/joomla
```
