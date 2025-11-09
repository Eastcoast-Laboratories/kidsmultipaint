// Import Alpine.js
import Alpine from 'alpinejs';

// Import styles
import './styles/main.css';
import './styles/clickable-map.css';

// Import Capacitor initialization
import { initCapacitor } from './capacitor';

// Import debug utilities
import { debugLog } from './utils/debug';

// Import components
import { app } from './components/app';

// Log application startup in debug mode
debugLog('App', 'Application initializing');

// Initialize Alpine store for state management
Alpine.store('pitchMode', 'main'); // Default is the main selection screen with clickable image

// Initialize global mascot settings store
Alpine.store('mascotSettings', {
  showHelpMessages: true,
  seenActivityMessages: {},
  disableTTS: true,
  expertMode: false,
  
  // Load settings from localStorage
  init() {
    try {
      const savedSettings = localStorage.getItem('kidsmultipaint_mascot_settings');
      if (savedSettings) {
        const loadedSettings = JSON.parse(savedSettings);
        // Merge with defaults to ensure new flags are set
        Object.assign(this, {
          showHelpMessages: true,
          seenActivityMessages: {},
          disableTTS: true,
          expertMode: false,
          ...loadedSettings
        });
        // Reset seen messages on app start
        this.seenActivityMessages = {};
        console.log('MASCOT_STORE: Loaded settings and reset seen messages:', this);
      }
      this.save();
    } catch (error) {
      console.error('MASCOT_STORE: Error loading settings:', error);
    }
  },
  
  // Save settings to localStorage
  save() {
    try {
      localStorage.setItem('kidsmultipaint_mascot_settings', JSON.stringify({
        showHelpMessages: this.showHelpMessages,
        seenActivityMessages: this.seenActivityMessages,
        disableTTS: this.disableTTS,
        expertMode: this.expertMode
      }));
      console.log('MASCOT_STORE: Settings saved');
    } catch (error) {
      console.error('MASCOT_STORE: Error saving settings:', error);
    }
  },
  
  // Toggle help messages
  toggleHelpMessages() {
    this.showHelpMessages = !this.showHelpMessages;
    this.save();
    console.log('MASCOT_STORE: Help messages toggled:', this.showHelpMessages);
  },
  
  // Hide help messages (called by close button)
  hideHelpMessages() {
    this.showHelpMessages = false;
    this.save();
    console.log('MASCOT_STORE: Help messages disabled via close button');
  },
  
  // Toggle expert mode
  toggleExpertMode() {
    console.log('EXPERT_MODE_TOGGLE: Before toggle, expertMode is', this.expertMode);
    this.expertMode = !this.expertMode;
    console.log('EXPERT_MODE_TOGGLE: After toggle (before save), expertMode is', this.expertMode);
    this.save();
    console.log('EXPERT_MODE_TOGGLE: After save, expertMode is', this.expertMode);
    // Force Alpine to detect the change
    this.$nextTick && this.$nextTick(() => {
      console.log('EXPERT_MODE_TOGGLE: In nextTick, expertMode is', this.expertMode);
    });
  }
});

// Register Alpine components
Alpine.data('app', app);
// Note: Other components (tonecolors, pitches, rhythms, chords, freeplay) are not imported yet
// Alpine.data('tonecolors', tonecolors);
// Alpine.data('pitches', pitches);
// Alpine.data('rhythms', rhythms);
// Alpine.data('chords', chords);
// Alpine.data('freeplay', freeplay);

// Initialize Capacitor when device is ready
document.addEventListener('DOMContentLoaded', () => {
  // Initialize Capacitor and get platform info
  const capacitor = initCapacitor();
  
  // Store capacitor info in Alpine store for use throughout the app
  Alpine.store('platform', {
    isNative: capacitor.isNative,
    type: capacitor.getPlatform()
  });
  
  console.log('kidsmultipaint app running on platform:', capacitor.getPlatform());
});

// Start Alpine
window.Alpine = Alpine;
// Start Alpine.js
Alpine.start();

// Load HTML partials after Alpine is initialized (if function exists)
if (typeof loadHtmlPartials === 'function') {
  loadHtmlPartials();
}

// Initialize mascot settings after Alpine starts
Alpine.store('mascotSettings').init();

debugLog('App', 'Application started successfully');
