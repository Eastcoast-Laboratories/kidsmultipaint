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
rsync -avz --no-perms --no-owner --no-group --delete dist/ $SSH_P/multipaint.z11.de/

# 4b. Upload to dist subdirectory on multipaint.eu
rsync -avz --no-perms --no-owner --no-group --delete dist/ $SSH_P/multipaint.eu/app/

rsync -avz --no-perms --no-owner --no-group src/api/ $SSH_P/multipaint.eu/api/

# Upload homepage files for both languages
rsync -avz --no-perms --no-owner --no-group dist/index.html $SSH_P/multipaint.eu/
rsync -avz --no-perms --no-owner --no-group dist/de/index.html $SSH_P/multipaint.eu/de/

# Explizit die config.js synchronisieren, um sicherzustellen, dass die aktualisierte Version verwendet wird
rsync -avz --no-perms --no-owner --no-group src/config.js $SSH_P/multipaint.eu/app/
rsync -avz --no-perms --no-owner --no-group src/config.js $SSH_P/multipaint.eu/api/
rsync -avz --no-perms --no-owner --no-group src/config.js $SSH_P/multipaint.eu/
echo "Config file explicitly synchronized to dist/, api/ and root directories"

# 5. Upload homepage files to multipaint.eu root
# Upload English homepage files (root)
rsync -avz --no-perms --no-owner --no-group dist/homepage/en/ $SSH_P/multipaint.eu/

# Upload German homepage files (de/ subdirectory)
# Make sure German directory exists on server
ssh $SSH_P "mkdir -p /var/kunden/webs/ruben/www/multipaint.eu/de"
rsync -avz --no-perms --no-owner --no-group dist/homepage/de/ $SSH_P/multipaint.eu/de/

# Upload shared assets for both language versions
rsync -avz --no-perms --no-owner --no-group dist/images/backgrounds/ $SSH_P/multipaint.eu/images/backgrounds/
rsync -avz --no-perms --no-owner --no-group dist/images/backgrounds/ $SSH_P/multipaint.eu/de/images/backgrounds/
rsync -avz --no-perms --no-owner --no-group public/images/logo_bird_sings.jpg $SSH_P/multipaint.eu/images/
rsync -avz --no-perms --no-owner --no-group public/images/logo_bird_sings.jpg $SSH_P/multipaint.eu/de/images/

# Upload screenshots for both languages - create directories first to avoid rsync errors with empty dirs
ssh $SSH_P "mkdir -p /var/kunden/webs/ruben/www/multipaint.eu/images/screenshots"
ssh $SSH_P "mkdir -p /var/kunden/webs/ruben/www/multipaint.eu/de/images/screenshots"

# Nur synchronisieren wenn Verzeichnis existiert und nicht leer ist
if [ -d "dist/images/screenshots" ] && [ "$(ls -A dist/images/screenshots)" ]; then
  rsync -avz --no-perms --no-owner --no-group dist/images/screenshots/ $SSH_P/multipaint.eu/images/screenshots/
  rsync -avz --no-perms --no-owner --no-group dist/images/screenshots/ $SSH_P/multipaint.eu/de/images/screenshots/
fi

echo "Deployment complete! Homepage files at https://multipaint.eu (EN) and https://multipaint.eu/de/ (DE) and app at https://multipaint.eu/app"

echo "upload the git repo:"
rsync -avz --no-perms --no-owner --no-group --delete .git/ root@vm06.eclabs:/var/kunden/webs/ruben/git/multipaint.z11.de/

echo "done"