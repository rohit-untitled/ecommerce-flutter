import 'package:e_commerce/common/widgets/appbar/appbar.dart';
import 'package:e_commerce/common/widgets/brands/brand_card.dart';
import 'package:e_commerce/common/widgets/products/sortable/sortable_products.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class BrandProducts extends StatelessWidget {
  const BrandProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Nike',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(
          TSizes.defaultSpace,
        ),
        child: Column(
          children: [
            //brand details
            TBrandCard(showBorder: true),
            SizedBox(height: TSizes.spaceBtwSections),
            TSortableProducts(),
          ],
        ),
      ),
    );
  }
}
