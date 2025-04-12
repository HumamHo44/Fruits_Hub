import 'package:flutter/material.dart';
import 'package:fruits_hub/core/widgets/fruit_item.dart';

class BestSillingGridView extends StatelessWidget {
  const BestSillingGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 163 / 214,
        mainAxisSpacing: 8,
        crossAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return const FruitItem();
      },
    );
  }
}
