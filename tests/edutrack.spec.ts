// import { test, expect } from '@playwright/test';

// test.describe('EduTrack E2E Tests', () => {

//     test.beforeEach(async ({ page }) => {
//         // 1. Go to the app URL
//         // Ensure baseURL is set in playwright.config.ts or pass full URL here
//         await page.goto('/');

//         // 2. Wait for the app to hydrate/render
//         await expect(page.getByText('Welcome to EduTrack')).toBeVisible({ timeout: 15000 });
//     });

//     test('Student Login Flow', async ({ page }) => {
//         // --- LANDING PAGE ---
//         await expect(page.getByText('Please select your role')).toBeVisible();

//         // Click "Login as Student"
//         await page.getByRole('button', { name: 'Login as Student' }).click();

//         // --- LOGIN PAGE ---
//         await expect(page.getByText('Sign in to continue')).toBeVisible({ timeout: 5000 });

//         // Fill Student ID
//         // Using label selector as defined in our Semantics/InputDecoration
//         const idInput = page.getByLabel('Student ID');
//         await idInput.click();
//         await idInput.fill('STU1001');

//         // Fill Password
//         const passwordInput = page.getByLabel('Password');
//         await passwordInput.click();
//         await passwordInput.fill('password123');

//         // Click Login
//         await page.getByRole('button', { name: 'Login' }).click();

//         // --- DASHBOARD ---

//         // Verify successful redirection to Dashboard
//         await expect(page.getByText('Dashboard Overview')).toBeVisible({ timeout: 10000 });

//         // Verify Student Name
//         await expect(page.getByText('Sarah Smith')).toBeVisible();
//     });

//     test('Admin Login Navigation', async ({ page }) => {
//         // Click "Login as Admin"
//         await page.getByRole('button', { name: 'Login as Admin' }).click();

//         // Verify Admin Login Page
//         await expect(page.getByText('Sign in to access admin dashboard')).toBeVisible();

//         // Verify Input Label changes to Admin ID
//         await expect(page.getByLabel('Admin ID')).toBeVisible();
//     });
// });
