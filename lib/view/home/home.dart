import 'package:fundora/common/card.dart';
import 'package:fundora/viewmodels/themeviewmodel.dart';
import 'package:fundora/viewmodels/userviewmodel.dart';
import 'package:fundora/viewmodels/cardviewmodel.dart';
import 'package:fundora/model/creditcard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback goToSettings;
  const HomeScreen({super.key, required this.goToSettings});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool showCardNumber = false;
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cardHolderController = TextEditingController();
  final cvvController = TextEditingController();
  bool isEditing = false;
  int? editIndex;

  @override
  void initState() {
    super.initState();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final cardViewModel =
          Provider.of<CreditCardViewModel>(context, listen: false);
      cardViewModel.getUserCard(uid);
    }
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryDateController.dispose();
    cardHolderController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  void clearControllers() {
    cardNumberController.clear();
    expiryDateController.clear();
    cardHolderController.clear();
    cvvController.clear();
  }

  Future<void> saveCard(BuildContext context) async {
    if (cvvController.text.length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("CVV must be 3 digits"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final expiryDatePattern = RegExp(r'^\d{2}/\d{2}');
    if (!expiryDatePattern.hasMatch(expiryDateController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Expiry date format must be XX/XX"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    try {
      final cardViewModel =
          Provider.of<CreditCardViewModel>(context, listen: false);
      bool success;
      String uid = FirebaseAuth.instance.currentUser!.uid;

      if (isEditing && editIndex != null) {
        // Update existing card
        success = await cardViewModel.updateCard(
          uid: uid,
          index: editIndex!,
          cardNumber: cardNumberController.text,
          expiryDate: expiryDateController.text,
          cardHolder: cardHolderController.text,
          cvv: cvvController.text,
        );
      } else {
        // Save new card
        success = await cardViewModel.saveCreditCard(
          uid: uid,
          cardNumber: cardNumberController.text,
          expiryDate: expiryDateController.text,
          cardHolder: cardHolderController.text,
          cvv: cvvController.text,
        );
      }

      if (success) {
        clearControllers();
        isEditing = false;
        editIndex = null;
        if (context.mounted) Navigator.of(context).pop();
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to save card")),
          );
        }
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving card: $error")),
        );
      }
    }
  }

  Future<void> addCard(BuildContext context) async {
    clearControllers();
    isEditing = false;
    editIndex = null;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Credit Card'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: cardNumberController,
                  decoration: const InputDecoration(labelText: "Card Number"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: expiryDateController,
                  decoration: const InputDecoration(labelText: "Expiry Date"),
                  keyboardType: TextInputType.datetime,
                ),
                TextField(
                  controller: cardHolderController,
                  decoration: const InputDecoration(labelText: "Card Holder"),
                ),
                TextField(
                  controller: cvvController,
                  decoration: const InputDecoration(labelText: "CVV"),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                clearControllers();
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await saveCard(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> editCard(BuildContext context) async {
    final cardViewModel =
        Provider.of<CreditCardViewModel>(context, listen: false);
    if (cardViewModel.cardModel.isNotEmpty) {
      int index = 0;
      CreditCard card = cardViewModel.cardModel[index];
      cardNumberController.text = card.cardNumber ?? "";
      expiryDateController.text = card.expiryDate ?? "";
      cardHolderController.text = card.cardHolder ?? "";
      cvvController.text = card.cvv ?? "";
      isEditing = true;
      editIndex = index;

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit Credit Card'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: cardNumberController,
                    decoration: const InputDecoration(labelText: "Card Number"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: expiryDateController,
                    decoration: const InputDecoration(labelText: "Expiry Date"),
                    keyboardType: TextInputType.datetime,
                  ),
                  TextField(
                    controller: cardHolderController,
                    decoration: const InputDecoration(labelText: "Card Holder"),
                  ),
                  TextField(
                    controller: cvvController,
                    decoration: const InputDecoration(labelText: "CVV"),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  clearControllers();
                  isEditing = false;
                  editIndex = null;
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await saveCard(context);
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No credit cards to edit.")),
      );
    }
  }

  Future<void> deleteCard(BuildContext context, int index) async {
    final cardViewModel =
        Provider.of<CreditCardViewModel>(context, listen: false);
    if (cardViewModel.cardModel.isNotEmpty) {
      if (index >= 0 && index < cardViewModel.cardModel.length) {
        bool isConfirmed = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Delete Credit Card'),
                  content:
                      const Text('Are you sure you want to delete this card?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                );
              },
            ) ??
            false;

        if (isConfirmed) {
          String uid = FirebaseAuth.instance.currentUser!.uid;
          try {
            bool success = await cardViewModel.deleteCreditCard(
              uid: uid,
              index: index,
            );

            if (success) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Card deleted successfully.")),
                );
                setState(() {
                  cardViewModel.getUserCard(uid);
                });
              }
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to delete card.")),
                );
              }
            }
          } catch (error) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error deleting card: $error")),
              );
            }
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid card index.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No credit cards to delete.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserViewModel, Themeviewmodel>(
      builder: (context, userViewModel, themeViewModel, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              'Welcome ${userViewModel.name}',
            ),
            automaticallyImplyLeading: false,
            centerTitle: true,
            actions: [
              IconButton(
                icon: CircleAvatar(
                  radius: 15,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: ClipOval(
                    child: Image.network(
                      'https://i.pravatar.cc/300',
                      fit: BoxFit.cover,
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
                onPressed: widget.goToSettings,
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Balance Section
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          color: themeViewModel.isDarkMode
                              ? Colors.grey
                              : Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            showCardNumber ? "\$15.000" : "\$ **** ",
                            style: TextStyle(
                              color: themeViewModel.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(
                                () {
                                  showCardNumber = !showCardNumber;
                                },
                              );
                            },
                            child: Icon(Icons.remove_red_eye_outlined),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const CardComponent(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          const Text("Edit"),
                          IconButton(
                            onPressed: () async {
                              await editCard(context);
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 30),
                      child: Row(
                        children: [
                          const Text("Add"),
                          IconButton(
                            onPressed: () async {
                              await addCard(context);
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          const Text("Delete"),
                          IconButton(
                            onPressed: () async {
                              int index = 0;
                              await deleteCard(context, index);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Quick Actions
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildQuickAction(
                            icon: Icons.send_rounded,
                            label: 'Send',
                            color: Colors.blue,
                          ),
                          _buildQuickAction(
                            icon: Icons.account_balance_wallet,
                            label: 'Pay',
                            color: Colors.green,
                          ),
                          _buildQuickAction(
                            icon: Icons.add_card,
                            label: 'Top Up',
                            color: Colors.orange,
                          ),
                          _buildQuickAction(
                            icon: Icons.more_horiz,
                            label: 'More',
                            color: Colors.purple,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Recent Transactions
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildTransactionItem(
                        icon: Icons.shopping_bag_outlined,
                        title: 'Shopping',
                        subtitle: 'Amazon',
                        amount: -85.00,
                        date: 'Today',
                      ),
                      _buildTransactionItem(
                        icon: Icons.fastfood_outlined,
                        title: 'Food',
                        subtitle: 'Restaurant',
                        amount: -32.50,
                        date: 'Yesterday',
                      ),
                      _buildTransactionItem(
                        icon: Icons.attach_money,
                        title: 'Salary',
                        subtitle: 'Company Inc',
                        amount: 2500.00,
                        date: '24 Oct',
                        isIncome: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Consumer<Themeviewmodel>(
      builder: (context, themeViewModel, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: themeViewModel.isDarkMode ? Colors.white : Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required double amount,
    required String date,
    bool isIncome = false,
  }) {
    return Consumer<Themeviewmodel>(
      builder: (context, themeViewModel, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: themeViewModel.isDarkMode ? Colors.white10 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.grey[700]),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: themeViewModel.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: themeViewModel.isDarkMode
                            ? Colors.white70
                            : Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isIncome ? '+' : '-'}\$${amount.abs().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isIncome ? Colors.green : Colors.red,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      color: themeViewModel.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
