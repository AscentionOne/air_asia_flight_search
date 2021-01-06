import 'package:air_asia_flight_search/constants.dart';
import 'package:air_asia_flight_search/widgets/multicity_input.dart';
import 'package:air_asia_flight_search/widgets/price_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ContentCard extends StatefulWidget {
  @override
  _ContentCardState createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  bool showInput = true;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: DefaultTabController(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: [
                _buildTabBar(),
                _buildContentContainer(constraints),
              ],
            );
          },
        ),
        length: 3,
      ),
    );
  }

  Expanded _buildContentContainer(BoxConstraints constraints) {
    return Expanded(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight - 48.0),
          child: IntrinsicHeight(
            child: showInput
                ? _buildMulticityTab()
                : PriceTab(
                    height: constraints.maxHeight - 48.0,
                  ),
          ),
        ),
      ),
    );
  }

  Stack _buildTabBar() {
    return Stack(
      children: [
        // Create background color of tab bar
        Positioned.fill(
          top: null,
          child: Container(
            height: 2.0,
            color: AirAsia.tabBarColor,
          ),
        ),
        TabBar(
          tabs: [
            Tab(text: 'Flight'),
            Tab(text: 'Train'),
            Tab(text: 'Bus'),
          ],
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildMulticityTab() {
    return Column(
      children: [
        MulticityInput(),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                showInput = false;
              });
            },
            child: Icon(
              Icons.timeline,
              size: 36.0,
            ),
          ),
        )
      ],
    );
  }
}
