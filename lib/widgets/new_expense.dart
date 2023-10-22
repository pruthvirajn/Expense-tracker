import '../models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  // var _enteredTitle = "";
  // void _saveTitleInput(String inputValue) {
  // _enteredTitle = inputValue;
  // }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = (enteredAmount == null || enteredAmount <= 0);
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title,amount,date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("Okay"),
            ),
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(
      Expense(
          amount: enteredAmount,
          title: _titleController.text,
          date: _selectedDate!,
          category: _selectedCategory),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;

        return SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            autocorrect: true,
                            maxLength: 20,
                            decoration: const InputDecoration(
                              labelText: "Title",
                            ),
                            // onChanged: _saveTitleInput,
                            controller: _titleController,
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                prefixText: '\$', labelText: "Amount"),
                            controller: _amountController,
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      autocorrect: true,
                      maxLength: 20,
                      decoration: const InputDecoration(
                        labelText: "Title",
                      ),
                      // onChanged: _saveTitleInput,
                      controller: _titleController,
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (width >= 600)
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              if (value == null) {
                                return;
                              }
                              _selectedCategory = value;
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Text( formatter.format(_selectedDate!) ?? 'No date selected'),
                              Text(_selectedDate != null
                                  ? formatter.format(_selectedDate!)
                                  : "No selected date"),
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                prefixText: '\$', labelText: "Amount"),
                            controller: _amountController,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Text( formatter.format(_selectedDate!) ?? 'No date selected'),
                              Text(_selectedDate != null
                                  ? formatter.format(_selectedDate!)
                                  : "No selected date"),
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (width >= 600)
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel "),
                        ),
                        ElevatedButton(
                          onPressed: () => {
                            _submitExpenseData(),
                            setState(() {
                              _titleController.clear();
                              _amountController.clear();
                              _selectedDate = null;
                              _selectedCategory = Category.leisure;
                            }),
                            Navigator.pop(context)
                          },
                          child: const Text('Save Expense'),
                        )
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              if (value == null) {
                                return;
                              }
                              _selectedCategory = value;
                            });
                          },
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel "),
                        ),
                        ElevatedButton(
                          onPressed: () => {
                            _submitExpenseData(),
                            setState(() {
                              _titleController.clear();
                              _amountController.clear();
                              _selectedDate = null;
                              _selectedCategory = Category.leisure;
                            }),
                            Navigator.pop(context)
                          },
                          child: const Text('Save Expense'),
                        )
                      ],
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
