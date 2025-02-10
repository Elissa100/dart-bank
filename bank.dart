import 'dart:io';

class BankAccount {
  String accountNumber;
  String owner;
  double _balance = 0;

  BankAccount(this.accountNumber, this.owner); // Constructor

  // Deposit money
  void deposit(double amount) {
    if (amount >= 500) {
      _balance += amount;
      print("✅ Deposited \$$amount successfully! New balance: \$$_balance");
    } else {
      print("❌ Minimum deposit amount is \$500.");
    }
  }

  // Withdraw money
  void withdraw(double amount) {
    if (amount > _balance) {
      print("❌ Insufficient funds! Your balance is \$$_balance.");
    } else {
      _balance -= amount;
      print("✅ Withdrawn \$$amount. Remaining balance: \$$_balance.");
    }
  }

  double getBalance() {
    return _balance;
  }

  void showAccountInfo() {
    print("\n💳 Account Info:");
    print("🔹 Account Number: $accountNumber");
    print("🔹 Owner: $owner");
    print("🔹 Balance: \$$_balance\n");
  }
}

class SavingsAccount extends BankAccount {
  double interestRate;

  SavingsAccount(String accountNumber, String owner, this.interestRate)
      : super(accountNumber, owner);

  // Overriding deposit method to add interest
  @override
  void deposit(double amount) {
    if (amount >= 500) {
      double interest = (amount * interestRate) / 100;
      super.deposit(amount + interest);
      print("🎉 Interest of \$$interest added! New balance: \$${getBalance()}");
    } else {
      print("❌ Minimum deposit is \$500.");
    }
  }
}

// 🔹 List to store accounts
List<BankAccount> accounts = [];

// 🔹 Admin credentials
const String adminUsername = "admin";
const String adminPassword = "admin123";

// 🔹 Function to create an account
void createAccount() {
  stdout.write("Enter account number: ");
  String accNumber = stdin.readLineSync()!;

  // Check if account already exists
  if (accounts.any((acc) => acc.accountNumber == accNumber)) {
    print("❌ Account already exists! Try another account number.");
    return;
  }

  stdout.write("Enter your name: ");
  String ownerName = stdin.readLineSync()!;

  stdout.write("Select account type (1: Regular, 2: Savings): ");
  int choice = int.parse(stdin.readLineSync()!);

  if (choice == 2) {
    stdout.write("Enter interest rate (%): ");
    double interestRate = double.parse(stdin.readLineSync()!);
    accounts.add(SavingsAccount(accNumber, ownerName, interestRate));
  } else {
    accounts.add(BankAccount(accNumber, ownerName));
  }

  print("🎉 Account created successfully!");
}

// 🔹 Function to log in as a user
BankAccount? loginUser() {
  stdout.write("Enter account number to login: ");
  String accNumber = stdin.readLineSync()!;

  try {
    return accounts.firstWhere((account) => account.accountNumber == accNumber);
  } catch (e) {
    print("❌ Account not found. Please try again.");
    return null;
  }
}

// 🔹 Function to log in as an admin
bool loginAdmin() {
  stdout.write("Enter Admin Username: ");
  String username = stdin.readLineSync()!;
  stdout.write("Enter Admin Password: ");
  String password = stdin.readLineSync()!;

  if (username == adminUsername && password == adminPassword) {
    print("✅ Admin login successful!");
    return true;
  } else {
    print("❌ Invalid credentials!");
    return false;
  }
}

// 🔹 Function for admin to view all accounts
void showAllAccounts() {
  if (accounts.isEmpty) {
    print("⚠️ No accounts found.");
    return;
  }

  print("\n📜 **All Bank Accounts**");
  for (var acc in accounts) {
    acc.showAccountInfo();
  }
}

// 🔹 Menu for user interaction
void main() {
  while (true) {
    print("\n🏦 **Welcome to Dart Bank**");
    print("1️⃣  Create Account");
    print("2️⃣  Login as User");
    print("3️⃣  Login as Admin");
    print("4️⃣  Exit");
    stdout.write("👉 Select an option: ");
    int option = int.parse(stdin.readLineSync()!);

    if (option == 1) {
      createAccount();
    } else if (option == 2) {
      BankAccount? userAccount = loginUser();
      if (userAccount != null) {
        // User actions menu
        while (true) {
          print("\n🏦 **User Dashboard**");
          print("1️⃣  Deposit Money");
          print("2️⃣  Withdraw Money");
          print("3️⃣  Check Balance");
          print("4️⃣  Show Account Info");
          print("5️⃣  Logout");
          stdout.write("👉 Select an option: ");
          int userChoice = int.parse(stdin.readLineSync()!);

          switch (userChoice) {
            case 1:
              stdout.write("Enter deposit amount: ");
              double depositAmount = double.parse(stdin.readLineSync()!);
              userAccount.deposit(depositAmount);
              break;
            case 2:
              stdout.write("Enter withdrawal amount: ");
              double withdrawAmount = double.parse(stdin.readLineSync()!);
              userAccount.withdraw(withdrawAmount);
              break;
            case 3:
              print("💰 Current Balance: \$${userAccount.getBalance()}");
              break;
            case 4:
              userAccount.showAccountInfo();
              break;
            case 5:
              print("👋 Logging out...");
              break;
            default:
              print("❌ Invalid option! Please try again.");
          }

          if (userChoice == 5) break; // Exit user menu
        }
      }
    } else if (option == 3) {
      if (loginAdmin()) {
        while (true) {
          print("\n🏦 **Admin Dashboard**");
          print("1️⃣  View All Accounts");
          print("2️⃣  Logout");
          stdout.write("👉 Select an option: ");
          int adminChoice = int.parse(stdin.readLineSync()!);

          switch (adminChoice) {
            case 1:
              showAllAccounts();
              break;
            case 2:
              print("👋 Logging out...");
              break;
            default:
              print("❌ Invalid option! Please try again.");
          }

          if (adminChoice == 2) break; // Exit admin menu
        }
      }
    } else if (option == 4) {
      print("👋 Thank you for using Dart Bank. Goodbye!");
      exit(0);
    } else {
      print("❌ Invalid option! Please try again.");
    }
  }
}
