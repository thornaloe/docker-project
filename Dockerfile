# Используем базовый образ Ubuntu
FROM ubuntu:latest

# Обновляем apt-кеш и обновляем пакеты
RUN apt-get update && apt-get upgrade -y

# Устанавливаем веб-сервер nginx
RUN apt-get install -y nginx

# Очищаем apt-cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Удаляем содержимое директории /var/www/
RUN rm -rf /var/www/*

# Копируем файлы в папку /var/www/basyuk/
COPY index.html /var/www/basyuk/
COPY img.jpg /var/www/basyuk/img/

# Устанавливаем права на директорию
RUN chmod -R 755 /var/www/basyuk

# Добавляем пользователя в существующую группу 'basyuk'
RUN useradd -m -s /bin/bash basyuk && usermod -aG basyuk basyuk

# Присваиваем права на директорию
RUN chown -R basyuk:basyuk /var/www/basyuk

# Заменяем подстроку в конфигурационном файле nginx
RUN sed -i 's/\/var\/www\/html/\/var\/www\/basyuk/g' /etc/nginx/sites-enabled/default

# Заменяем пользователя в конфигурационном файле nginx
RUN sed -i 's/user www-data/user basyuk/g' /etc/nginx/nginx.conf

# Экспортируем порт 80
EXPOSE 80

# Команда запуска nginx
CMD ["nginx", "-g", "daemon off;"]

