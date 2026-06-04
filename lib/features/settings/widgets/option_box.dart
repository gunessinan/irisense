import 'package:flutter/material.dart';
import 'package:irisense/core/constants/classic_theme.dart';

class OptionBox extends StatefulWidget {
  final String title;
  final List<String> options;
  final String currentValue;
  final Function(String) onChanged;

  const OptionBox({
    super.key,
    required this.title,
    required this.options,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  State<OptionBox> createState() => _OptionBoxState();
}

class _OptionBoxState extends State<OptionBox> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.options.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: AppColors.darkElevated,
          borderRadius: const BorderRadius.all(Radius.circular(18.0))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 220,
            child: Center(child: Text(widget.title, style: AppTextStyles.interBold18)),
          ),
          
          const SizedBox(width: 10),
          
          Expanded(
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: AppColors.darkInput,
                borderRadius: BorderRadius.circular(18),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: widget.currentValue,
                  dropdownColor: AppColors.darkElevated,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  isExpanded: true,
                  style: AppTextStyles.interBold18.copyWith(color: Colors.white),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      widget.onChanged(newValue);
                    }
                  },
                  items: widget.options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}