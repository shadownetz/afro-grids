import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/credentials.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

class GPlaceAutoComplete extends StatefulWidget {
  final String? value;
  final void Function(String placeId, String name)? onSelected;
  const GPlaceAutoComplete({Key? key, this.onSelected, this.value}) : super(key: key);

  @override
  State<GPlaceAutoComplete> createState() => _GPlaceAutoCompleteState();
}

class _GPlaceAutoCompleteState extends State<GPlaceAutoComplete> {
  late final GooglePlace _googlePlace;
  List<AutocompletePrediction> _predictions = [];

  @override
  void initState() {
    _googlePlace = GooglePlace(Credentials.gPlaceKey);
    super.initState();
  }

  void _autoCompleteSearch(String value) async {
    if(value.isNotEmpty){
      var result = await _googlePlace.autocomplete.get(value);
      if (result != null && result.predictions != null && mounted) {
        setState(() {
          _predictions = result.predictions!;
        });
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Autocomplete<AutocompletePrediction>(
          displayStringForOption: (prediction)=>prediction.description?? "",
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<AutocompletePrediction>.empty();
            }
            return _predictions;
          },
          optionsViewBuilder: (
              BuildContext context,
              AutocompleteOnSelected<AutocompletePrediction> onSelected,
              Iterable<AutocompletePrediction> options
              ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 330,
                height: 400,
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
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
                          final AutocompletePrediction option = options.elementAt(index);
                          return GestureDetector(
                              onTap: () {
                                onSelected(option);
                              },
                              child: ListTile(
                                minLeadingWidth: 20,
                                dense: true,
                                visualDensity: const VisualDensity(vertical: -3, horizontal: -4),
                                leading: const Icon(Icons.location_on_outlined),
                                title: Text(option.description??"", style: const TextStyle(color: Colours.primary, fontSize: 18)),
                                subtitle: Text(option.structuredFormatting?.secondaryText??"", style: const TextStyle(color: Colours.primary)),
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
            fieldFocusNode.addListener(() {
              if(!fieldFocusNode.hasFocus && fieldTextEditingController.text.isEmpty){
                if(widget.onSelected != null){
                  widget.onSelected!("","");
                }
              }
            });
            if(widget.value != null && fieldTextEditingController.text.isEmpty){
              fieldTextEditingController.text = widget.value!;
            }
            return TextField(
              controller: fieldTextEditingController,
              focusNode: fieldFocusNode,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'Enter your location',
              ),
              onChanged: (value){
                _autoCompleteSearch(value);
              },
            );
          },
          onSelected: (AutocompletePrediction selection) {
            if(widget.onSelected != null){
              widget.onSelected!(selection.placeId??"", selection.description??"");
            }
          },
        )
    );
  }
}
