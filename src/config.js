/**
 * Central configuration for kidsmultipaint App
 * Contains environment-specific settings from central YAML config
 */

// Hardcode configuration for now until we resolve YAML loading issues
const configData = {
  development: {
    API_BASE_URL: 'http://localhost:8080',
    APP_BASE_URL: 'http://localhost:9092',
    APP_BASE_PATH: '/'
  },
  production: {
    API_BASE_URL: 'https://kidsmultipaint.eu/api',
    APP_BASE_URL: 'https://kidsmultipaint.eu/app',
    APP_BASE_PATH: '/app/'
  }
};

// Detect environment (local development vs production or mobile)
const isProduction = window.location.hostname === 'kidsmultipaint.eu' || 
                     window.location.hostname === 'kidsmultipaint.z11.de';

// Also consider as production when running in Capacitor/mobile environment
const isMobile = window.location.protocol === 'capacitor:' || 
               window.location.protocol === 'https:' && 
               (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1');

const useProductionConfig = isProduction || isMobile;

// Check for configuration override from HTML
let configOverride = {};
if (isProduction && typeof window !== 'undefined' && window.kidsmultipaint_CONFIG_OVERRIDE) {
  configOverride = window.kidsmultipaint_CONFIG_OVERRIDE;
  console.log('[CONFIG] Using configuration override from HTML');
}

// Select config based on environment
let currentConfig = useProductionConfig ? configData.production : configData.development;

// Log if we're in mobile environment
if (isMobile) {
  console.log('[CONFIG] Running in MOBILE environment, using production API endpoints');
}

// Apply any overrides
currentConfig = { ...currentConfig, ...configOverride };

// Debug log the detected environment
console.log(`[CONFIG] Running in ${isProduction ? 'PRODUCTION' : 'DEVELOPMENT'} environment`);
console.log(`[CONFIG] API_BASE_URL: ${currentConfig.API_BASE_URL}`);
console.log(`[CONFIG] APP_BASE_URL: ${currentConfig.APP_BASE_URL}`);
console.log(`[CONFIG] APP_BASE_PATH: ${currentConfig.APP_BASE_PATH}`);

export default currentConfig;
