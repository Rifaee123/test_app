import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/admin/presentation/presenter/admin_presenter.dart';
import 'package:test_app/features/admin/presentation/view/admin_keys.dart';

class StudentFormPage extends StatefulWidget {
  final Student? student;

  const StudentFormPage({super.key, this.student});

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _parentNameController;
  late TextEditingController _parentPhoneController;
  late TextEditingController _dobController;
  String? _selectedDivision;

  final List<String> _divisions = ['A', 'B', 'C'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student?.name ?? '');
    _parentNameController = TextEditingController(
      text: widget.student?.parentName ?? '',
    );
    _parentPhoneController = TextEditingController(
      text: widget.student?.parentPhone ?? '',
    );
    _dobController = TextEditingController(
      text: widget.student?.dateOfBirth ?? '',
    );
    _selectedDivision = widget.student?.division;
    if (_selectedDivision != null && !_divisions.contains(_selectedDivision)) {
      _selectedDivision = null; // Reset if invalid
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.student != null;
    return Scaffold(
      key: AdminKeys.studentFormView,
      appBar: AppBar(title: Text(isEditing ? 'Edit Student' : 'Add Student')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: AdminKeys.studentNameInput,
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'e.g. Kaju',
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16.h),
              TextFormField(
                key: AdminKeys.studentDobInput,
                controller: _dobController,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  hintText: 'YYYY-MM-DD (e.g. 2010-05-23)',
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16.h),
              TextFormField(
                key: AdminKeys.studentParentNameInput,
                controller: _parentNameController,
                decoration: const InputDecoration(
                  labelText: 'Parent Name',
                  hintText: 'e.g. Rakhav',
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16.h),
              TextFormField(
                key: AdminKeys.studentParentPhoneInput,
                controller: _parentPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Parent Phone',
                  hintText: 'e.g. 9876543210',
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16.h),
              DropdownButtonFormField<String>(
                key: AdminKeys.studentGradeInput,
                initialValue: _selectedDivision,
                decoration: const InputDecoration(labelText: 'Division'),
                items: _divisions.map((String division) {
                  return DropdownMenuItem<String>(
                    value: division,
                    child: Text(division),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDivision = newValue;
                  });
                },
                validator: (v) => v == null ? 'Required' : null,
              ),
              SizedBox(height: 32.h),
              ElevatedButton(
                key: AdminKeys.saveStudentBtn,
                onPressed: _save,
                child: Text(isEditing ? 'Update Student' : 'Save Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        id: widget.student?.id ?? 'STU${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text,
        email: '', // Email removed from form
        division: _selectedDivision!,
        parentPhone: _parentPhoneController.text,
        parentName: _parentNameController.text,
        dateOfBirth: _dobController.text,
        address: widget.student?.address ?? '',
        semester: widget.student?.semester ?? '1st Semester',
        attendance: widget.student?.attendance ?? 0.0,
        averageMarks: widget.student?.averageMarks ?? 0.0,
        subjects: widget.student?.subjects ?? const [],
      );

      if (widget.student != null) {
        context.read<StudentManagementBloc>().add(UpdateStudentEvent(student));
      } else {
        context.read<StudentManagementBloc>().add(AddStudentEvent(student));
      }
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _parentNameController.dispose();
    _parentPhoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }
}
