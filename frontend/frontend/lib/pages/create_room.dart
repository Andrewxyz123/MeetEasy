import 'package:flutter/material.dart';

class CreateRoomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the theme
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Meeting Room',
          style: theme.textTheme.titleLarge, // Use the theme's title style
        ),
        backgroundColor: theme.scaffoldBackgroundColor, // Use the theme's scaffold background
        foregroundColor: theme.colorScheme.onSurface, // Adjust based on theme
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Meeting Room',
                style: theme.textTheme.displaySmall, // Use the theme's display style
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Room Name',
                  hintText: 'Enter room name',
                  border: theme.inputDecorationTheme.border, // Use the theme's border
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Capacity',
                  hintText: 'Enter capacity',
                  border: theme.inputDecorationTheme.border, // Use the theme's border
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Room Description (Optional)',
                  hintText: 'Enter description',
                  border: theme.inputDecorationTheme.border, // Use the theme's border
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Location',
                  hintText: 'Enter floor/building',
                  border: theme.inputDecorationTheme.border, // Use the theme's border
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Amenities',
                style: theme.textTheme.bodyLarge, // Use bodyLarge for subheadings
              ),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (bool? value) {}),
                  Text(
                    'Wi-Fi',
                    style: theme.textTheme.bodyMedium, // Use bodyMedium for regular text
                  ),
                  SizedBox(width: 8.0),
                  Checkbox(value: false, onChanged: (bool? value) {}),
                  Text(
                    'Projector',
                    style: theme.textTheme.bodyMedium,
                  ),
                  SizedBox(width: 8.0),
                  Checkbox(value: false, onChanged: (bool? value) {}),
                  Text(
                    'Whiteboard',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (bool? value) {}),
                  Text(
                    'Conference Phone',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle save action
                  },
                  style: theme.elevatedButtonTheme.style?.copyWith(
                    minimumSize: MaterialStateProperty.all(Size(double.infinity, 48.0)),
                  ),
                  child: Text(
                    'Save',
                    style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Text(
                  'Meeting Room Created',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
