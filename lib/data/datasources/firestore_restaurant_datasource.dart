import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:university_delivery_app/core/constants/app_constants.dart';
import 'package:university_delivery_app/data/models/restaurant_model.dart';

abstract class FirestoreRestaurantDataSource {
  Future<List<RestaurantModel>> getRestaurants();
  Future<RestaurantModel?> getRestaurantById(String id);
  Stream<List<RestaurantModel>> restaurantsStream();
}

class FirestoreRestaurantDataSourceImpl implements FirestoreRestaurantDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<RestaurantModel>> getRestaurants() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.restaurantsCollection)
          .get();

      return snapshot.docs
          .map((doc) => RestaurantModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get restaurants: $e');
    }
  }

  @override
  Future<RestaurantModel?> getRestaurantById(String id) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.restaurantsCollection)
          .doc(id)
          .get();

      if (!doc.exists) return null;

      return RestaurantModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get restaurant: $e');
    }
  }

  @override
  Stream<List<RestaurantModel>> restaurantsStream() {
    return _firestore
        .collection(AppConstants.restaurantsCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RestaurantModel.fromFirestore(doc))
            .toList());
  }
}

