import 'package:flutter/material.dart';
import 'package:fruits_hub/constants.dart';
import 'package:fruits_hub/core/widgets/fruit_item.dart';
import 'package:fruits_hub/core/widgets/search_text_field.dart';
import 'package:fruits_hub/features/home/presentation/view/widgets/best_selling_header.dart';
import 'package:fruits_hub/features/home/presentation/view/widgets/best_silling_grid_view.dart';
import 'package:fruits_hub/features/home/presentation/view/widgets/custom_home_app_bar.dart';
import 'package:fruits_hub/features/home/presentation/view/widgets/featured_list.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(
                  height: ktopPadding,
                ),
                CustomHomeAppBar(),
                SizedBox(
                  height: ktopPadding,
                ),
                SearchTextField(),
                SizedBox(
                  height: 12,
                ),
                FeaturedList(),
                SizedBox(
                  height: 12,
                ),
                BestSellingHeader(),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
          BestSillingGridView()
        ],
      ),
    );
  }
}
