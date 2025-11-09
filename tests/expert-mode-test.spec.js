const { test, expect } = require('@playwright/test');

/**
 * Test for Expert Mode Toggle functionality
 * This test verifies that:
 * 1. The settings button is accessible
 * 2. The expert mode toggle button works
 * 3. Line Width and Line Color options appear/disappear based on expert mode
 * 4. No JavaScript errors occur during the process
 */
test('Expert Mode Toggle works correctly', async ({ page }) => {
  // Array to collect console errors
  const consoleErrors = [];
  const jsErrors = [];
  
  // Capture console errors
  page.on('console', msg => {
    if (msg.type() === 'error') {
      consoleErrors.push(msg.text());
      console.log(`BROWSER CONSOLE ERROR: ${msg.text()}`);
    } else {
      console.log(`BROWSER LOG [${msg.type()}]: ${msg.text()}`);
    }
  });
  
  // Capture JavaScript errors
  page.on('pageerror', exception => {
    jsErrors.push(exception.message);
    console.log(`BROWSER JS ERROR: ${exception.message}`);
  });
  
  // Navigate to the app
  console.log('Navigating to app...');
  await page.goto('http://localhost:9092/', { timeout: 10000 });
  
  // Wait for page to be fully loaded
  await page.waitForLoadState('networkidle');
  console.log('Page loaded');
  
  // Wait for Alpine.js to be initialized
  await page.waitForFunction(() => window.Alpine !== undefined, { timeout: 5000 });
  console.log('Alpine.js initialized');
  
  // Check initial state - no JS errors should have occurred
  expect(jsErrors.length, `JavaScript errors occurred: ${jsErrors.join(', ')}`).toBe(0);
  expect(consoleErrors.length, `Console errors occurred: ${consoleErrors.join(', ')}`).toBe(0);
  
  // Find and click the settings toggle button
  console.log('Looking for settings toggle button...');
  const settingsToggle = page.locator('#settings-toggle');
  await expect(settingsToggle).toBeVisible({ timeout: 5000 });
  console.log('Settings toggle button found, clicking...');
  await settingsToggle.click();
  await page.waitForTimeout(500);
  
  // Verify toolbar is now visible
  const toolbar = page.locator('#toolbar');
  await expect(toolbar).toBeVisible({ timeout: 2000 });
  console.log('Toolbar is now visible');
  
  // Check that expert mode elements are initially hidden (expertMode defaults to false)
  console.log('Checking initial state of expert mode elements...');
  const lineWidthLabel = page.locator('label[for="drawing-line-width"]');
  const lineColorLabel = page.locator('label[for="drawing-color"]');
  
  // Get initial visibility state
  const initialLineWidthVisible = await lineWidthLabel.isVisible().catch(() => false);
  const initialLineColorVisible = await lineColorLabel.isVisible().catch(() => false);
  console.log(`Initial state - Line Width visible: ${initialLineWidthVisible}, Line Color visible: ${initialLineColorVisible}`);
  
  // Find the expert mode toggle button
  console.log('Looking for expert mode toggle button...');
  const expertModeToggle = page.locator('button:has-text("Toggle Expert Mode")');
  await expect(expertModeToggle).toBeVisible({ timeout: 2000 });
  console.log('Expert mode toggle button found');
  
  // Get the current expert mode state from Alpine store
  const expertModeBefore = await page.evaluate(() => {
    return window.Alpine.store('mascotSettings').expertMode;
  });
  console.log(`Expert mode before toggle: ${expertModeBefore}`);
  
  // Click the expert mode toggle button
  console.log('Clicking expert mode toggle button...');
  await expertModeToggle.click();
  await page.waitForTimeout(500);
  
  // Get the expert mode state after toggle
  const expertModeAfter = await page.evaluate(() => {
    return window.Alpine.store('mascotSettings').expertMode;
  });
  console.log(`Expert mode after toggle: ${expertModeAfter}`);
  
  // Verify the state changed
  expect(expertModeAfter).toBe(!expertModeBefore);
  console.log('Expert mode state toggled successfully');
  
  // Check visibility of expert mode elements after toggle
  const lineWidthVisibleAfter = await lineWidthLabel.isVisible().catch(() => false);
  const lineColorVisibleAfter = await lineColorLabel.isVisible().catch(() => false);
  console.log(`After toggle - Line Width visible: ${lineWidthVisibleAfter}, Line Color visible: ${lineColorVisibleAfter}`);
  
  // If expert mode is now true, elements should be visible
  if (expertModeAfter) {
    expect(lineWidthVisibleAfter, 'Line Width should be visible when expert mode is ON').toBe(true);
    expect(lineColorVisibleAfter, 'Line Color should be visible when expert mode is ON').toBe(true);
  } else {
    expect(lineWidthVisibleAfter, 'Line Width should be hidden when expert mode is OFF').toBe(false);
    expect(lineColorVisibleAfter, 'Line Color should be hidden when expert mode is OFF').toBe(false);
  }
  
  // Toggle again to test the reverse
  console.log('Toggling expert mode again...');
  await expertModeToggle.click();
  await page.waitForTimeout(500);
  
  const expertModeAfterSecondToggle = await page.evaluate(() => {
    return window.Alpine.store('mascotSettings').expertMode;
  });
  console.log(`Expert mode after second toggle: ${expertModeAfterSecondToggle}`);
  
  // Verify it toggled back
  expect(expertModeAfterSecondToggle).toBe(expertModeBefore);
  
  // Check visibility again
  const lineWidthVisibleFinal = await lineWidthLabel.isVisible().catch(() => false);
  const lineColorVisibleFinal = await lineColorLabel.isVisible().catch(() => false);
  console.log(`After second toggle - Line Width visible: ${lineWidthVisibleFinal}, Line Color visible: ${lineColorVisibleFinal}`);
  
  if (expertModeAfterSecondToggle) {
    expect(lineWidthVisibleFinal, 'Line Width should be visible when expert mode is ON').toBe(true);
    expect(lineColorVisibleFinal, 'Line Color should be visible when expert mode is ON').toBe(true);
  } else {
    expect(lineWidthVisibleFinal, 'Line Width should be hidden when expert mode is OFF').toBe(false);
    expect(lineColorVisibleFinal, 'Line Color should be hidden when expert mode is OFF').toBe(false);
  }
  
  // Final check - no errors should have occurred during the entire test
  expect(jsErrors.length, `JavaScript errors occurred during test: ${jsErrors.join(', ')}`).toBe(0);
  expect(consoleErrors.length, `Console errors occurred during test: ${consoleErrors.join(', ')}`).toBe(0);
  
  console.log('Expert mode toggle test completed successfully!');
});
