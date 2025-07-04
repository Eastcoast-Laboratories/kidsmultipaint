#!/bin/bash
# run.sh - script to kill existing servers, build and start new

echo "Stopping any running webpack servers..."
# Kill processes on port 9092 (current webpack port)
fuser -k 9091/tcp 2>/dev/null || echo "No process running on port 9091"
fuser -k 9092/tcp 2>/dev/null || echo "No process running on port 9092"

# Also try to kill by process name in case port changed
pkill -f 'webpack.*serve' 2>/dev/null || echo "No webpack process found"

# 3. rsync images from public directory to app
echo "Syncing images..."
rsync -a --progress --delete public/images/ app/images/

echo "Starting webpack development server..."
# Starte webpack-Server im Hintergrund
npm run build:fast; npm run watch &

# Warte kurz, damit der Server starten kann
sleep 2

echo "
kidsmultipaint-App ist verfügbar unter: http://localhost:9092"
echo "Homepage ist verfügbar unter: http://localhost:9092/homepage"
echo "If the browser doesn't open automatically, please visit the URLs manually."

#echo "Starting mobile app update..."
#./mobile-build.sh update
