import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  // User details
  RxString userId = ''.obs;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString email = ''.obs;
  RxString phone = ''.obs;
  RxString tailorId = ''.obs;
  RxString shopName = ''.obs;
  RxString description = ''.obs; // Add description field
  RxBool isAvailable = false.obs;
  RxBool isTailor = false.obs;

  // User addresses
  RxList<Map<String, dynamic>> addresses = <Map<String, dynamic>>[].obs;

  // Tailor services
  RxList<Map<String, dynamic>> services = <Map<String, dynamic>>[].obs;

  void setUser({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) {
    this.userId.value = userId;
    this.firstName.value = firstName;
    this.lastName.value = lastName;
    this.email.value = email;
    this.phone.value = phone;

    // Log the user details for debugging
    print('User set: $userId, $firstName, $lastName, $email, $phone');

    // Fetch tailor details if the user is a tailor
    fetchTailorDetails();
    // Fetch user addresses
    fetchUserAddresses();
    // Fetch tailor services
    fetchTailorServices();
  }

  Future<void> fetchTailorDetails() async {
    try {
      final response = await supabase
          .from('tailor')
          .select('tailor_id, shop_name, available, description') // Include description in select
          .eq('user_id', userId.value)
          .maybeSingle();

      // Log the response for debugging
      print('Fetch tailor details response: $response');

      if (response != null) {
        tailorId.value = response['tailor_id'] ?? '';
        shopName.value = response['shop_name'] ?? '';
        description.value = response['description'] ?? ''; // Set description value
        isAvailable.value = response['available'] ?? false;
        isTailor.value = true;

        // Log the tailor details for debugging
        print('Tailor ID: ${tailorId.value}, Shop Name: ${shopName.value}, Available: ${isAvailable.value}');

        // Fetch tailor services after getting the tailor ID
        fetchTailorServices();
      } else {
        isTailor.value = false;
      }
    } catch (e) {
      print("Error fetching tailor details: $e");
      isTailor.value = false;
    }
  }

  Future<void> fetchUserAddresses() async {
    try {
      final response = await supabase
          .from('addresses')
          .select('*')
          .eq('user_id', userId.value)
          .order('created_at', ascending: false);

      // Log the response for debugging
      print('Fetch user addresses response: $response');

      if (response != null) {
        addresses.assignAll(List<Map<String, dynamic>>.from(response));
      }
    } catch (e) {
      print("Error fetching user addresses: $e");
    }
  }

  Future<void> fetchTailorServices() async {
    try {
      if (tailorId.value.isEmpty) {
        print("No tailor ID set, skipping fetchTailorServices.");
        return;
      }

      final response = await supabase
          .from('tailorservices')
          .select('*')
          .eq('tailor_id', tailorId.value);

      // Log the response for debugging
      print('Fetch tailor services response: $response');

      if (response != null) {
        services.assignAll(List<Map<String, dynamic>>.from(response));
      }
    } catch (e) {
      print("Error fetching tailor services: $e");
    }
  }
}