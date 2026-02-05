# Playwright Testing Guide for Flutter Web

This document provides a complete guide to setting up and running end-to-end (E2E) tests for the EduTrack Flutter Web application using [Playwright](https://playwright.dev/).

## 1. Prerequisites

- **Node.js** (v14 or higher)
- **Flutter Web App** running (locally or deployed)

## 2. Setup Playwright

1.  Open your terminal in the project root.
2.  Initialize a new Playwright project:
    ```bash
    npm init playwright@latest
    ```
3.  Follow the prompts:
    - Choose **TypeScript** or **JavaScript** (TypeScript recommended).
    - Name your tests folder (default: `tests`).
    - Add a GitHub Actions workflow? (Optional).
    - Install Playwright browsers? **Yes**.

## 3. Configuration

Open `playwright.config.ts` and ensure the `use` block points to your local Flutter server (usually port 5000-8000 depending on how you run it, e.g., `flutter run -d chrome --web-port 3000`).

```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  use: {
    // Base URL of your running Flutter app
    baseURL: 'http://localhost:3000', 
    trace: 'on-first-retry',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
});
```

## 4. Writing Tests

Since Flutter Web renders content using Canvas (by default in recent versions) or HTML, Playwright interacts best with the **Accessibility Tree (Semantics)**.

Create a new file `tests/edutrack.spec.ts` and paste the following code. This test suite covers the Auth flow and Dashboard verification.

> **Note**: These tests rely on the text content and semantics (Labels/Hints) present in the app.

```typescript
import { test, expect } from '@playwright/test';

test.describe('EduTrack E2E Tests', () => {
  
  test.beforeEach(async ({ page }) => {
    // 1. Go to the app URL
    await page.goto('/');
    
    // 2. Wait for the app to hydrate/render (Flutter can be slow to start)
    // We wait for the main title to appear.
    await expect(page.getByText('Welcome to EduTrack')).toBeVisible({ timeout: 15000 });
  });

  test('Student Login Flow', async ({ page }) => {
    // --- LANDING PAGE ---
    
    // Check Landing Page Elements
    await expect(page.getByText('Please select your role')).toBeVisible();

    // Click "Login as Student"
    // Flutter buttons typically expose their text content to accessibility
    await page.getByRole('button', { name: 'Login as Student' }).click();

    // --- LOGIN PAGE ---
    
    // Verify we are on Login Page
    await expect(page.getByText('Sign in to continue')).toBeVisible();

    // Fill Student ID
    // We target the TextField by its label
    const idInput = page.getByLabel('Student ID');
    await idInput.click();
    await idInput.fill('STU1001');

    // Fill Password
    const passwordInput = page.getByLabel('Password');
    await passwordInput.click();
    await passwordInput.fill('password123');

    // Click Login
    await page.getByRole('button', { name: 'Login' }).click();

    // --- DASHBOARD ---
    
    // Verify successful redirection to Dashboard
    // We explicitly added a key for text, but Playwright sees the rendered text "Dashboard Overview"
    await expect(page.getByText('Dashboard Overview')).toBeVisible({ timeout: 10000 });
    
    // Verify Student Name (assuming mock data is "Sarah Smith" or similar from your code)
    // You might need to adjust this expected text based on your actual mock data
    await expect(page.getByText('Sarah Smith')).toBeVisible();
  });

  test('Admin Login Navigation', async ({ page }) => {
    // Click "Login as Admin"
    await page.getByRole('button', { name: 'Login as Admin' }).click();

    // Verify Admin Login Page
    await expect(page.getByText('Sign in to access admin dashboard')).toBeVisible();
    
    // Verify Input Label changes to Admin ID
    await expect(page.getByLabel('Admin ID')).toBeVisible();
  });
});
```

## 5. Running Tests

1.  **Start your Flutter App** in one terminal:
    ```bash
    // Run on a specific port matching playwright.config.ts
    flutter run -d chrome --web-port 3000 --web-renderer html
    ```
    *Tip: Using `--web-renderer html` can sometimes make DOM debugging easier, but `canvaskit` (default) also supports the accessibility tree used above.*

2.  **Run Playwright** in another terminal:
    ```bash
    npx playwright test
    ```

3.  **View Report**:
    ```bash
    npx playwright show-report
    ```

## Troubleshooting Flutter Web Testing

- **Timeouts**: Flutter Web apps have a heavy initial load. Increase timeouts in `playwright.config.ts` if tests fail immediately.
- **Selectors**: Avoid `css` selectors (`div > span`) as Flutter's DOM structure is complex and unstable. Always prefer:
    - `getByRole('button', { name: ... })`
    - `getByText(...)`
    - `getByLabel(...)`
- **Semantics**: If Playwright cannot find an element, ensure `Semantics()` widgets are wrapping the UI components in your Dart code, or that the Widget (like `TextField`) provides its own semantics.
