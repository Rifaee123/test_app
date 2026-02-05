import 'package:flutter/material.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/student/profile/presentation/pages/profile_keys.dart';

class ProfilePage extends StatefulWidget {
  final Student student;
  const ProfilePage({super.key, required this.student});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _parentController;
  late TextEditingController _divisionController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.name);
    _phoneController = TextEditingController(text: widget.student.phone);
    _addressController = TextEditingController(text: widget.student.address);
    _parentController = TextEditingController(text: widget.student.parentName);
    _divisionController = TextEditingController(text: widget.student.division);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _parentController.dispose();
    _divisionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ProfileKeys.profilePage,
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              key: ProfileKeys.editProfileButton,
              onPressed: () => setState(() => _isEditing = true),
              icon: const Icon(Icons.edit_outlined),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              key: ProfileKeys.profileImage,
              radius: 50,
              backgroundColor: const Color(0xFF6366F1),
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 32),
            _buildField('Full Name', _nameController, _isEditing),
            const SizedBox(height: 16),
            _buildField('Guardian Name', _parentController, _isEditing),
            const SizedBox(height: 16),
            _buildField('Academic Division', _divisionController, _isEditing),
            const SizedBox(height: 16),
            _buildField('Phone Number', _phoneController, _isEditing),
            const SizedBox(height: 16),
            _buildField(
              'Home Address',
              _addressController,
              _isEditing,
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            if (_isEditing)
              ElevatedButton(
                onPressed: () {
                  setState(() => _isEditing = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully'),
                    ),
                  );
                },
                child: const Text('Save Changes'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    bool enabled, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          decoration: InputDecoration(
            fillColor: enabled ? Colors.white : Colors.grey.shade50,
          ),
        ),
      ],
    );
  }
}
