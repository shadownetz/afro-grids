import 'package:afro_grids/models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../utilities/colours.dart';

class ServiceSearchScreen extends StatefulWidget {
  const ServiceSearchScreen({Key? key}) : super(key: key);

  @override
  State<ServiceSearchScreen> createState() => _ServiceSearchScreenState();
}

class _ServiceSearchScreenState extends State<ServiceSearchScreen> {
  @override
  Widget build(BuildContext context) {
    List<ServiceModel> kOptions = <ServiceModel>[
      ServiceModel(id: '', name: 'Hair Dresser M', serviceCategoryId: 'Fashion', createdAt: DateTime.now()),
      ServiceModel(id: '', name: 'Minter', serviceCategoryId: 'Finance', createdAt: DateTime.now()),
      ServiceModel(id: '', name: 'Event Planner M', serviceCategoryId: 'Outdoor Event', createdAt: DateTime.now()),
      ServiceModel(id: '', name: 'Hair Dresser M', serviceCategoryId: 'Fashion', createdAt: DateTime.now()),
      ServiceModel(id: '', name: 'Minter', serviceCategoryId: 'Finance', createdAt: DateTime.now()),
      ServiceModel(id: '', name: 'Event Planner M', serviceCategoryId: 'Outdoor Event', createdAt: DateTime.now()),
      ServiceModel(id: '', name: 'Hair Dresser M', serviceCategoryId: 'Fashion', createdAt: DateTime.now()),
      ServiceModel(id: '', name: 'Minter', serviceCategoryId: 'Finance', createdAt: DateTime.now()),
      ServiceModel(id: '', name: 'Event Planner M', serviceCategoryId: 'Outdoor Event', createdAt: DateTime.now()),
    ];

    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        backgroundColor: Colours.tertiary,
        foregroundColor: Colours.primary,
        leading: IconButton(
          onPressed: ()=>Navigator.of(context).pop(),
          icon: const Icon(Ionicons.close_outline),
        ),
        title: const Text("Enter Service Category"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/logo_map.png"),
            alignment: Alignment(0.8, 0.8)
          )
        ),
        child: Stack(
          children: [
            // Search Section
            Container(
              decoration: BoxDecoration(
                  color: Colours.tertiary,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, spreadRadius: 3, blurRadius: 5, offset: Offset.fromDirection(1))
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child:  Row(
                  children: [
                    const Icon(Ionicons.locate_outline, color: Colours.primary,size: 25,),
                    const SizedBox(width: 30,),
                    // Search Bar
                    Expanded(
                      child: Autocomplete<ServiceModel>(
                        displayStringForOption: (service)=>service.name,
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<ServiceModel>.empty();
                          }
                          return kOptions.where((ServiceModel option) {
                            return option.name.toLowerCase().contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        optionsViewBuilder: (
                            BuildContext context,
                            AutocompleteOnSelected<ServiceModel> onSelected,
                            Iterable<ServiceModel> options
                            ) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 330,
                              height: 400,
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(color: Colors.black26,blurRadius: 5)
                                  ]
                              ),
                              child: Material(
                                  color: Colours.tertiary,
                                  elevation: 20,
                                  child: MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: options.length,
                                      separatorBuilder: (context, i) {
                                        return Divider();
                                      },
                                      itemBuilder: (BuildContext context, int index) {
                                        final ServiceModel option = options.elementAt(index);
                                        return GestureDetector(
                                            onTap: () {
                                              onSelected(option);
                                            },
                                            child: ListTile(
                                              minLeadingWidth: 20,
                                              dense: true,
                                              visualDensity: VisualDensity(vertical: -3, horizontal: -4),
                                              leading: const Icon(Ionicons.pin_outline),
                                              title: Text(option.name, style: const TextStyle(color: Colours.primary, fontSize: 18)),
                                              subtitle: Text(option.serviceCategoryId, style: const TextStyle(color: Colours.primary)),
                                            )
                                        );
                                      },
                                    ),
                                  )
                              ),
                            ),
                          );
                        },
                        fieldViewBuilder: (
                            BuildContext context,
                            TextEditingController fieldTextEditingController,
                            FocusNode fieldFocusNode,
                            VoidCallback onFieldSubmitted
                            ) {
                          return TextField(
                            controller: fieldTextEditingController,
                            focusNode: fieldFocusNode,
                            decoration: const InputDecoration(
                              hintText: 'What service are you looking for',
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                            ),
                          );
                        },
                        onSelected: (ServiceModel selection) {
                          debugPrint('You just selected $selection');
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, spreadRadius: 3, blurRadius: 5, offset: Offset.fromDirection(1))
                    ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.location_on_sharp, color: Colours.primary, size: 15,),
                    Text("Choose on map", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
