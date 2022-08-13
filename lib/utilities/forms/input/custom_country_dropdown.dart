import 'package:afro_grids/utilities/colours.dart';
import 'package:country_currency_pickers/country_picker_dialog.dart';
import 'package:country_currency_pickers/currency_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/currency_picker_dropdown.dart';
import 'package:country_currency_pickers/utils/utils.dart';

class CustomCountryDropdown extends StatefulWidget {
  final void Function(String value) onSelected;
  const CustomCountryDropdown({Key? key, required this.onSelected}) : super(key: key);

  @override
  State<CustomCountryDropdown> createState() => _CustomCountryDropdownState();
}

class _CustomCountryDropdownState extends State<CustomCountryDropdown> {
  var currencyController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>_openCurrencyPickerDialog(),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
            labelText: "Currency",
            helperText: "tap to setup a currency for your portfolio",
        ),
        value: currencyController.text,
        onChanged: null,
        disabledHint: const Text("Currency"),
        items: [
          DropdownMenuItem<String>(
            enabled: false,
            value: currencyController.text,
            child: Text(currencyController.text),
          )
        ],
      ),
    );
  }

  Widget _buildCurrencyDialogItem(Country country) => Row(
    children: <Widget>[
      CountryPickerUtils.getDefaultFlagImage(country),
      const SizedBox(
        width: 8.0,
      ),
      Text("${country.currencyCode}"),
    ],
  );

  void _openCurrencyPickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
        data: Theme.of(context).copyWith(
            primaryColor: Colours.primary,
          dialogBackgroundColor: Colours.tertiary
        ),
        child: CurrencyPickerDialog(
            titlePadding: const EdgeInsets.all(8.0),
            searchCursorColor: Colours.primary,
            searchInputDecoration: const InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: const Text('Select your Currency'),
            onValuePicked: (Country country){
             setState(()=>currencyController.text = "${country.currencyCode} (${country.currencyName})");
              widget.onSelected(country.currencyCode??"");
            },
            itemBuilder: _buildCurrencyDialogItem)),
  );

}