# Student Budget App

## Introduction
Welcome to the Student Budget App This is a simple and attractive mobile application built with Flutter, designed to help students effectively manage their monthly finances. Understanding where your money goes is the first step towards financial independence, and this app provides the core tools to track income and expenses, ensuring you stay on top of your budget.This project was developed as a budget app challenge, focusing on delivering a Minimum Viable Product (MVP) with essential budgeting functionalities and a clean, user-friendly interface.

## What the Project Is About
The Student Budget App aims to empower students by providing a clear overview of their financial situation. It allows users to: 
- Input their monthly income.
- Add individual expenses categorized for better tracking.
- Visualize their spending.
- See their remaining balance in real-time.
The app prioritizes ease of use and visual clarity, making budgeting less daunting and more accessible for students.

## Setting Up the Project
To get this project up and running on your local machine, follow these steps: PrerequisitesFlutter SDK: Ensure you have Flutter installed. If not, follow the official Flutter installation guide: `https://flutter.dev/docs/get-started/installIDE`: Visual Studio Code with the Flutter extension, or Android Studio with the Flutter/Dart plugins.

## Installation Steps
- Clone the Repository:
`git clone https://github.com/SamuelWorld20/BudgetApp.git`

`cd budgetapp`

- Get Dependencies:Navigate to the project root directory in your terminal and run:
`flutter pub get`

This command fetches all the necessary packages defined in pubspec.yaml.
Generate Launcher Icons (Optional, but Recommended)

- Clean and Run the App:To ensure a clean build and launch the app on a connected device or emulator:
`flutter clean`
`flutter run`

The app should now launch, starting with the custom splash screen and then transitioning to the main budget interface.

## Features
The current version of the Student Budget App includes the following minimum viable features:
- Attractive Splash Screen: A visually appealing splash screen with a gradient background and a distinct app icon that matches the app's theme.
- Income Tracking: Easily input and update your monthly income.
- Expense Entry: Add new expenses with a description, amount, and category.
- Categorization: Predefined categories for common student expenses (Food, Rent, Transport, Books, Utilities, Entertainment, Other).
- Real-time Budget Summary: Instantly view your total income, total expenses, and the remaining balance. The balance dynamically updates with each entry and is color-coded (green for positive, red for negative).
- Expense List: A clear list of all added expenses.
- Swipe-to-Delete: Intuitive gesture to remove expenses from the list.
- Data Persistence: Your income and expense data are automatically saved locally on the device using shared_preferences, ensuring your financial records persist even after closing the app.

## Future Enhancements (Things That Can Be Added)
This MVP provides a solid foundation, but there's plenty of room for growth! Here are some ideas for future improvements:
- Recurring Transactions: Implement functionality for recurring income and expenses (e.g., monthly rent, weekly stipend) to reduce manual entry.
- Spending Analytics: Add charts (pie charts, bar graphs) to visualize spending trends by category over time.
- Saving Goals: Allow users to set and track progress towards specific savings goals.
- Detailed History & Filtering: Enhance the transaction history with advanced filtering options (by date, category, amount range).
- Customizable Categories: Enable users to add, edit, and delete their own personalized expense/income categories.
- Bill Reminders: Implement notifications for upcoming bill due dates.
- Multi-Currency Support: Allow users to manage budgets in different currencies.
- User Authentication & Cloud Sync: For multi-device access and backup, integrate Firebase Authentication and Firestore for cloud data storage.
- Data Export: Provide options to export data (e.g., to CSV or PDF) for external analysis.
- Budgeting Periods: Support for weekly, quarterly, or custom budgeting periods in addition to monthly.

## Contribution
We welcome contributions to make this Student Budget App even better! If you have ideas for new features, bug fixes, or improvements, please feel free to:
- Fork the repository.
- Create a new branch for your feature or bug fix
(`git checkout -b feature/your-feature-name or bugfix/fix-bug-name`).
- Make your changes and commit them
(`git commit -m 'feat: Add new feature X'`).
- Push to your branch
(`git push origin feature/your-feature-name`).
- Open a Pull Request (PR) to the main branch of this repository.
---
Please ensure your code adheres to good practices, is well-commented, and includes any necessary tests.

Thank you for checking out the Student Budget App