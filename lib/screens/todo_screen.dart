import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/todo_service.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _editController = TextEditingController();

  // ============================================================
  // CREATE
  // Call TodoService.addTodo() to save a new todo in Firestore
  // ============================================================

  void _addTodo() async {
    if (_controller.text.trim().isEmpty) return;

    try {
      await TodoService.addTodo(_controller.text.trim());

      _controller.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Todo added successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  // ============================================================
  // UPDATE
  // Toggle completed status
  // ============================================================

  void _toggleTodo(String id, bool currentStatus) async {
    await TodoService.toggleTodo(id, currentStatus);
  }

  // ============================================================
  // DELETE
  // ============================================================

  void _deleteTodo(String id) async {
    await TodoService.deleteTodo(id);
  }

  // ============================================================
  // UPDATE
  // Edit task
  // ============================================================

  void _editTodo(DocumentSnapshot todo) {
    _editController.text = todo['task'];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Todo"),
        content: TextField(
          controller: _editController,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_editController.text.trim().isEmpty) return;

              await TodoService.updateTodo(
                todo.id,
                _editController.text.trim(),
              );

              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  // ============================================================
  // BONUS
  // Delete all completed todos
  // ============================================================

  void _deleteCompletedTodos() async {
    await TodoService.deleteCompletedTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firestore Todo App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _deleteCompletedTodos,
          )
        ],
      ),

      body: Column(
        children: [

          // ======================================================
          // Input Section
          // ======================================================

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Enter a task",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTodo,
                  child: const Text("Add"),
                ),
              ],
            ),
          ),

          // ======================================================
          // READ
          // StreamBuilder listens for Firestore changes in real time.
          //
          // Every time a document is:
          //   • Added
          //   • Updated
          //   • Deleted
          //
          // Firestore automatically rebuilds this widget.
          // ======================================================

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: TodoService.getTodosStream(),

              builder: (context, snapshot) {

                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final todos = snapshot.data!.docs;

                if (todos.isEmpty) {
                  return const Center(
                    child: Text("No Todos Yet"),
                  );
                }

                return ListView.builder(
                  itemCount: todos.length,

                  itemBuilder: (context, index) {

                    final todo = todos[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),

                      child: ListTile(

                        // Checkbox toggles completed status
                        leading: Checkbox(
                          value: todo['completed'],

                          onChanged: (_) {
                            _toggleTodo(
                              todo.id,
                              todo['completed'],
                            );
                          },
                        ),

                        // Display task
                        title: Text(
                          todo['task'],

                          style: TextStyle(
                            decoration: todo['completed']
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            // Edit button
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editTodo(todo),
                            ),

                            // Delete button
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteTodo(todo.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}