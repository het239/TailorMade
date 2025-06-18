import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailormade/common/widgets/appbar/appbar.dart';
import 'package:tailormade/features/personalization/screens/address/add_new_address.dart';
import 'package:tailormade/features/personalization/screens/address/widgets/single_address.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import 'package:tailormade/features/authentication/controllers.onboarding/user_controller.dart';

class UserAddressScreen extends StatefulWidget {
  const UserAddressScreen({super.key});

  @override
  _UserAddressScreenState createState() => _UserAddressScreenState();
}

class _UserAddressScreenState extends State<UserAddressScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final UserController userController = Get.find<UserController>();
  List<dynamic> addresses = [];
  bool isLoading = true;
  RealtimeChannel? _channel;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    fetchAddresses();
    setupRealtimeSubscription();
  }

  /// Fetch addresses from Supabase
  Future<void> fetchAddresses() async {
    try {
      final userId = userController.userId;
      if (userId == null) {
        setState(() => isLoading = false);
        return;
      }

      final response = await supabase
          .from('addresses')
          .select('*')
          .eq('user_id', userId);

      setState(() {
        addresses = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error fetching addresses: $e');
    }
  }

  /// Setup real-time subscription using `supabase.realtime`
  /// Setup real-time subscription using `supabase.realtime`
  /// Setup real-time subscription using `supabase.realtime`
  void setupRealtimeSubscription() {
    final userId = userController.userId;
    if (userId == null) return;

    _channel = supabase.channel('addresses_realtime').onPostgresChanges(
      event: PostgresChangeEvent.all, // Listen for all changes (INSERT, UPDATE, DELETE)
      schema: 'public',
      table: 'addresses',
      callback: (payload) {
        // Only fetch addresses if the changed row belongs to the logged-in user
        if (payload.newRecord['user_id'] == userId) {
          fetchAddresses();
        }
      },
    ).subscribe();
  }

  @override
  void dispose() {
    _channel?.unsubscribe(); // Unsubscribe to avoid memory leaks
    super.dispose();
  }

  void selectAddress(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: TColors.primaryNew,
        onPressed: () async {
          await Get.to(() => const AddNewAddressScreen());
          fetchAddresses(); // Ensure UI updates when coming back
        },
        child: const Icon(Iconsax.add, color: TColors.white),
      ),
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Addresses',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : addresses.isEmpty
          ? const Center(child: Text('No addresses found'))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: List.generate(addresses.length, (index) {
              final address = addresses[index];
              return GestureDetector(
                onTap: () => selectAddress(index),
                child: TSingleAddress(
                  selectedAddress: selectedIndex == index,
                  name: address['address_type'] ?? 'No Address Type',
                  phone: address['postal_code'] ?? 'No Postal Code',
                  address:
                  "${address['street']}, ${address['city']}, ${address['state']}",
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
