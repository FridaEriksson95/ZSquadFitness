import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zsquadfitness/shared/ui/components/primary_button.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';

class UploadClass extends StatefulWidget {
  final String? classId;
  final Map<String, dynamic>? initialData;

  const UploadClass({super.key, this.classId, this.initialData});

  @override
  State<UploadClass> createState() => _UploadClassState();
}

class _UploadClassState extends State<UploadClass> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _spotsTotalController;
  late TextEditingController _locationNameController;
  late TextEditingController _locationAddressController;
  late TextEditingController _priceSingleController;
  late TextEditingController _price10CardController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.initialData?['title'] ?? AppStrings.zumba,
    );
    _dateController = TextEditingController(
      text: widget.initialData?['date'] ?? '',
    );
    _timeController = TextEditingController(
      text: widget.initialData?['time'] ?? '',
    );
    _spotsTotalController = TextEditingController(
      text: widget.initialData?['spotsTotal']?.toString() ?? AppStrings.amount,
    );
    _locationNameController = TextEditingController(
      text: widget.initialData?['locationName'] ?? AppStrings.stenbyLocation,
    );
    _locationAddressController = TextEditingController(
      text: widget.initialData?['locationAddress'] ?? AppStrings.stenbyAddress,
    );
    _priceSingleController = TextEditingController(
      text: widget.initialData?['priceSingle'] ?? AppStrings.priceSingle,
    );
    _price10CardController = TextEditingController(
      text: widget.initialData?['price10Card'] ?? AppStrings.tenCard,
    );
    _descriptionController = TextEditingController(
      text: widget.initialData?['description'] ?? AppStrings.descZumba,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _spotsTotalController.dispose();
    _locationNameController.dispose();
    _locationAddressController.dispose();
    _priceSingleController.dispose();
    _price10CardController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('sv', 'SE'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.neonGreen,
              onPrimary: AppColors.dark,
              surface: AppColors.dark,
              onSurface: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted = DateFormat('EEEE d MMMM', 'sv_SE').format(picked);
      setState(() {
        _dateController.text =
            formatted[0].toUpperCase() + formatted.substring(1);
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? from = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 17, minute: 0),
      helpText: AppStrings.startTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.neonGreen,
                onPrimary: AppColors.dark,
                surface: AppColors.dark,
                onSurface: AppColors.white,
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (from == null) return;

    final TimeOfDay? to = await showTimePicker(
      context: context,
      initialTime: from.replacing(hour: from.hour + 1, minute: from.minute),
      helpText: AppStrings.endTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.neonGreen,
                onPrimary: AppColors.dark,
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (to != null) {
      final fromStr =
          '${from.hour.toString().padLeft(2, '0')}.${from.minute.toString().padLeft(2, '0')}';
      final toStr =
          '${to.hour.toString().padLeft(2, '0')}.${to.minute.toString().padLeft(2, '0')}';
      setState(() {
        _timeController.text = '$fromStr - $toStr';
      });
    }
  }

  Future<void> _saveClass() async {
    if (!_formKey.currentState!.validate()) return;

    String dateText = _dateController.text.trim();

    final dayStart = dateText.indexOf(RegExp(r'\d'));
    if (dayStart > 0) {
      dateText = dateText.substring(dayStart).trim();
    }

    DateTime? parsedDate;

    try {
      final parts = dateText.split(' ');
      if (parts.length >= 2) {
        final day = int.tryParse(parts[0]);
        final monthStr = parts[1].toLowerCase();
        final monthMap = {
          'jan': 1,
          'januari': 1,
          'feb': 2,
          'februari': 2,
          'mar': 3,
          'mars': 3,
          'apr': 4,
          'april': 4,
          'maj': 5,
          'jun': 6,
          'juni': 6,
          'jul': 7,
          'juli': 7,
          'aug': 8,
          'augusti': 8,
          'sep': 9,
          'september': 9,
          'okt': 10,
          'oktober': 10,
          'nov': 11,
          'november': 11,
          'dec': 12,
          'december': 12,
        };

        final month = monthMap[monthStr];
        if (day != null && month != null) {
          parsedDate = DateTime(DateTime.now().year, month, day);

          int hour = 0, minute = 0;
          final timeStr = _timeController.text.trim();
          if (timeStr.isNotEmpty) {
            final startPart = timeStr.split(' - ').first.trim();
            final timeParts = startPart.replaceAll('.', ':').split(':');
            if (timeParts.length >= 2) {
              hour = int.tryParse(timeParts[0]) ?? 0;
              minute = int.tryParse(timeParts[1]) ?? 0;
            }
          }
          parsedDate = DateTime(
            parsedDate.year,
            parsedDate.month,
            parsedDate.day,
            hour,
            minute,
          );
        }
      }
    } catch (_) {}

    if (parsedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.errorDate),
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    final now = DateTime.now();
    if (parsedDate.isBefore(now.subtract(const Duration(days: 1)))) {
      parsedDate = DateTime(
        parsedDate.year + 1,
        parsedDate.month,
        parsedDate.day,
        parsedDate.hour,
        parsedDate.minute,
      );
    }

    final data = {
      'title': _titleController.text.trim(),
      'dateRaw': Timestamp.fromDate(parsedDate),
      'date': _dateController.text.trim(),
      'time': _timeController.text.trim(),
      'spotsTotal': int.tryParse(_spotsTotalController.text.trim()) ?? 25,
      'spotsBooked': widget.initialData?['spotsBooked'] ?? 0,
      'locationName': _locationNameController.text.trim(),
      'locationAddress': _locationAddressController.text.trim(),
      'priceSingle': _priceSingleController.text.trim(),
      'price10Card': _price10CardController.text.trim(),
      'description': _descriptionController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    try {
      if (widget.classId != null) {
        await FirebaseFirestore.instance
            .collection('classes')
            .doc(widget.classId)
            .update(data);
      } else {
        await FirebaseFirestore.instance.collection('classes').add(data);
      }
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.saveClass)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${AppStrings.errorSave} $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.classId == null
              ? AppStrings.createNewClass
              : AppStrings.editClass,
        ),
      ),
      body: SingleChildScrollView(
        padding: paddingAll15,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: AppStrings.nameClass,
                ),
                validator: (choice) => choice!.isEmpty ? AppStrings.req : null,
              ),
              gapH10,
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: AppStrings.date,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ),
                readOnly: true,
                validator: (choice) =>
                    choice!.isEmpty ? AppStrings.pickDate : null,
              ),
              gapH10,
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: AppStrings.time,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: _selectTime,
                  ),
                ),
                readOnly: true,
                validator: (choice) =>
                    choice!.isEmpty ? AppStrings.pickTime : null,
              ),
              gapH10,
              TextFormField(
                controller: _spotsTotalController,
                decoration: const InputDecoration(
                  labelText: AppStrings.spotsAmount,
                ),
                keyboardType: TextInputType.number,
                validator: (choice) => choice!.isEmpty ? AppStrings.req : null,
              ),
              gapH10,
              TextFormField(
                controller: _locationNameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.location,
                ),
                validator: (choice) => choice!.isEmpty ? AppStrings.req : null,
              ),

              gapH10,
              TextFormField(
                controller: _locationAddressController,
                decoration: const InputDecoration(
                  labelText: AppStrings.address,
                ),
                validator: (choice) => choice!.isEmpty ? AppStrings.req : null,
              ),
              gapH10,
              TextFormField(
                controller: _priceSingleController,
                decoration: const InputDecoration(
                  labelText: AppStrings.priceClass,
                ),
                validator: (choice) => choice!.isEmpty ? AppStrings.req : null,
              ),
              gapH10,
              TextFormField(
                controller: _price10CardController,
                decoration: const InputDecoration(
                  labelText: AppStrings.price10Card,
                ),
              ),
              gapH10,
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: AppStrings.desc,
                  hintMaxLines: 7,
                ),
                maxLines: 7,
              ),
              gapH20,
              PrimaryButton(
                text: widget.classId == null
                    ? AppStrings.uploadClass
                    : AppStrings.saveChanges,
                color: AppColors.neonGreen,
                onPressed: _saveClass,
              ),
              gapBottom,
            ],
          ),
        ),
      ),
    );
  }
}
