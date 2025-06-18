import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedbackController extends GetxController {
  final supabase = Supabase.instance.client;

  var allFeedbackList = <Map<String, dynamic>>[].obs;
  var tailorFeedbackList = <Map<String, dynamic>>[].obs;
  var tailorAverageRatings = <String, double>{}.obs; // Stores tailorId -> average rating
  var isLoading = true.obs;

  // For all feedbacks
  double get averageRating {
    if (tailorFeedbackList.isEmpty) return 0.0;
    final totalRating = tailorFeedbackList.fold<double>(
      0.0,
          (sum, feedback) => sum + _convertToDouble(feedback['rating']),
    );
    return totalRating / tailorFeedbackList.length;
  }

  // Get average rating for a specific tailor
  double getAverageRatingForTailor(String tailorId) {
    return tailorAverageRatings[tailorId] ?? 0.0;
  }

  int get totalReviews => tailorFeedbackList.length;

  @override
  void onInit() {
    super.onInit();
    fetchAllFeedback();
    fetchAllTailorAverageRatings();
  }

  /// Convert numeric values to double safely
  double _convertToDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return 0.0; // Default fallback
  }

  /// Fetch average ratings for all tailors
  Future<void> fetchAllTailorAverageRatings() async {
    try {
      final response = await supabase
          .from('feedback')
          .select('tailor_id, rating');

      if (response != null && response is List) {
        // Group ratings by tailor_id
        final ratingsByTailor = <String, List<double>>{};

        for (final feedback in response) {
          final tailorId = feedback['tailor_id'] as String;
          final rating = _convertToDouble(feedback['rating']); // Safely convert to double

          ratingsByTailor.putIfAbsent(tailorId, () => []).add(rating);
        }

        // Calculate averages
        for (final entry in ratingsByTailor.entries) {
          final average = entry.value.reduce((a, b) => a + b) / entry.value.length;
          tailorAverageRatings[entry.key] = average;
        }
      }
    } catch (e) {
      print("Error fetching average ratings: $e");
    }
  }

  /// Fetch all feedback (used in StoreScreen)
  Future<void> fetchAllFeedback() async {
    isLoading.value = true;
    try {
      final response = await supabase
          .from('feedback')
          .select('*, users(first_name, last_name), tailor(shop_name)')
          .order('created_at', ascending: false);

      if (response != null && response is List) {
        allFeedbackList.value = response.map((feedback) {
          final createdAt = DateTime.parse(feedback['created_at']).toLocal();
          final formattedDate =
              "${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}";

          return {
            'user_name':
            "${feedback['users']['first_name']} ${feedback['users']['last_name']}",
            'tailor_name': feedback['tailor']['shop_name'] ?? 'Unknown Tailor',
            'rating': _convertToDouble(feedback['rating']), // Safely convert to double
            'comments': feedback['comments'],
            'created_at': formattedDate,
          };
        }).toList();
      } else {
        allFeedbackList.clear();
      }
    } catch (e) {
      print("Error fetching all feedback: $e");
      allFeedbackList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch feedback for a specific tailor
  Future<void> fetchFeedbackForTailor(String tailorId) async {
    isLoading.value = true;
    try {
      final response = await supabase
          .from('feedback')
          .select('*, users(first_name, last_name), tailor(shop_name)')
          .eq('tailor_id', tailorId)
          .order('created_at', ascending: false);

      if (response != null && response is List) {
        tailorFeedbackList.value = response.map((feedback) {
          final createdAt = DateTime.parse(feedback['created_at']).toLocal();
          final formattedDate =
              "${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}";

          return {
            'user_name':
            "${feedback['users']['first_name']} ${feedback['users']['last_name']}",
            'tailor_name': feedback['tailor']['shop_name'] ?? 'Unknown Tailor',
            'rating': _convertToDouble(feedback['rating']), // Safely convert to double
            'comments': feedback['comments'],
            'created_at': formattedDate,
          };
        }).toList();

        // Calculate average rating for this tailor
        final ratings = tailorFeedbackList.map((f) => _convertToDouble(f['rating'])).toList();
        final avgRating = ratings.reduce((a, b) => a + b) / ratings.length;
        tailorAverageRatings[tailorId] = avgRating;
      } else {
        tailorFeedbackList.clear();
      }
    } catch (e) {
      print("Error fetching feedback for tailor: $e");
      tailorFeedbackList.clear();
    } finally {
      isLoading.value = false;
    }
  }
}