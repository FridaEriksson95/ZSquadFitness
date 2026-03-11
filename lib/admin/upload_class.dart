import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zsquadfitness/ui/components/primary_button.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';

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
      text: widget.initialData?['title'] ?? 'Zumba',
    );
    _dateController = TextEditingController(
      text: widget.initialData?['date'] ?? '',
    );
    _timeController = TextEditingController(
      text: widget.initialData?['time'] ?? '',
    );
    _spotsTotalController = TextEditingController(
      text: widget.initialData?['spotsTotal']?.toString() ?? '25',
    );
    _locationNameController = TextEditingController(
      text: widget.initialData?['locationName'] ?? 'POP Studios, K7 Stenby',
    );
    _locationAddressController = TextEditingController(
      text:
          widget.initialData?['locationAddress'] ??
          'Kraftlinjegatan 4, Västerås',
    );
    _priceSingleController = TextEditingController(
      text: widget.initialData?['priceSingle'] ?? '65:-',
    );
    _price10CardController = TextEditingController(
      text: widget.initialData?['price10Card'] ?? '585:-',
    );
    _descriptionController = TextEditingController(
      text:
          widget.initialData?['description'] ??
          '60 minuter glädjefylld dansträningspass med rytmer från hela världen. Här utlovas svett, kondition, koordination, styrka och energi!\n\nInga förkunskaper krävs, du kör efter egen förmåga. Första gången alltid gratis prova på.',
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
      helpText: 'Välj starttid',
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
      helpText: 'Välj sluttid',
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
        }
      }
    } catch (_) {}

    if (parsedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ogiltigt datum – skriv t.ex. "11 mars" eller "Ons 11 mars"',
          ),
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
      ).showSnackBar(const SnackBar(content: Text('Pass sparat!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fel vid sparande: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.classId == null ? 'Ladda upp nytt pass' : 'Redigera pass',
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
                decoration: const InputDecoration(labelText: 'Namn på pass'),
                validator: (choice) => choice!.isEmpty ? 'Obligatoriskt' : null,
              ),
              gapH10,
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Datum',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ),
                readOnly: true,
                validator: (choice) => choice!.isEmpty ? 'Välj datum' : null,
              ),
              gapH10,
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: 'Tid',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: _selectTime,
                  ),
                ),
                readOnly: true,
                validator: (choice) => choice!.isEmpty ? 'Välj tid' : null,
              ),
              gapH10,
              TextFormField(
                controller: _spotsTotalController,
                decoration: const InputDecoration(
                  labelText: 'Totalt antal platser',
                ),
                keyboardType: TextInputType.number,
                validator: (choice) => choice!.isEmpty ? 'Obligatoriskt' : null,
              ),
              gapH10,
              TextFormField(
                controller: _locationNameController,
                decoration: const InputDecoration(labelText: 'Plats'),
                validator: (choice) => choice!.isEmpty ? 'Obligatoriskt' : null,
              ),

              gapH10,
              TextFormField(
                controller: _locationAddressController,
                decoration: const InputDecoration(labelText: 'Adress'),
                validator: (choice) => choice!.isEmpty ? 'Obligatoriskt' : null,
              ),
              gapH10,
              TextFormField(
                controller: _priceSingleController,
                decoration: const InputDecoration(labelText: 'Pris per pass'),
                validator: (choice) => choice!.isEmpty ? 'Obligatoriskt' : null,
              ),
              gapH10,
              TextFormField(
                controller: _price10CardController,
                decoration: const InputDecoration(
                  labelText: 'Pris för 10-kort',
                ),
              ),
              gapH10,
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Beskrivning',
                  hintMaxLines: 7,
                ),
                maxLines: 7,
              ),
              gapH20,
              PrimaryButton(
                text: widget.classId == null
                    ? 'Ladda upp pass'
                    : 'Spara ändringar',
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
