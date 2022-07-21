import 'package:afro_grids/utilities/widgets/widget_models.dart';
import 'package:flutter/material.dart';

import '../../utilities/colours.dart';
import '../../utilities/widgets/widgets.dart';


class ProviderInfoScreen extends StatefulWidget {
  const ProviderInfoScreen({Key? key}) : super(key: key);

  @override
  State<ProviderInfoScreen> createState() => _ProviderInfoScreenState();
}

class _ProviderInfoScreenState extends State<ProviderInfoScreen> {
  late ProviderWidgets providerWidgets;

  @override
  void initState() {
    providerWidgets = ProviderWidgets(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: providerWidgets.portfolioAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // provider stats block
            providerWidgets.portfolioActionBar(),
            const SizedBox(height: 30,),
            // Tab section
            PortfolioTabs(
                tabs: [
                  ProviderPortfolioTabModel(
                    label: "details",
                    labelWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info, size: 15,),
                        Text("Details", style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ),
                    child: detailsTabView()
                  ),
                  ProviderPortfolioTabModel(
                    label: "reviews",
                    labelWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star_border, size: 15,),
                        Text("Reviews", style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                    child: Container()
                  )
                ],
                onClick: (value){
                  print(value);
                }
            )
          ],
        ),
      ),
    );
  }

  Widget detailsTabView(){
    return Column(
      children: const [
        Text("Message from this provider", style: TextStyle(fontSize: 18),),
        SizedBox(height: 20,),
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Leo morbi dui tincidunt egestas nunc a. Tincidunt vel id nulla neque nisl. Donec imperdiet at mattis tristique senectus facilisi. In lobortis et egestas odio quis amet, turpis.\n        Egestas congue ut blandit nam in risus massa gravida in. Rutrum ut dolor suscipit quam pellentesque. Integer convallis faucibus id neque turpis ut vivamus nisl. Ac congue morbi quis congue feugiat dictum in. Faucibus egestas in cursus odio mattis volutpat. Tellus ut lorem ut aliquet iaculis commodo.")
      ],
    );
  }
}
