# author: Andrew J. Lewis <andrew.lewis@nehetek.com>

echo "Enter site name to remove: "
read SITE

#  remove site root directory and files
rm -R /var/www/$SITE

# remove nginx server block and linked site
rm /etc/nginx/sites-available/$SITE 
rm /etc/nginx/sites-enabled/$SITE

# reload nginx service
service nginx reload



