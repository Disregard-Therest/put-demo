#!/usr/bin/env bash
# Сборка и деплой демки на GitHub Pages с кэш-бастингом.
# Запуск из корня проекта в Git Bash: ./deploy.sh
set -euo pipefail

TS=$(date +%s)

# Без service worker: для демки он только мешает обновлениям.
MSYS_NO_PATHCONV=1 flutter build web --release --base-href /put-demo/ --pwa-strategy=none

# Вшиваем метку сборки в ссылки на JS (обход кэша GitHub Pages и Telegram).
sed -i "s|flutter_bootstrap.js\"|flutter_bootstrap.js?v=$TS\"|" build/web/index.html
sed -i "s|\"main.dart.js\"|\"main.dart.js?v=$TS\"|g" build/web/flutter_bootstrap.js

rm -rf docs
mkdir -p docs
cp -r build/web/* docs/
touch docs/.nojekyll

git add -A
git commit -m "deploy $TS"
git push origin master

echo "Deployed build $TS → https://disregard-therest.github.io/put-demo/ (1-2 мин)"
