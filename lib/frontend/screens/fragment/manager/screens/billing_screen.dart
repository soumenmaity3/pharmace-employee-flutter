import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace_emp/frontend/provider/medicine_provider.dart';

import '../../../../../backend/model/medicine_output_model.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/text_feild_widget.dart';
import '../../common/models/billing_model.dart';
import '../../common/models/inv_model.dart';
import '../../common/widgets/medicine_bill_widgets.dart';
import '../../common/widgets/new_bill_search_medicine_widget.dart';

class BillingScreen extends ConsumerStatefulWidget {
  const BillingScreen({super.key});

  @override
  ConsumerState<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends ConsumerState<BillingScreen> {

  int _selectedCustomerType = 0;
  final _formKey = GlobalKey<FormState>();
  List<MedicineOutputModel> _searchMedicine = [];
  final List<MedicineBillModel> _selectedMedicine = [];
  String _medicineSearchQuery = '';
  final Map<String, (int strip, int loose, double price)> _medicineQuantities =
  {};
  double get totalPrice {
    return _medicineQuantities.values.fold(0.0, (sum, v) => sum + v.$3);
  }

  final Random _random = Random();
  late final int number;
  late final String invId;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  PaymentType _paymentType = PaymentType.upi;

  @override
  void initState() {
    super.initState();
    number = 1000 + _random.nextInt(9000);
    invId = 'INV-$number';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _customerTypeButton(
                      title: 'Walk-in',
                      isSelected: _selectedCustomerType == 0,
                      onTap: () {
                        setState(() {
                          _selectedCustomerType = 0;
                        });
                      },
                      icon: Icons.trending_up,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _customerTypeButton(
                      title: 'Online',
                      isSelected: _selectedCustomerType == 1,
                      onTap: () {
                        setState(() {
                          _selectedCustomerType = 1;
                        });
                      },
                      icon: Icons.public,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Customer name', style: theme.textTheme.titleSmall),
                    SizedBox(height: 10),
                    TextFieldWidget(
                      hintText: 'e.g. Meena Devi',
                      isRequired: true,
                      controller: _nameController,
                    ),
                    SizedBox(height: 15),
                    Text('Phone number', style: theme.textTheme.titleSmall),
                    SizedBox(height: 10),
                    TextFieldWidget(
                      hintText: '+91 987654321',
                      controller: _phoneController,
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Text('Reffered by ', style: theme.textTheme.titleSmall),
                        Text('(Optional)', style: theme.textTheme.labelMedium),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFieldWidget(
                      hintText: 'e.g. Doctore name',
                      isRequired: false,
                    ),
                    SizedBox(height: 15),
                    Text('Add Medicine', style: theme.textTheme.titleLarge),

                    SizedBox(height: 10),

                    TextFieldWidget(
                      hintText: 'Search Medicine to add',
                      onChanged: (value) {
                        final query = value.trim().toLowerCase();

                        setState(() {
                          _medicineSearchQuery = query;

                          if (query.isEmpty) {
                            _searchMedicine = [];
                          } else {
                            _searchMedicine = ref
                                .watch(medicineProvider)
                                .allItems
                                .where((item) {
                                  return item.medicineNmae
                                      .toLowerCase()
                                      .contains(query);
                                })
                                .toList();
                          }
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    _searchMedicineList(theme, _medicineSearchQuery),
                    Text(
                      _selectedMedicine.isEmpty ? '' : 'Bill Items',
                      style: theme.textTheme.titleLarge,
                    ),
                    SizedBox(height: 10),
                    _selectedMedicineList(theme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedMedicineList(ThemeData theme) {
    if (_selectedMedicine.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        for (int i = 0; i < _selectedMedicine.length; i++) ...[
          Builder(
            builder: (context) {
              final medicine = _selectedMedicine[i];

              return MedicineBillWidgets(
                key: ValueKey(medicine.id),
                medicineItem: medicine,

                onDelete: () {
                  setState(() {
                    _selectedMedicine.remove(medicine);
                    _medicineQuantities.remove(medicine.id);
                  });
                },

                onQuantityChanged: (stripCount, looseCount, totalPrice) {
                  setState(() {
                    _medicineQuantities[medicine.id] = (
                    stripCount,
                    looseCount,
                    totalPrice,
                    );

                    final index = _selectedMedicine.indexWhere(
                          (item) => item.id == medicine.id,
                    );

                    if (index != -1) {
                      _selectedMedicine[index] = _selectedMedicine[index]
                          .copyWith(
                        strip: stripCount,
                        looseQty: looseCount,
                        totalPrice: double.parse(
                          totalPrice.toStringAsFixed(2),
                        ),
                      );
                    }
                  });
                },
              );
            },
          ),

          if (i < _selectedMedicine.length - 1) Divider(),
        ],
      ],
    );
  }

  Widget _searchMedicineList(ThemeData theme, String query) {
    final searchQuery = query.trim();
    if (searchQuery.isEmpty) {
      return SizedBox.shrink();
    }
    if (_searchMedicine.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text('No data found', style: theme.textTheme.bodyMedium),
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.cardColor,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _searchMedicine.length,
        itemBuilder: (context, index) {
          final medicine = _searchMedicine[index]; // MedicineModel now
          return NewBillSearchMedicineWidget(
            medicineItem: medicine, // ✅ types match
            onAddMedicine: () {
              final alreadyAdded = _selectedMedicine.any(
                    (item) => item.id == medicine.id,
              );

              if (alreadyAdded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('This medicine is already added to the bill'),
                  ),
                );
                return;
              }

              setState(() {
                _selectedMedicine.add(
                  MedicineBillModel(
                    id: medicine.id ?? '',
                    medicineName: medicine.medicineNmae,
                    strip: 1,
                    price: medicine.price,
                    isLooseAv: medicine.isLooseAv,
                    loose: medicine.looseQuantity,
                    tagPrice: medicine.price,
                  ),
                );

                _searchMedicine = [];
              });
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }


  Widget _customerTypeButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.successDark.withValues(alpha: 0.2)
              : AppColors.primaryContainer.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(width: 2, color: AppColors.primaryLight)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(width: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
