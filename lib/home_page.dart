import 'package:air_asia_flight_search/widgets/air_asia_bar.dart';
import 'package:air_asia_flight_search/widgets/content_card.dart';
import 'package:air_asia_flight_search/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AirAsiaBar(),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 40.0),
              child: Column(
                children: [
                  _buildButtonRow(),
                  Expanded(child: ContentCard()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: CustomRoundedButton(
              text: 'ONE WAY',
              onTap: () {},
            ),
          ),
          Expanded(
            child: CustomRoundedButton(
              text: 'ROUND',
              onTap: () {},
            ),
          ),
          Expanded(
            child: CustomRoundedButton(
              text: 'MULTICITY',
              onTap: () {},
              selected: true,
            ),
          ),
        ],
      ),
    );
  }
}
