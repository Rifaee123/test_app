# Testing IDs Documentation

This document lists all the semantic keys (IDs) used in the application for automated testing purposes.

## Auth Feature
| Key Name | ID Value | Description |
|----------|----------|-------------|
| landingPage | `landingPage` | Landing Page Scaffold |
| loginButton | `loginButton` | "Login as Student" button on Landing Page |
| registerButton | `registerButton` | "Login as Admin" button on Landing Page |
| loginPage | `loginPage` | Login Page Scaffold |
| emailInput | `emailInput` | Student/Admin ID Input Field |
| passwordInput | `passwordInput` | Password Input Field |
| loginSubmitButton | `loginSubmitButton` | Login Submit Button |
| forgotPasswordButton | `forgotPasswordButton` | Forgot Password Button |

## Splash Feature
| Key Name | ID Value | Description |
|----------|----------|-------------|
| splashPage | `splashPage` | Splash Page Scaffold |
| appLogo | `appLogo` | Application Logo Icon |
| loadingIndicator | `loadingIndicator` | Loading Shimmer/Spinner |

## Student Features

### Dashboard
| Key Name | ID Value | Description |
|----------|----------|-------------|
| dashboardPage | `dashboardPage` | Dashboard Page Scaffold |
| welcomeText | `dashboardWelcomeText` | "Dashboard Overview" Header Text |
| profileImage | `dashboardProfileImage` | User Profile Avatar in Header |
| notificationButton | `dashboardNotificationButton` | Notifications Button |
| **Navigation** | | |
| navHome | `dashboardNavHome` | Dashboard Sidebar Item |
| navCourses | `dashboardNavCourses` | Curriculum Sidebar Item |
| navMarks | `dashboardNavMarks` | Reports Sidebar Item |
| navProfile | `dashboardNavProfile` | Profile Sidebar Item |
| **Content** | | |
| recentActivityList | `dashboardRecentActivityList` | List of Subjects/Activity |
| recentActivityItem | `dashboardActivityItem_{index}` | Individual Subject/Activity Item (dynamic index) |

### Courses
| Key Name | ID Value | Description |
|----------|----------|-------------|
| coursesPage | `coursesPage` | Courses Page Scaffold |
| courseList | `courseList` | List of Courses |
| courseItem | `courseItem_{index}` | Individual Course Item (dynamic index) |
| backButton | `coursesBackButton` | Back Button (if custom) |

### Marks
| Key Name | ID Value | Description |
|----------|----------|-------------|
| marksPage | `marksPage` | Marks Page Scaffold |
| marksList | `marksList` | Marks Data Table/Card |
| markItem | `markItem_{index}` | Individual Mark Row (dynamic index) |

### Profile
| Key Name | ID Value | Description |
|----------|----------|-------------|
| profilePage | `profilePage` | Profile Page Scaffold |
| editProfileButton | `editProfileButton` | Edit Profile Button |
| saveProfileBtn (Legacy) | `saveProfileBtn` | Save Profile Button (from TestIds) |
| profileImage | `profileImage` | Profile Avatar |

## Admin Feature
| Key Name | ID Value | Description |
|----------|----------|-------------|
| adminHomeView | `adminHomeView` | Admin Home Page Scaffold |
| studentFormView | `studentFormView` | Student Form Page Scaffold |
| studentDetailView | `studentDetailView` | Student Detail Page Scaffold |
| **Home Elements** | | |
| welcomeHeader | `welcomeHeader` | Welcome Header |
| statCardActiveStudents | `statCardActiveStudents` | Active Students Stat Card |
| addStudentBtn | `addStudentBtn` | Add Student Button |
| studentList | `studentList` | List of Students |
| studentItem | `studentItem_{id}` | Student Item (dynamic ID) |
| editStudentBtn | `editStudentBtn_{id}` | Edit Student Button (dynamic ID) |
| deleteStudentBtn | `deleteStudentBtn_{id}` | Delete Student Button (dynamic ID) |
| **Form Elements** | | |
| studentNameInput | `studentNameInput` | Student Name Input |
| studentIdInput | `studentIdInput` | Student ID Input |
| studentEmailInput | `studentEmailInput` | Student Email Input |
| saveStudentBtn | `saveStudentBtn` | Save Student Button |
| cancelFormBtn | `cancelFormBtn` | Cancel Form Button |
