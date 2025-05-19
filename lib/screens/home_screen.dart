import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth_service.dart';
import '../blocs/products/products_bloc.dart';
import '../blocs/products/products_event.dart';
import '../blocs/products/products_state.dart';
import '../models/restaurant.dart';
import 'login_screen.dart';
import 'products_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? token;

  const HomeScreen({super.key, this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _logout() async {
    await AuthService.removeToken();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsBloc()..add(LoadRestaurantsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: const Color.fromRGBO(70, 220, 220, 0.773),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
        body: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            if (state is RestaurantsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RestaurantsError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is RestaurantsLoaded) {
              final restaurants = state.restaurants;
              if (restaurants.isEmpty) {
                return const Center(child: Text('No restaurants found.'));
              }
              return _buildRestaurantsGrid(restaurants);
            } else {
              return const Center(child: Text('Something went wrong.'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildRestaurantsGrid(List<Restaurant> restaurants) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return _buildRestaurantCard(restaurant);
      },
    );
  }

  Widget _buildRestaurantCard(Restaurant restaurant) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProductsScreen(),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color.fromARGB(255, 212, 233, 238),
                child: const Icon(
                  Icons.restaurant,
                  size: 80,
                  color:  Color.fromARGB(197, 8, 165, 165),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                restaurant.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




/**
 *  body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductsScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(70, 220, 220, 0.773),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text('Restaurant Products'),
        ),
      ),
    
 */
