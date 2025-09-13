import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FabricSelectionWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFabricSelected;
  final Map<String, dynamic>? selectedFabric;

  const FabricSelectionWidget({
    Key? key,
    required this.onFabricSelected,
    this.selectedFabric,
  }) : super(key: key);

  @override
  State<FabricSelectionWidget> createState() => _FabricSelectionWidgetState();
}

class _FabricSelectionWidgetState extends State<FabricSelectionWidget> {
  final List<Map<String, dynamic>> fabricOptions = [
    {
      "id": 1,
      "name": "Cotton Poplin",
      "type": "Cotton",
      "weight": "Light",
      "stretch": "No Stretch",
      "price": "\$12.99/yard",
      "color": "#E8F4F8",
      "texture": "Smooth",
      "description": "Crisp, lightweight cotton perfect for shirts and dresses",
      "image":
          "https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=400&h=300&fit=crop",
      "suitableFor": ["Shirt", "Dress", "Blouse"],
    },
    {
      "id": 2,
      "name": "Silk Charmeuse",
      "type": "Silk",
      "weight": "Light",
      "stretch": "Slight Stretch",
      "price": "\$45.99/yard",
      "color": "#F5E6D3",
      "texture": "Lustrous",
      "description": "Luxurious silk with beautiful drape for elegant garments",
      "image":
          "https://images.unsplash.com/photo-1594736797933-d0401ba2fe65?w=400&h=300&fit=crop",
      "suitableFor": ["Dress", "Blouse", "Saree Jacket"],
    },
    {
      "id": 3,
      "name": "Linen Blend",
      "type": "Linen",
      "weight": "Medium",
      "stretch": "No Stretch",
      "price": "\$18.99/yard",
      "color": "#F0EAD6",
      "texture": "Textured",
      "description": "Breathable linen blend ideal for casual wear",
      "image":
          "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=300&fit=crop",
      "suitableFor": ["Shirt", "T-shirt", "Casual Dress"],
    },
    {
      "id": 4,
      "name": "Jersey Knit",
      "type": "Cotton Blend",
      "weight": "Medium",
      "stretch": "4-Way Stretch",
      "price": "\$8.99/yard",
      "color": "#E6E6FA",
      "texture": "Soft",
      "description": "Comfortable stretch fabric perfect for t-shirts",
      "image":
          "https://images.unsplash.com/photo-1566479179817-c0b7e6b0b5b5?w=400&h=300&fit=crop",
      "suitableFor": ["T-shirt", "Casual Dress"],
    },
    {
      "id": 5,
      "name": "Wool Crepe",
      "type": "Wool",
      "weight": "Medium",
      "stretch": "Slight Stretch",
      "price": "\$32.99/yard",
      "color": "#F5F5DC",
      "texture": "Matte",
      "description": "Professional wool fabric for structured garments",
      "image":
          "https://images.unsplash.com/photo-1544441893-675973e31985?w=400&h=300&fit=crop",
      "suitableFor": ["Saree Jacket", "Dress", "Blazer"],
    },
    {
      "id": 6,
      "name": "Chiffon",
      "type": "Polyester",
      "weight": "Light",
      "stretch": "No Stretch",
      "price": "\$15.99/yard",
      "color": "#FFE4E1",
      "texture": "Sheer",
      "description": "Flowing, lightweight fabric for elegant draping",
      "image":
          "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400&h=300&fit=crop",
      "suitableFor": ["Dress", "Blouse"],
    },
  ];

  String selectedCategory = 'All';
  final List<String> categories = [
    'All',
    'Cotton',
    'Silk',
    'Linen',
    'Wool',
    'Synthetic'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  'Select Fabric',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Category filter
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 20),

          // Fabric grid
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: _getFilteredFabrics().length,
                itemBuilder: (context, index) {
                  final fabric = _getFilteredFabrics()[index];
                  final isSelected =
                      widget.selectedFabric?['id'] == fabric['id'];

                  return GestureDetector(
                    onTap: () {
                      widget.onFabricSelected(fabric);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.shadow,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Fabric image
                          Expanded(
                            flex: 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(int.parse(fabric['color']
                                      .replaceFirst('#', '0xFF'))),
                                ),
                                child: CustomImageWidget(
                                  imageUrl: fabric['image'] as String,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          // Fabric details
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fabric['name'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.titleSmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    fabric['type'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    fabric['price'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredFabrics() {
    if (selectedCategory == 'All') {
      return fabricOptions;
    }
    return fabricOptions.where((fabric) {
      final fabricType = fabric['type'] as String;
      return fabricType.toLowerCase().contains(selectedCategory.toLowerCase());
    }).toList();
  }
}
