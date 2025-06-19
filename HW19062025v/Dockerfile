FROM alpine:latest

# Добавляем переменную сборки ARG VERSION
ARG VERSION

# Устанавливаем переменную APP_VERSION равную значению VERSION
ENV APP_VERSION="${VERSION}"

# Выводим значение переменной APP_VERSION
RUN echo "App version: $APP_VERSION"

# Копируем исходники приложения (если есть)
COPY . /app

# Переходим в директорию приложения
WORKDIR /app

# Запускаем приложение (если есть)
CMD ["/bin/sh"]