import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:university_delivery_app/presentation/bloc/menu/menu_bloc.dart';
import 'package:university_delivery_app/presentation/bloc/menu/menu_event.dart';
import 'package:university_delivery_app/presentation/bloc/menu/menu_state.dart';
import 'package:university_delivery_app/data/repositories/menu_repository_impl.dart';
import 'package:university_delivery_app/presentation/widgets/menu_item_card.dart';

class MenuPage extends StatelessWidget {
  final String restaurantId;
  final String restaurantName;

  const MenuPage({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuBloc(
        menuRepository: MenuRepositoryImpl(),
      )..add(LoadMenuItemsEvent(restaurantId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(restaurantName),
        ),
        body: BlocBuilder<MenuBloc, MenuState>(
          builder: (context, state) {
            if (state is MenuLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MenuError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MenuBloc>().add(LoadMenuItemsEvent(restaurantId));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is MenuLoaded) {
              if (state.menuItems.isEmpty) {
                return const Center(
                  child: Text('No menu items available'),
                );
              }

              // Group by category
              final categories = state.menuItems.map((item) => item.category).toSet().toList();
              categories.sort();

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: categories.length,
                itemBuilder: (context, categoryIndex) {
                  final category = categories[categoryIndex];
                  final itemsInCategory = state.menuItems
                      .where((item) => item.category == category)
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          category,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      ...itemsInCategory.map(
                        (item) => MenuItemCard(menuItem: item),
                      ),
                    ],
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

