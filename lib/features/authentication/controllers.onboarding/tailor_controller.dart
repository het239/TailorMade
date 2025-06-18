import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../shop/controllers/session_controller.dart';
import '../../shop/models/cartmodel.dart';

class TailorController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  RxList<Map<String, dynamic>> tailors = <Map<String, dynamic>>[].obs;
  RxMap<String, dynamic> tailorDetails = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllTailors();
  }

  Future<void> fetchAllTailors() async {
    try {
      final response = await supabase
          .from('tailor')
          .select('tailor_id, shop_name, available, user_id')
          .order('shop_name', ascending: true);

      if (response.isNotEmpty) {
        tailors.assignAll(List<Map<String, dynamic>>.from(response));
      } else {
        print("No tailors found.");
      }
    } catch (e) {
      print("Error fetching tailors: $e");
    }
  }

  Future<void> fetchTailorDetails(String tailorId) async {
    try {
      final response = await supabase
          .from('tailor')
          .select('shop_name, available, user_id, description')
          .eq('tailor_id', tailorId)
          .limit(1)
          .maybeSingle();

      if (response != null) {
        final userId = response['user_id'];
        print('✅ Fetched Tailor User ID: $userId');

        tailorDetails['shop_name'] = response['shop_name'];
        tailorDetails['available'] = response['available'];
        tailorDetails['description'] = response['description'];

        // Fetch user details (ensure phone is accessible)
        final userResponse = await supabase
            .from('users')
            .select('user_id, phone')
            .eq('user_id', userId)
            .limit(1)
            .maybeSingle();

        print('🛠 User response: $userResponse');

        if (userResponse != null) {
          tailorDetails['phone'] = userResponse['phone'];
          print('📞 User phone: ${userResponse['phone']}');
        } else {
          print("⚠️ User phone details not found. Possible RLS issue.");
        }

        // Fetch address
        final addressResponse = await supabase
            .from('addresses')
            .select('street, city, state, postal_code')
            .eq('user_id', userId)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle();

        if (addressResponse != null) {
          tailorDetails['address'] =
          '${addressResponse['street']}, ${addressResponse['city']}, ${addressResponse['state']} ${addressResponse['postal_code']}';
        } else {
          print("⚠️ User address details not found.");
        }
      } else {
        print("⚠️ Tailor details not found.");
      }
    } catch (e) {
      print("❌ Error fetching tailor details: $e");
    }
  }

  Future<void> fetchServicePrice(CartItemModel item) async {
    try {
      print("Fetching service price for Shop: ${item.shopName}, Service: ${item.style}");

      // Fetch tailor_id based on shop_name
      final tailorResponse = await supabase
          .from('tailor') // Ensure this table name is correct
          .select('tailor_id')
          .eq('shop_name', item.shopName)
          .single();

      if (tailorResponse == null || tailorResponse['tailor_id'] == null) {
        print("⚠️ Tailor ID not found for shop name: ${item.shopName}");
        item.price.value = 0.0; // Update price reactively
        return;
      }

      final tailorId = tailorResponse['tailor_id'];
      print("Fetched Tailor ID: $tailorId");

      // Fetch service price based on tailor_id and service_name
      final response = await supabase
          .from('tailorservices') // Ensure this table name is correct
          .select('price')
          .eq('tailor_id', tailorId)
          .eq('service_name', item.style)
          .limit(1)
          .single();

      if (response != null && response['price'] != null) {
        item.price.value = response['price']; // Update reactive price
        print("Fetched service price: ${item.price.value}");
      } else {
        print("⚠️ Service price not found.");
        item.price.value = 0.0; // Set price to 0 if not found
      }
    } catch (e) {
      print("❌ Error fetching service price: $e");
      item.price.value = 0.0; // Handle error by setting price to 0 reactively
    }
  }

  Future<void> searchTailors(String query) async {
    try {
      if (query.isEmpty) {
        await fetchAllTailors();
        return;
      }

      final response = await supabase
          .from('tailor')
          .select('tailor_id, shop_name, available, user_id')
          .ilike('shop_name', '%$query%') // ✅ Fix the query format
          .order('shop_name', ascending: true);

      tailors.assignAll(List<Map<String, dynamic>>.from(response));
    } catch (e) {
      print("Error searching tailors: $e");
    }
  }

  void refreshTailors() {
    fetchAllTailors();
  }
}