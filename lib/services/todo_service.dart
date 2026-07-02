import 'package:cloud_firestore/cloud_firestore.dart';

class TodoService {
  // Get an instance of Firestore
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reference to the "todos" collection
  static final CollectionReference _todosCollection =
      _firestore.collection('todos');

  // ============================================================
  // TODO 1: CREATE - Add new todo to Firestore
  //
  // Instructions:
  // 1. Use _todosCollection.add() to create a new document
  // 2. The document should have these fields:
  //    - 'task' (String): the todo text
  //    - 'completed' (boolean): false by default
  //    - 'timestamp': use FieldValue.serverTimestamp()
  // 3. Return the DocumentReference
  // ============================================================

  static Future<DocumentReference> addTodo(String task) async {
    return await _todosCollection.add({
      'task': task,
      'completed': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // ============================================================
  // TODO 2: READ - Get todos stream for real-time updates
  //
  // Instructions:
  // 1. Return a stream from _todosCollection
  // 2. Order by 'timestamp' in descending order
  // 3. Use .snapshots() for real-time updates
  // ============================================================

  static Stream<QuerySnapshot> getTodosStream() {
    return _todosCollection
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // ============================================================
  // TODO 3: UPDATE - Toggle todo completion status
  //
  // Instructions:
  // 1. Update the selected document
  // 2. Flip completed from true -> false or false -> true
  // 3. Save updatedAt timestamp
  // ============================================================

  static Future<void> toggleTodo(String id, bool currentStatus) async {
    await _todosCollection.doc(id).update({
      'completed': !currentStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ============================================================
  // TODO 4: UPDATE - Edit todo text
  //
  // Instructions:
  // 1. Update the task field
  // 2. Save updatedAt timestamp
  // ============================================================

  static Future<void> updateTodo(String id, String newTask) async {
    await _todosCollection.doc(id).update({
      'task': newTask,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ============================================================
  // TODO 5: DELETE - Remove a todo
  //
  // Instructions:
  // 1. Delete the selected document
  // ============================================================

  static Future<void> deleteTodo(String id) async {
    await _todosCollection.doc(id).delete();
  }

  // ============================================================
  // TODO 6: BONUS - Delete all completed todos
  //
  // Instructions:
  // 1. Find completed todos
  // 2. Delete them using a WriteBatch
  // ============================================================

  static Future<void> deleteCompletedTodos() async {
    final querySnapshot = await _todosCollection
        .where('completed', isEqualTo: true)
        .get();

    WriteBatch batch = _firestore.batch();

    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}