#!/bin/bash

# Получаем URL репозитория из аргумента (обязательно!)
if [ -z "$1" ]; then
    echo "Usage: $0 <repository-url>"
    exit 1
fi
REPO_URL="$1"

# Клонируем репозиторий
TEMP_DIR="/tmp/update-tag-tmp"
rm -rf "$TEMP_DIR"
git clone "$REPO_URL" "$TEMP_DIR"

# Переходим в директорию проекта
cd "$TEMP_DIR" || exit 1

# Получаем текущий тег
CURRENT_TAG=$(git describe --tags --abbrev=0)

# Получаем последний коммит
LAST_COMMIT=$(git rev-list HEAD --max-count=1)

# Получаем коммит, на который указывает тег
TAG_COMMIT=$(git rev-list "$CURRENT_TAG" --max-count=1)

# Проверяем, есть ли новые коммиты после тега
if [[ "$LAST_COMMIT" == "$TAG_COMMIT" ]]; then
    echo "No changes."
else
    # Увеличиваем patch-версию (увеличиваем третью часть номера версии)
    VERSION_PARTS=(${CURRENT_TAG//./ })
    PATCH_VERSION=${VERSION_PARTS[2]}
    NEW_PATCH_VERSION=$(($PATCH_VERSION + 1))
    NEW_TAG="${VERSION_PARTS[0]}.${VERSION_PARTS[1]}.${NEW_PATCH_VERSION}"

    # Создаем новый аннотированный тег
    git tag -a "$NEW_TAG" -m "Updated patch version"

    # Пушим новый тег в удалённый репозиторий
    git push origin "$NEW_TAG"

    echo "Created new tag: $NEW_TAG"
fi

# Удаляем временную директорию
cd ..
rm -rf "$TEMP_DIR"