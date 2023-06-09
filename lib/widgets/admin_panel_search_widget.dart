import 'package:flutter/material.dart';

import '../core/constants.dart';

class AdminPanelSearchWidget extends StatefulWidget {
  const AdminPanelSearchWidget({super.key});

  @override
  State<AdminPanelSearchWidget> createState() => _AdminPanelSearchWidgetState();
}

class _AdminPanelSearchWidgetState extends State<AdminPanelSearchWidget> {
  static final TextEditingController _controller = TextEditingController();

  static final List<String> _searchByList = [
    'Users',
    'Categories',
    'Departments',
  ];

  String _searchFilter = _searchByList.first;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _searchByDropdown(),
        const SizedBox(
          width: 20,
        ),
        _queryTextField(),
        const SizedBox(
          width: 20,
        ),
        _searchButton(),
      ],
    );
  }

  ElevatedButton _searchButton() {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Search'),
    );
  }

  SizedBox _queryTextField() {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            size: 20,
          ),
          isDense: true,
          contentPadding: EdgeInsets.all(8),
        ),
      ),
    );
  }

  SizedBox _searchByDropdown() {
    return SizedBox(
      width: 200,
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          iconSize: 12,
          focusColor: Colors.transparent,
          borderRadius: defaultBorderRadius,
          decoration: InputDecoration(
            labelText: 'Search By',
            isDense: true,
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: defaultBorderRadius,
            ),
          ),
          value: _searchFilter,
          items: _searchByList.map((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (String? input) {
            if (input == null) return;

            setState(() {
              _searchFilter = input;
            });
          },
        ),
      ),
    );
  }
}
