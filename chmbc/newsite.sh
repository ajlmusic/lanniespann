# author: Andrew J. Lewis <andrew.lewis@nehetek.com>

echo "Enter new site name: "
read SITE

#  create site root directory and files

mkdir -p /var/www/$SITE/html

cat << EOF >> /var/www/$SITE/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title></title>
</head>
<body>
    <div>
        <h1 id='site'></h1>
    </div>
    <script>
        const { hostname } = location;
        const site = document.getElementById('site');
        if(!isNaN(hostname.charAt(0))) {
            document.title = "Nehetek.com";
        }
        else {      
            site.innerHTML = hostname;
            document.title = hostname;
        }

    </script>
</body>
</html>

EOF

mkdir /var/www/$SITE/html/php

cat << EOF >> /var/www/$SITE/html/php/index.php
<?php 
phpinfo();

?>


EOF


# Create nginx server block 
cat << EOF >>  /etc/nginx/sites-available/$SITE
server {

        listen 80;
        listen [::]:80;

        root /var/www/$SITE/html;
        index index.html index.htm index.php;
        
        server_name $SITE;
        

        location / {
                try_files \$uri \$uri/ =404;
        }
        location ~ \.php$ {
                 include snippets/fastcgi-php.conf;
                 fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        }

        location ~ /\.ht {
                deny all;
        }      
}
EOF

# Link new site
ln -s /etc/nginx/sites-available/$SITE /etc/nginx/sites-enabled/

# reload nginx service
service nginx reload
