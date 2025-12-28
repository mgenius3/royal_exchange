import 'package:royal/core/constants/routes.dart';
import 'package:royal/core/controllers/currency_rate_controller.dart';
import 'package:royal/core/controllers/user_auth_details_controller.dart';
import 'package:royal/core/models/currency_rate_model.dart';
import 'package:royal/core/theme/colors.dart';
import 'package:royal/core/utils/spacing.dart';
import 'package:royal/features/home/controllers/balance_display_controller.dart';
import 'package:royal/features/wallet/controllers/index_controller.dart';
import 'package:royal/features/wallet/data/model/wallet_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String selectedTypeFilter =
      'All'; // Filter by type (All, Deposit, Withdrawal)
  String selectedStatusFilter =
      'All'; // Filter by status (All, Success, Pending, Failed)

  final WalletController walletController = Get.put(WalletController());
  final UserAuthDetailsController userAuthDetailsController =
      Get.find<UserAuthDetailsController>();
  final BalanceDisplayController balanceController =
      Get.find<BalanceDisplayController>();

  final BalanceDisplayController controller =
      Get.put(BalanceDisplayController());
  final userAuthController = Get.find<UserAuthDetailsController>();
  final currencyRateController = Get.find<CurrencyRateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: Spacing.defaultMarginSpacing,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 24),
              _buildWalletBalanceCard(
                  currencyRateController, userAuthController, controller),
              const SizedBox(height: 24),
              _buildFilterSection(),
              const SizedBox(height: 20),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: walletController.fetchWalletData,
                  color: Colors.green,
                  child: Obx(() {
                    if (walletController.isLoading.value) {
                      return _buildLoadingState();
                    } else if (walletController
                        .all_wallet_transaction.isEmpty) {
                      return _buildEmptyState();
                    }

                    // 🆕 UPDATED: Apply both filters
                    final filteredTransactions = _getFilteredTransactions();

                    if (filteredTransactions.isEmpty) {
                      return _buildEmptyFilterState();
                    }

                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filteredTransactions.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final transaction = filteredTransactions[index];
                        return _buildTransactionItem(transaction);
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🆕 NEW: Combined filtering by both type and status
  List<WalletTransactionModel> _getFilteredTransactions() {
    List<WalletTransactionModel> transactions =
        walletController.all_wallet_transaction;

    // First filter by type (Deposit/Withdrawal)
    if (selectedTypeFilter != 'All') {
      transactions = transactions
          .where(
              (tx) => tx.type.toLowerCase() == selectedTypeFilter.toLowerCase())
          .toList();
    }

    // Then filter by status (Success/Pending/Failed)
    if (selectedStatusFilter != 'All') {
      transactions = transactions
          .where((tx) =>
              tx.status.toLowerCase() == selectedStatusFilter.toLowerCase())
          .toList();
    }

    return transactions;
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 12),
          const Text(
            'Wallet ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletBalanceCard(
      CurrencyRateController currencyRateController,
      UserAuthDetailsController userAuthController,
      BalanceDisplayController balancedisplaycontroller) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                LightThemeColors.primaryColor,
                LightThemeColors.primaryColor.withOpacity(.5)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  balanceController.toggleBalanceVisibility();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            balanceController.showBalance.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Wallet Balance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    _buildDollarEquivalent(currencyRateController,
                        userAuthController, balancedisplaycontroller)
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        balanceController.showBalance.value
                            ? 'NGN ${userAuthDetailsController.user.value?.walletBalance ?? ""}'
                            : "••••••••",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Get.toNamed(RoutesConstant.withdraw);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.send_rounded,
                                color: LightThemeColors.primaryColor
                                    .withOpacity(.6),
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Withdraw funds',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: LightThemeColors.primaryColor
                                      .withOpacity(.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🆕 UPDATED: Header with Transaction History text + type filter icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side: Filter icon + Transaction History text
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.filter_list_rounded,
                      size: 18,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Transaction History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              // 🆕 RIGHT SIDE: Type filter icons (All, Deposit, Withdrawal)
              Row(
                children: [
                  _buildTypeFilterIcon('All', Icons.list, 'All'),
                  const SizedBox(width: 8),
                  _buildTypeFilterIcon(
                      'Deposit', Icons.arrow_downward_rounded, 'Deposit'),
                  const SizedBox(width: 8),
                  _buildTypeFilterIcon(
                      'Withdrawal', Icons.arrow_upward_rounded, 'Withdrawal'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Status filter section
          Text(
            'Transaction Status',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          _buildStatusFilterTabs(),
        ],
      ),
    );
  }

  Widget _buildDollarEquivalent(
      CurrencyRateController currencyRateController,
      UserAuthDetailsController userAuthController,
      BalanceDisplayController controller) {
    return Obx(() {
      if (currencyRateController.currencyRates.isNotEmpty) {
        final walletBalance = double.tryParse(
                userAuthController.user.value?.walletBalance ?? '0') ??
            0;
        final ngnRate = currencyRateController.currencyRates.firstWhere(
          (rate) => rate.currencyCode == 'NGN',
          orElse: () =>
              CurrencyRateModel(currencyCode: 'NGN', rate: '0', id: 0),
        );

        final rateValue =
            ngnRate.rate.isEmpty ? 1 : num.tryParse(ngnRate.rate) ?? 1;

        final dollarValue = (walletBalance / rateValue).toStringAsFixed(2);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            controller.showBalance.value
                ? Row(
                    children: [
                      Text(
                        "\$${dollarValue}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  )
                : const Text(
                    "••••••",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                      height: 1.1,
                    ),
                  ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.currency_exchange,
                  size: 12,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                "\$0.00",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            "USD Equivalent",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    });
  }

// 🆕 NEW: Type filter icon button
  Widget _buildTypeFilterIcon(String title, IconData icon, String filterValue) {
    final isSelected = selectedTypeFilter == filterValue;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          selectedTypeFilter = filterValue;
        });
      },
      child: Tooltip(
        message: title,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected
                ? LightThemeColors.primaryColor.withOpacity(0.2)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? LightThemeColors.primaryColor.withOpacity(0.6)
                  : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            size: 18,
            color:
                isSelected ? LightThemeColors.primaryColor : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  // 🆕 NEW: Type Filter Tabs (All, Deposit, Withdrawal)
  Widget _buildTypeFilterTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTypeFilterTab('All'),
        _buildTypeFilterTab('Deposit'),
        _buildTypeFilterTab('Withdrawal'),
      ],
    );
  }

  // 🆕 NEW: Status Filter Tabs (All, Success, Pending, Failed)
  Widget _buildStatusFilterTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatusFilterTab('All'),
        _buildStatusFilterTab('Success'),
        _buildStatusFilterTab('Pending'),
        _buildStatusFilterTab('Failed'),
      ],
    );
  }

  // 🆕 NEW: Type Filter Tab Builder
  Widget _buildTypeFilterTab(String title) {
    final isSelected = selectedTypeFilter == title;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() {
            selectedTypeFilter = title;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? LightThemeColors.primaryColor.withOpacity(.6)
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? LightThemeColors.primaryColor.withOpacity(.6)
                  : Colors.grey[300]!,
              width: 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  // 🆕 NEW: Status Filter Tab Builder
  Widget _buildStatusFilterTab(String title) {
    final isSelected = selectedStatusFilter == title;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() {
            selectedStatusFilter = title;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? LightThemeColors.primaryColor.withOpacity(.6)
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? LightThemeColors.primaryColor.withOpacity(.6)
                  : Colors.grey[300]!,
              width: 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.green),
          SizedBox(height: 16),
          Text(
            'Loading transactions...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your wallet transactions will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFilterState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.filter_alt_off_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions matching filter',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try selecting a different filter',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(WalletTransactionModel transaction) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Get.toNamed(RoutesConstant.wallet_transaction_details,
            arguments: transaction);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                _getTransactionStatusColor(transaction.status).withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: _getTransactionStatusColor(transaction.status)
                  .withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: transaction.type == 'deposit'
                        ? Colors.green
                        : Colors.orange,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (transaction.type == 'deposit'
                                ? Colors.green
                                : Colors.orange)
                            .withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    transaction.type == 'deposit'
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${transaction.type.capitalizeFirst} via ${transaction.gateway.capitalizeFirst}',
                        style: TextStyle(
                          fontSize: Get.width < 400 ? 10 : 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ref: ${transaction.reference}',
                        style: TextStyle(
                          fontSize: Get.width < 400 ? 7 : 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'NGN ${transaction.amount}',
                      style: TextStyle(
                        fontSize: Get.width < 400 ? 10 : 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getTransactionStatusColor(transaction.status)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        transaction.status.capitalizeFirst ?? '',
                        style: TextStyle(
                          fontSize: Get.width < 400 ? 6 : 11,
                          fontWeight: FontWeight.w600,
                          color: _getTransactionStatusColor(transaction.status),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.grey[200]!,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('MMM d, yyyy').format(transaction.createdAt),
                      style: TextStyle(
                        fontSize: Get.width < 400 ? 7 : 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: Get.width < 400 ? 7 : 13,
                        color: Colors.blue[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.blue[600],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTransactionStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'failed':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
