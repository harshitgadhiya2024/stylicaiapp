import 'package:flutter/material.dart';

import '../Utills/app_color.dart';

class FilterSection extends StatelessWidget {
  final String? selectedCompletionFilter;
  final String? selectedGarmentType;
  final Set<String> garmentTypes;
  final Function(String?) onCompletionFilterChanged;
  final Function(String?) onGarmentTypeChanged;
  final VoidCallback onResetFilters;

  const FilterSection({
    Key? key,
    required this.selectedCompletionFilter,
    required this.selectedGarmentType,
    required this.garmentTypes,
    required this.onCompletionFilterChanged,
    required this.onGarmentTypeChanged,
    required this.onResetFilters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50,),
          Row(
            children: [
              const Text(
                'Filters',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              InkWell(
                  onTap: onResetFilters,
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red
                      ),
                      child: const Icon(Icons.filter_alt, color: Colors.white,)
                  )
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  value: selectedCompletionFilter,

                  items: [null, 'Completed', 'Not Completed']
                      .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status ?? 'All'),
                  ))
                      .toList(),
                  onChanged: onCompletionFilterChanged,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Garment Type',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  value: selectedGarmentType,
                  items: ['All', ...garmentTypes]
                      .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
                      .toList(),
                  onChanged: onGarmentTypeChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

        ],
      ),
    );
  }
}