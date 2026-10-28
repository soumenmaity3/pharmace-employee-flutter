import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace_emp/backend/api_service.dart';
import 'package:pharmace_emp/backend/model/emp_return_model.dart';
import 'package:pharmace_emp/frontend/provider/shop_provider.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/widgets/team/team_member_widget.dart';
import 'package:pharmace_emp/frontend/theme/app_colors.dart';

class ManTeamScreen extends ConsumerStatefulWidget {
  const ManTeamScreen({super.key});

  @override
  ConsumerState<ManTeamScreen> createState() => _ManTeamScreenState();
}

class _ManTeamScreenState extends ConsumerState<ManTeamScreen> {
  List<EmpBody> _allEmployees = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAllEmployees();
    });
  }

  Future<void> _fetchAllEmployees() async {
    final shopAsync = ref.read(shopProvider);
    final shop = shopAsync.value;
    final shopId = shop?.id;

    if (shopId == null || shopId.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Shop details not found.';
        });
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService().getAllEmployee(shopId: shopId);

      if (!mounted) return;

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          response.data != null) {
        setState(() {
          _allEmployees = response.data!;
          _isLoading = false;
          _errorMessage = null;
        });
      } else {
        final error = response.message ?? 'Failed to load team members.';
        setState(() {
          _isLoading = false;
          _errorMessage = error;
        });
        _showErrorSnackBar(error);
      }
    } catch (e) {
      if (!mounted) return;
      const error = 'Connection error. Please try again.';
      setState(() {
        _isLoading = false;
        _errorMessage = error;
      });
      _showErrorSnackBar(error);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: _fetchAllEmployees,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _fetchAllEmployees,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Team',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Duty status for this shop. New invite passes are issued from the owner console, not here.',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (_isLoading)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 48,
                            color: isDark
                                ? AppColors.errorDark
                                : AppColors.error,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _fetchAllEmployees,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  else if (_allEmployees.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 48,
                              color: isDark
                                  ? AppColors.darkTextTertiary
                                  : AppColors.lightTextTertiary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No team members found',
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        for (final emp in _allEmployees) ...[
                          TeamMemberWidget(
                            name: emp.name,
                            designation: (emp.isFromOwner ?? false)
                                ? 'Owner Appointed'
                                : 'Staff',
                            email: emp.email ?? '',
                            role: emp.role ?? 'Staff',
                            isOnDuty: true,
                            onMarkInactive: () {
                              // TODO: Handle mark inactive action
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add, size: 30),
        ),
      ),
    );
  }
}
