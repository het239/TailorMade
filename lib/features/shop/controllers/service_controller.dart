import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/Service_model.dart';

class TailorServiceController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  RxList<TailorService> services = <TailorService>[].obs;

  Future<void> fetchServices(String tailorId) async {
    try {
      final response = await supabase
          .from('tailorservices')
          .select('*')
          .eq('tailor_id', tailorId);

      if (response.isNotEmpty) {
        services.assignAll(response.map((json) => TailorService.fromJson(json)).toList());
      } else {
        print("No services found for this tailor.");
      }
    } catch (e) {
      print("Error fetching services: $e");
    }
  }
}