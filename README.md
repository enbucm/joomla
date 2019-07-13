# Joomla Container by H5.Technology [no mysql]

```Dockerfile
docker run -d \
  --restart=always \
  --name myjoomla \
  -p 8080:80 \
  -e EMAIL="admin@yourdomain.org \
  -e DOMAIN="yourdomain.org" \
  enbucm/joomla
```
