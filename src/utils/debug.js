/**
 * Debug logging utility
 * Provides consistent logging across the application
 */

/**
 * Log a debug message with a category
 * @param {string} category - The category/module name (e.g., 'App', 'UI', 'REFERRAL')
 * @param {string} message - The message to log
 * @param {*} data - Optional data to log
 */
export function debugLog(category, message, data = null) {
  const timestamp = new Date().toISOString();
  const logMessage = `[${timestamp}] [${category}] ${message}`;
  
  if (data !== null) {
    console.log(logMessage, data);
  } else {
    console.log(logMessage);
  }
}

/**
 * Log an error message with a category
 * @param {string} category - The category/module name
 * @param {string} message - The error message
 * @param {Error} error - Optional error object
 */
export function debugError(category, message, error = null) {
  const timestamp = new Date().toISOString();
  const logMessage = `[${timestamp}] [${category}] ERROR: ${message}`;
  
  if (error !== null) {
    console.error(logMessage, error);
  } else {
    console.error(logMessage);
  }
}

/**
 * Log a warning message with a category
 * @param {string} category - The category/module name
 * @param {string} message - The warning message
 */
export function debugWarn(category, message) {
  const timestamp = new Date().toISOString();
  console.warn(`[${timestamp}] [${category}] WARNING: ${message}`);
}
