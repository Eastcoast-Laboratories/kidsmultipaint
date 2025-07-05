kidsmultipaint
======

Explore creative drawing with a child-friendly paint app – playful, colorful, and easy to use!

# Description

kidsmultipaint – Creative Drawing Made Fun

With kidsmultipaint, children dive into the colorful world of digital painting! In a playful way with an intuitive interface, they can explore drawing, colors, and shapes – all without any prior knowledge or technical skills.

What can your child expect in kidsmultipaint?

- Full-Screen Canvas
  A spacious digital canvas where creativity has no limits! Children can draw freely with different brushes and colors.

- Child-friendly features
  - Simple, intuitive brush controls
  - Various colors to choose from
  - Different drawing modes
  - Clear canvas option when starting fresh
  - Undo functionality

- Child lock protection
  A special child lock keeps children in drawing mode while preventing accidental changes to settings.

Intuitive navigation
kidsmultipaint is specially designed for young children – no complex menus, just a simple interface with clear, accessible controls.

Clean, distraction-free design
The app focuses on the drawing experience without unnecessary elements or distractions.

No ads, no in-app purchases
Fully usable offline, with no distractions – just drawing, creativity, and joy.

Perfect for preschool-aged children, parents who want to encourage creative expression, and educators looking for a simple digital art tool for kids.


# Beschreibung

🐦 Intuitive Bedienung
kidsmultipaint ist speziell für kleine Kinder entwickelt – keine komplizierten Menüs, sondern eine klare, bildgestützte Navigation

🎵 Keine Werbung, keine In-App-Käufe
Vollständig offline nutzbar, keine Ablenkung – nur Musik, Spiel und Freude.

Ideal für Kinder im Vorschulalter, für Eltern, 

# Requirements

* Node >= 12
* npm (or yarn)


# Installation

Clone the repo.
Initialize node_modules with:
```
npm install
```

# Development

Run the webpack-dev-server including live-reload with:
```
npm run watch
```

to start the app use 
```
run.sh
```

The application will be available at http://localhost:9092 in your browser.
- Main page: http://localhost:9092/index.html
- Card library: http://localhost:9092/cards.html
- Multiplayer mode: http://localhost:9092/multiplayer.html


# Production

Bundle and build with:
```
npm run build
```
All files are then in the /dist folder.
Full Optimization - Minification, Tree-shaking


## fast build

No Minification - Code stays readable

```
npm run build:fast
```

# Online Deployment

The application is deployed at: https://kidsmultipaint.z11.de/

To update the online version, follow these steps from the project's root directory:

```
# 1. Build the production files (this will create the /dist folder)
npm run build

# 2. Make sure the dist/ directory was created and contains all needed files
ls -la dist/

# 3. Upload to the server (make sure you're in the project root directory)
rsync -avz --no-perms --no-owner --no-group --delete dist/ your_server_dir

# 4. Resume development (optional)
npm run watch
```

## String Management

This app uses Android XML files as the single source of truth for all translations:

**Edit strings here:**
- English: `android/app/src/main/res/values/strings.xml`
- German: `android/app/src/main/res/values-de/strings.xml`

**After editing XML files:**
- Run `npm run sync-strings` 
- OR restart `npm run watch`

**Mobile builds:**
Use the XML files directly (no sync needed).

# Known bugs:

In certain scenarios, the menu lock button may become stuck in the locked state, especially when changing screen width, locking the menu, changing the width again, and then reloading the page. If this happens, you can fix it by opening the browser console and running: `localStorage.clear();`

# Development scripts

The following scripts are available to streamline development:

- `run.sh`: Starts the development server with hot reloading and updates mobile apps
  ```bash
  bash run.sh
  ```

- `mobile-build.sh`: Builds and deploys the app to connected Android/iOS devices
  ```bash
  bash mobile-build.sh
  ```

# Testing

This project uses Playwright for automated testing. Test files are located in the `tests/` directory.

To run the tests:

```bash
# Install Playwright if not already installed
npm install -D @playwright/test

# Run the tests
npx playwright test
```

The main test files include:
- `hash-navigation.spec.js`: Tests navigation between activities using URL hash changes
