FROM nginx:1.11-alpine
COPY . /usr/share/nginx/html
WORKDIR /usr/share/nginx/html
RUN for i in *.html; do sed -i 's|//localhost:3000|https://katacoda.com|g' "$i"; done
