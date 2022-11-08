FROM nginx:latest

#RUN rm /etc/nginx/nginx.conf
#RUN rm /etc/nginx/conf.d/default.conf

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    locales \
    nano \
    curl

# Copy existing application directory permissions
COPY --chown=www-data:www-data . /var/www

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443
