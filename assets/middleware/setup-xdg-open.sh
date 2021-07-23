#!/bin/bash

mv /usr/bin/xdg-open /usr/bin/xdg-open.orig
echo '#!/bin/bash' > /usr/bin/xdg-open
echo "./xdg-open.orig $@ > /dev/null 2>/dev/null" >> /usr/bin/xdg-open
chmod +x /usr/bin/xdg-open