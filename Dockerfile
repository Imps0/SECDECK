FROM nginx:1.28-alpine
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY index/ /usr/share/nginx/html/
RUN addgroup -S secdeck && adduser -S -D -H -G secdeck secdeck \
    && chown -R secdeck:secdeck /usr/share/nginx/html /var/cache/nginx /var/run /var/log/nginx \
    && touch /var/run/nginx.pid && chown secdeck:secdeck /var/run/nginx.pid
USER secdeck
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
