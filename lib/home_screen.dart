import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Expense {
  final String description;
  final double amount;
  final String category;

  Expense(
      {required this.description,
      required this.amount,
      required this.category});

  // Convert an Expense object into a Map (for JSON encoding)
  Map<String, dynamic> toJson() => {
        'description': description,
        'amount': amount,
        'category': category,
      };

  // Expense object from a Map (for JSON decoding)
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _monthlyIncome = 0.0;
  final List<Expense> _expenses = [];
  double _remainingBalance = 0.0;

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = 'Food';

  final List<String> _expenseCategories = [
    'Food',
    'Rent',
    'Transport',
    'Books',
    'Utilities',
    'Entertainment',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Persistence Methods

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _monthlyIncome = prefs.getDouble('monthlyIncome') ?? 0;
    });

    // Load expenses
    final String? expensesJsonString = prefs.getString('expenses');
    if (expensesJsonString != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(expensesJsonString);
        setState(() {
          _expenses.clear(); // Clear existing list before loading
          _expenses.addAll(decodedList
              .map((item) => Expense.fromJson(item as Map<String, dynamic>)));
        });
      } catch (e) {
        print('Error decoding expenses JSON: $e');
        // Handle corrupted data, e.g., clear it or show an error
        await prefs.remove('expenses');
      }
    }
    _calculateBalance();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('monthlyIncome', _monthlyIncome);

    final String expensesJsonString =
        jsonEncode(_expenses.map((e) => e.toJson()).toList());
    await prefs.setString('expenses', expensesJsonString);
  }

  // End Persistence Methods

  // Function to calculate the remaining balance
  void _calculateBalance() {
    double totalExpenses = _expenses.fold(0, (sum, item) => sum + item.amount);
    setState(() {
      _remainingBalance = _monthlyIncome - totalExpenses;
    });
    _saveData();
  }

  void _addExpense() {
    final String description = _descriptionController.text.trim();
    final double? amount = double.tryParse(_amountController.text.trim());

    if (description.isNotEmpty && amount != null && amount > 0) {
      setState(() {
        _expenses.add(Expense(
          description: description,
          amount: amount,
          category: _selectedCategory,
        ));
        _descriptionController.clear();
        _amountController.clear();
        _selectedCategory = 'Food';
      });
      _calculateBalance();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please enter a valid description and amount for the expense.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Function to delete an expense
  void _deleteExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
    _calculateBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Icon(
          Icons.account_balance_wallet,
          size: 30,
          // color: Colors.white.withOpacity(0.9),
          shadows: const [
            Shadow(
              offset: Offset(3.0, 3.0),
              blurRadius: 6.0,
              color: Color.fromARGB(100, 0, 0, 0),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Monthly Income (\$)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'e.g., 1000',
                          prefixIcon: const Icon(Icons.attach_money,
                              color: Colors.blueAccent),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.blue.shade50,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _monthlyIncome = double.tryParse(value) ?? 0;
                          });
                          _calculateBalance();
                        },
                        controller: TextEditingController(
                            text: _monthlyIncome == 0
                                ? ''
                                : _monthlyIncome.toString()),
                      ),
                    ],
                  ),
                ),
              ),

              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add New Expense',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: 'Description (e.g., Groceries)',
                          prefixIcon: const Icon(Icons.description,
                              color: Colors.deepPurpleAccent),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.purple.shade50,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Amount (\$)',
                          prefixIcon: const Icon(Icons.money,
                              color: Colors.deepPurpleAccent),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.purple.shade50,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          prefixIcon: const Icon(Icons.category,
                              color: Colors.deepPurpleAccent),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.purple.shade50,
                        ),
                        items: _expenseCategories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _addExpense,
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text(
                            'Add Expense',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Your Expenses List Card
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Expenses',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _expenses.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                'No expenses added yet.',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _expenses.length,
                              itemBuilder: (context, index) {
                                final expense = _expenses[index];
                                return Dismissible(
                                  key: Key(expense.description +
                                      expense.amount.toString() +
                                      index.toString()),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    _deleteExpense(index);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '${expense.description} dismissed')),
                                    );
                                  },
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20.0),
                                    color: Colors.redAccent,
                                    child: const Icon(Icons.delete,
                                        color: Colors.white),
                                  ),
                                  child: Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ListTile(
                                      title: Text(
                                        expense.description,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text(expense.category),
                                      trailing: Text(
                                        '-\$${expense.amount.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.blue.shade100,
                                        child: Icon(
                                            _getCategoryIcon(expense.category),
                                            color: Colors.blue.shade800),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),

              // Budget Summary Card
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Budget Summary',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryRow(
                          'Total Income:', _monthlyIncome, Colors.blue),
                      _buildSummaryRow(
                        'Total Expenses:',
                        _expenses.fold(0.0, (sum, item) => sum + item.amount),
                        Colors.red,
                      ),
                      const Divider(
                          height: 24, thickness: 1, color: Colors.grey),
                      _buildSummaryRow(
                        'Remaining Balance:',
                        _remainingBalance,
                        _remainingBalance >= 0
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        isLarge: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build summary rows
  Widget _buildSummaryRow(String label, double value, Color valueColor,
      {bool isLarge = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isLarge ? 20 : 16,
              fontWeight: isLarge ? FontWeight.bold : FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isLarge ? 22 : 18,
              fontWeight: isLarge ? FontWeight.bold : FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to get an icon based on category
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.fastfood;
      case 'Rent':
        return Icons.home;
      case 'Transport':
        return Icons.directions_bus;
      case 'Books':
        return Icons.book;
      case 'Utilities':
        return Icons.lightbulb;
      case 'Entertainment':
        return Icons.movie;
      default:
        return Icons.category;
    }
  }
}
