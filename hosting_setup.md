# Web Hosting Setup Guide

## 1. Build the Web App
You can build the web application using the provided script or manually.

**Option A: Using Script**
Double-click `build_web.bat` in the project root.

**Option B: Manual Command**
Open your terminal in the project root and run:
```bash
flutter build web --release
```

## 2. Firebase Hosting Setup

### Prerequisites
- Install Node.js: https://nodejs.org/
- Install Firebase CLI:
  ```bash
  npm install -g firebase-tools
  ```

### Initialization
1.  **Login to Firebase**:
    ```bash
    firebase login
    ```
2.  **Initialize Project** (if not already done, though `firebase.json` is provided):
    ```bash
    firebase init hosting
    ```
    - Select **"Use an existing project"** and choose your Firebase project.
    - Confirm public directory is `build/web`.
    - Configure as a single-page app (rewrite all urls to /index.html)? **Yes**.

### 3. Deploy
To deploy your application to the web:

```bash
firebase deploy --only hosting
```

Your app will be live at `https://<your-project-id>.web.app`.
