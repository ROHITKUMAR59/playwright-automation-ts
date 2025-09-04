import { test, expect } from '@playwright/test';

test('dummy test loads Google', async ({ page }) => {
  await page.goto('https://www.google.com');
  await expect(page).toHaveTitle(/Google/);
});
