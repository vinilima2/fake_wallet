# Fake Wallet

![Logo Application](android/app/src/main/res/mipmap-xxhdpi/ic_launcher_foreground.png)

**Fake Wallet** is an Android/iOS application built using Flutter that allows users to track and manage their expenses offline. With features like expense categorization, interactive charts, XLS export, and more, **Fake Wallet** is a convenient solution for users who want to track their spending habits while ensuring privacy and ease of use.

## Features

- **Expense Tracking:** Add and categorize expenses.
- **Charts:** View your expenses visually with interactive charts.
- **Offline Mode:** All data is stored locally with Drift database for offline access.
- **Export to XLS:** Export your expense data into a .xls file.
- **User-friendly Interface:** Designed with simplicity in mind for a smooth experience.

## Technology Stack

- **Flutter:** Framework for building natively compiled applications for mobile, web, and desktop.
- **Drift Database:** Local SQLite database used for storing expense records offline.
- **Dart:** The programming language used for building the app.

## Installation

To get started with **Fake Wallet** on your local machine:

1. **Clone the repository:**

    ```bash
    git clone https://github.com/your-username/fake-wallet.git
    cd fake-wallet
    ```

2. **Install dependencies:**

    Make sure you have [Flutter](https://flutter.dev/docs/get-started/install) installed on your system.

    ```bash
    flutter pub get
    ```

3. **Run the app:**

    You can run the app on an Android/iOS emulator or a connected device.

    ```bash
    flutter run
    ```

## Features in Detail

### Expense Tracking

You can easily add, edit, and delete expenses. Each expense can be categorized by type, such as Food, Entertainment, Transport, etc.

### Interactive Charts

View your spending patterns over time with beautiful charts. The app provides pie charts and bar graphs to make understanding your expenses visually appealing and easy.

### Export to XLS

Want to keep a copy of your expenses outside the app? You can export all your expense data into an XLS file for easy sharing or record keeping.

### Offline Mode

Fake Wallet ensures that your data is stored locally in the Drift database. You can continue tracking your expenses even when you don’t have an internet connection.

## Screenshots

| Home Screen | Expense Add Screen | Delete Expense Screen | Export Expenses Screen |
|-------------|--------------------|-----------------------|------------------------|
| ![Home Screen](/screenshots/home_screen.png) | ![Expense Add Screen](/screenshots/new_expense.png) | ![Delete Expense Screen](/screenshots/expense_exclusion.png) | ![Export Expenses Screen](/screenshots/export_expenses.png) |

## Acknowledgments

- [Flutter](https://flutter.dev/)
- [Drift Database](https://drift.simonbinder.eu/)
- [Fl Chart](https://pub.dev/packages/fl_chart)
- [XLS export library](https://pub.dev/packages/excel)