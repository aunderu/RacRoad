import 'package:flutter/material.dart';
import 'package:rac_road/models/market/market_item.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MarketItem> item = [
      MarketItem("assets/imgs/markets/car_tires.jpg", "ยางรถ", null),
      MarketItem("assets/imgs/markets/alloy_wheel.jpg", "แม็กล้อ", null),
      MarketItem("assets/imgs/markets/brake.jpg", "เบรก", null),
      MarketItem("assets/imgs/markets/battery.jpg", "แบตเตอรี่", null),
      MarketItem("assets/imgs/markets/shock.png", "โชคอัป", null),
      MarketItem("assets/imgs/markets/car_mat.jpg", "พรมเช็ดเท้าในรถ", null),
      MarketItem("assets/imgs/markets/car_shampoo.jpg", "น้ำยาล้างรถ", null),
    ];

    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "สนใจสามารถติดต่อได้ที่เบอร์ - 0614531146",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: item.length,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: Colors.white,
                            child: Image.asset(item[index].image,
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            // Text(
                            //   "฿${item[index].price ?? "0"} ",
                            //   style: const TextStyle(
                            //     fontSize: 20,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            Expanded(
                              child: Text(
                                item[index].name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 20,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
