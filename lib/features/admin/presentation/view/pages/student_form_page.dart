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
  late TextEditingController _idController;
  late TextEditingController _emailController;
  late TextEditingController _divisionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student?.name ?? '');
    _idController = TextEditingController(text: widget.student?.id ?? '');
    _emailController = TextEditingController(text: widget.student?.email ?? '');
    _divisionController = TextEditingController(
      text: widget.student?.division ?? '',
    );
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
                key: AdminKeys.studentIdInput,
                controller: _idController,
                decoration: const InputDecoration(labelText: 'Student ID'),
                enabled: !isEditing,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16.h),
              TextFormField(
                key: AdminKeys.studentNameInput,
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16.h),
              TextFormField(
                key: AdminKeys.studentEmailInput,
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16.h),
              TextFormField(
                key: AdminKeys.studentGradeInput,
                controller: _divisionController,
                decoration: const InputDecoration(labelText: 'Division'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
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
        id: _idController.text,
        name: _nameController.text,
        email: _emailController.text,
        dateOfBirth:
            widget.student?.dateOfBirth ?? '', // Default or from existing
        parentName: widget.student?.parentName ?? '',
        parentPhone: widget.student?.parentPhone ?? '', // Required field
        division: _divisionController.text,
        subjects: widget.student?.subjects ?? const [], // Required field
        phone: widget.student?.phone ?? '',
        address: widget.student?.address ?? '',
        semester: widget.student?.semester ?? '1st Semester',
        attendance: widget.student?.attendance ?? 0.0,
        averageMarks: widget.student?.averageMarks ?? 0.0,
      );

      if (widget.student != null) {
        context.read<AdminPresenter>().add(UpdateStudentEvent(student));
      } else {
        context.read<AdminPresenter>().add(AddStudentEvent(student));
      }
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _divisionController.dispose();
    super.dispose();
  }
}
