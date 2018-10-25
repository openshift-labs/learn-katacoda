FROM httpd-php

MAINTAINER fatherlinux <scott.mccarty@gmail.com>

COPY ./docker-entrypoint.sh /entrypoint.sh
COPY ./index.php /var/www/html/index.php

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/cmd.sh"]
