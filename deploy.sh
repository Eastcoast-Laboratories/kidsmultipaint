#! /bin/bash

# online 
SSH_P=root@vm06.eclabs:/var/kunden/webs/ruben/www

# 1. Build the project with subdirectory flag for correct asset paths
npm run build -- --env deploy=subdirectory

# 2. Stelle sicher, dass app-Verzeichnis existiert
mkdir -p dist

# 3. Kopiere alle statischen Assets in einem Schritt
cp -r public/* dist/

# 4. Upload to the server (both built files and images)
rsync -avz --no-perms --no-owner --no-group --delete dist/ $SSH_P/kidsmultipaint.z11.de/

# 4b. Upload to dist subdirectory on kidsmultipaint.eu
rsync -avz --no-perms --no-owner --no-group --delete dist/ $SSH_P/kidsmultipaint.eu/app/

rsync -avz --no-perms --no-owner --no-group src/api/ $SSH_P/kidsmultipaint.eu/api/

# Upload homepage files for both languages
rsync -avz --no-perms --no-owner --no-group dist/index.html $SSH_P/kidsmultipaint.eu/
rsync -avz --no-perms --no-owner --no-group dist/de/index.html $SSH_P/kidsmultipaint.eu/de/

# Explizit die config.js synchronisieren, um sicherzustellen, dass die aktualisierte Version verwendet wird
rsync -avz --no-perms --no-owner --no-group src/config.js $SSH_P/kidsmultipaint.eu/app/
rsync -avz --no-perms --no-owner --no-group src/config.js $SSH_P/kidsmultipaint.eu/api/
rsync -avz --no-perms --no-owner --no-group src/config.js $SSH_P/kidsmultipaint.eu/
echo "Config file explicitly synchronized to dist/, api/ and root directories"

# 5. Upload homepage files to kidsmultipaint.eu root
# Upload English homepage files (root)
rsync -avz --no-perms --no-owner --no-group dist/homepage/en/ $SSH_P/kidsmultipaint.eu/

# Upload German homepage files (de/ subdirectory)
# Make sure German directory exists on server
ssh $SSH_P "mkdir -p /var/kunden/webs/ruben/www/kidsmultipaint.eu/de"
rsync -avz --no-perms --no-owner --no-group dist/homepage/de/ $SSH_P/kidsmultipaint.eu/de/

# Upload shared assets for both language versions
rsync -avz --no-perms --no-owner --no-group dist/images/backgrounds/ $SSH_P/kidsmultipaint.eu/images/backgrounds/
rsync -avz --no-perms --no-owner --no-group dist/images/backgrounds/ $SSH_P/kidsmultipaint.eu/de/images/backgrounds/
rsync -avz --no-perms --no-owner --no-group public/images/logo_bird_sings.jpg $SSH_P/kidsmultipaint.eu/images/
rsync -avz --no-perms --no-owner --no-group public/images/logo_bird_sings.jpg $SSH_P/kidsmultipaint.eu/de/images/

# Upload screenshots for both languages - create directories first to avoid rsync errors with empty dirs
ssh $SSH_P "mkdir -p /var/kunden/webs/ruben/www/kidsmultipaint.eu/images/screenshots"
ssh $SSH_P "mkdir -p /var/kunden/webs/ruben/www/kidsmultipaint.eu/de/images/screenshots"

# Nur synchronisieren wenn Verzeichnis existiert und nicht leer ist
if [ -d "dist/images/screenshots" ] && [ "$(ls -A dist/images/screenshots)" ]; then
  rsync -avz --no-perms --no-owner --no-group dist/images/screenshots/ $SSH_P/kidsmultipaint.eu/images/screenshots/
  rsync -avz --no-perms --no-owner --no-group dist/images/screenshots/ $SSH_P/kidsmultipaint.eu/de/images/screenshots/
fi

echo "Deployment complete! Homepage files at https://kidsmultipaint.eu (EN) and https://kidsmultipaint.eu/de/ (DE) and app at https://kidsmultipaint.eu/app"

echo "upload the git repo:"
rsync -avz --no-perms --no-owner --no-group --delete .git/ root@vm06.eclabs:/var/kunden/webs/ruben/git/kidsmultipaint.z11.de/

echo "done"