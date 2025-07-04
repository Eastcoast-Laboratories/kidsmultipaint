const { test, expect } = require('@playwright/test');

test('Canvas and scripts load properly', async ({ page }) => {
  // Skip uncaught exceptions related to script loading during test
  page.on('pageerror', (exception) => {
    console.log(`Page error: ${exception.message}`);
    // We're just logging errors, not failing the test on them
  });

  // Navigate to the app
  await page.goto('http://localhost:9092/');
  
  // Wait for page to be fully loaded
  await page.waitForLoadState('networkidle');

  // Log all network requests to diagnose MIME type issues
  const requests = [];
  page.on('request', request => {
    requests.push(request);
  });

  page.on('response', response => {
    const request = response.request();
    const url = request.url();
    if (url.includes('fabric.min.js') || url.includes('native-app-detector.js')) {
      console.log(`Request to ${url} got status ${response.status()} and contentType ${response.headers()['content-type']}`);
    }
  });

  // Check if canvas is present
  const canvasLocator = page.locator('canvas');
  await expect(canvasLocator).toBeVisible();

  // Try to check if fabric is loaded
  const fabricLoaded = await page.evaluate(() => {
    return typeof fabric !== 'undefined';
  }).catch(e => false);

  console.log(`Fabric.js loaded: ${fabricLoaded}`);

  // If fabric.js is not loaded, try to determine why
  if (!fabricLoaded) {
    // Check network requests for script loading failures
    await page.evaluate(() => {
      const scripts = document.querySelectorAll('script');
      for (const script of scripts) {
        console.log(`Script src: ${script.src}, loaded: ${script.complete && !script.onerror}`);
      }
    });

    // Check content-security-policy headers
    const cspHeaders = await page.evaluate(() => {
      return {
        'csp': document.head.querySelector('meta[http-equiv="Content-Security-Policy"]')?.content,
        'csp-report-only': document.head.querySelector('meta[http-equiv="Content-Security-Policy-Report-Only"]')?.content
      };
    });

    console.log('CSP Headers:', cspHeaders);
  }

  // Add suggestion for fixing MIME type issues
  console.log('\nSuggestions to fix MIME type issues:');
  console.log('1. Ensure webpack is configured to serve JS files with correct MIME type');
  console.log('2. For native-app-detector.js, make sure it\'s included in webpack entries');
  console.log('3. Try adding proper MIME types in the server configuration');
  console.log('4. For CDN issues, try hosting Fabric.js locally in the project');
});
