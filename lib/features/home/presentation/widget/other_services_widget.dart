import 'package:royal/core/constants/routes.dart';
import 'package:royal/features/home/data/model/other_services_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OtherServicesWidget extends StatelessWidget {
  const OtherServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey[50]!,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildServicesGrid()],
        ),
      ),
    );
  }

  Widget _buildServicesGrid() {
    final services = _getServices();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Get.width < 300 ? 2 : 3,
          childAspectRatio: .9,
          crossAxisSpacing: 30,
          mainAxisSpacing: 12),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return _buildServiceCard(services[index], index);
      },
    );
  }

  List<OtherServicesModel> _getServices() {
    return [
      const OtherServicesModel(
        color: Color(0xFF00C853),
        icon: Icons.currency_bitcoin,
        name: "Buy Crypto",
        route: RoutesConstant.buy_crypto,
      ),
      const OtherServicesModel(
        color: Color(0xFFFF3D00),
        icon: Icons.trending_down,
        name: "Sell Crypto",
        route: RoutesConstant.sell_crypto,
      ),
      const OtherServicesModel(
          color: Color(0xFFAD1457),
          icon: Icons.card_giftcard,
          name: "Buy GiftCard",
          route: RoutesConstant.buy_giftcard),
      const OtherServicesModel(
        color: Color(0xFF7B1FA2),
        icon: Icons.redeem,
        name: "Sell GiftCard",
        route: RoutesConstant.sell_giftcard,
      ),
      const OtherServicesModel(
        color: Color(0xFF1976D2),
        icon: Icons.phone_iphone,
        name: "Airtime",
        route: RoutesConstant.airtime,
      ),
      const OtherServicesModel(
        color: Color(0xFF0097A7),
        icon: Icons.signal_cellular_4_bar,
        name: "Data",
        route: RoutesConstant.gsubz_data,
      ),
      const OtherServicesModel(
        color: Color(0xFFF57C00),
        icon: Icons.bolt,
        name: "Electricity",
        route: RoutesConstant.electricity,
      ),
      const OtherServicesModel(
        color: Color(0xFF689F38),
        icon: Icons.sports_esports,
        name: "Betting",
        route: RoutesConstant.betting,
      ),
      const OtherServicesModel(
        color: Color(0xFF303F9F),
        icon: Icons.live_tv,
        name: "TV",
        route: RoutesConstant.tv,
      ),
      const OtherServicesModel(
        color: Color(0xFF303F9F),
        icon: Icons.airplanemode_active,
        name: "Flight",
        route: RoutesConstant.flight_booking,
      ),
      const OtherServicesModel(
        color: Color(0xFF512DA8),
        icon: Icons.school, // 🎓 Education
        name: "Education",
        route: RoutesConstant.gsubz_exam_pin,
      ),
      const OtherServicesModel(
        color: Color(0xFF00897B),
        icon: Icons.vpn_key, // 🔑 E-PIN or Recharge PIN
        name: "Recharge-Pin",
        route: RoutesConstant.gsubz_recharge_card,
      ),
    ];
  }

  Widget _buildServiceCard(OtherServicesModel service, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: GestureDetector(
              onTap: () => Get.toNamed(service.route),
              child: Container(
                height: 300,
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.circular(20),
                //   border: Border.all(
                //     color: service.color.withOpacity(0.1),
                //     width: 1.5,
                //   ),
                //   boxShadow: [
                //     BoxShadow(
                //         color: service.color.withOpacity(0.1),
                //         blurRadius: 12,
                //         offset: const Offset(0, 6)),
                //     BoxShadow(
                //         color: Colors.black.withOpacity(0.04),
                //         blurRadius: 6,
                //         offset: const Offset(0, 2)),
                //   ],
                // ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    splashColor: service.color.withOpacity(0.1),
                    highlightColor: service.color.withOpacity(0.05),
                    onTap: () {
                      // Add haptic feedback
                      HapticFeedback.lightImpact();
                      Get.toNamed(service.route);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  service.color.withOpacity(0.2),
                                  service.color.withOpacity(0.1)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: service.color.withOpacity(0.2),
                                  width: 1),
                            ),
                            child: Icon(service.icon,
                                color: service.color, size: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            service.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                              letterSpacing: -0.2,
                              height: 1.1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
