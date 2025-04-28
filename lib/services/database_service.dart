// lib/services/database_service.dart
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:project_charon/model/debtor.dart';
import 'package:project_charon/model/transaction.dart';

class DatabaseService {
  final Databases databases;
  final String databaseId =
      '680f312f001559d42ce6'; // Use your database ID from Appwrite
  final String debtorsCollectionId = 'debtors';
  final String transactionsCollectionId = 'transactions';

  DatabaseService({required this.databases});

  // Update the initializeDatabase method in lib/services/database_service.dart
  // Update the initializeDatabase method in lib/services/database_service.dart
  Future<void> initializeDatabase() async {
    try {
      // Instead of checking if the database exists, we'll just try to list the collections
      // This will confirm if we have access to the database
      await databases.listDocuments(
        databaseId: databaseId,
        collectionId: debtorsCollectionId,
      );
      print('Database is accessible and ready');
    } catch (e) {
      print('Error accessing database: $e');
      rethrow;
    }
  }

  // Debtor operations
  Future<models.Document> createDebtor(Debtor debtor) async {
    return await databases.createDocument(
      databaseId: databaseId,
      collectionId: debtorsCollectionId,
      documentId: ID.unique(),
      data: debtor.toMap(),
    );
  }

  Future<models.Document> getDebtor(String id) async {
    return await databases.getDocument(
      databaseId: databaseId,
      collectionId: debtorsCollectionId,
      documentId: id,
    );
  }

  Future<models.DocumentList> getAllDebtors() async {
    return await databases.listDocuments(
      databaseId: databaseId,
      collectionId: debtorsCollectionId,
    );
  }

  Future<models.Document> updateDebtor(Debtor debtor) async {
    return await databases.updateDocument(
      databaseId: databaseId,
      collectionId: debtorsCollectionId,
      documentId: debtor.id,
      data: debtor.toMap(),
    );
  }

  Future<void> deleteDebtor(String id) async {
    // First, delete all transactions for this debtor
    try {
      var transactions = await getTransactionsForDebtor(id);
      for (var transaction in transactions.documents) {
        await databases.deleteDocument(
          databaseId: databaseId,
          collectionId: transactionsCollectionId,
          documentId: transaction.$id,
        );
      }
    } catch (e) {
      print('Error deleting transactions: $e');
      // Continue anyway to try to delete the debtor
    }

    // Then delete the debtor
    await databases.deleteDocument(
      databaseId: databaseId,
      collectionId: debtorsCollectionId,
      documentId: id,
    );
  }

  // Transaction operations
  Future<models.Document> createTransaction(Transaction transaction) async {
    var result = await databases.createDocument(
      databaseId: databaseId,
      collectionId: transactionsCollectionId,
      documentId: ID.unique(),
      data: transaction.toMap(),
    );

    // Update the debtor's current balance
    var debtor = await getDebtor(transaction.debtorId);
    var debtorData = Debtor.fromMap(debtor.data);
    debtorData.currentBalance += transaction.amount;
    await updateDebtor(debtorData);

    return result;
  }

  Future<models.DocumentList> getTransactionsForDebtor(String debtorId) async {
    return await databases.listDocuments(
      databaseId: databaseId,
      collectionId: transactionsCollectionId,
      queries: [Query.equal('debtorId', debtorId), Query.orderDesc('date')],
    );
  }

  Future<void> deleteTransaction(
    String id,
    String debtorId,
    double amount,
  ) async {
    // First update the debtor's balance
    var debtor = await getDebtor(debtorId);
    var debtorData = Debtor.fromMap(debtor.data);
    debtorData.currentBalance -= amount;
    await updateDebtor(debtorData);

    // Then delete the transaction
    await databases.deleteDocument(
      databaseId: databaseId,
      collectionId: transactionsCollectionId,
      documentId: id,
    );
  }
}
