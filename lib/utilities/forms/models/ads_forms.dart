import 'package:afro_grids/models/ads_model.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:image_picker/image_picker.dart';

import '../../../main.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/selectors/ads_file_selector.dart';

class AddAdsForm extends StatefulWidget {
  final Function(AdsModel service, XFile file) onComplete;
  const AddAdsForm({
    Key? key,
    required this.onComplete
  }) : super(key: key);

  @override
  State<AddAdsForm> createState() => _AddAdsFormState();
}

class _AddAdsFormState extends State<AddAdsForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime _expireAt = DateTime.now().add(const Duration(hours: 1));
  final _vendorNameController = TextEditingController();
  final _vendorLinkController = TextEditingController();
  XFile? _file;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: AdsFileSelector(
                onUpdated: (image)=>_file=image,
              ),
            ),
            TextFormField(
              controller: _nameController,
              cursorHeight: 20,
              validator: (value){
                if(value != null){
                  if(value.isNotEmpty){
                    return null;
                  }
                }
                return "Enter a valid name for this advert";
              },
              decoration: const InputDecoration(
                labelText: "Advert name",
                hintText: "Get a 10% discount on all items",
              ),
            ),
            const SizedBox(height: 10,),
            DateTimeFormField(
                firstDate: DateTime.now(),
                initialDate: _expireAt,
                onDateSelected: (value)=>_expireAt=value,
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.black45),
                  suffixIcon: Icon(Icons.event_note),
                  labelText: 'Advert expiration',
                ),
                validator: (value){
                  if(value != null){
                    return null;
                  }
                  return "Enter a valid expiration for this advert";
                }
            ),
            const SizedBox(height: 10,),
            TextFormField(
              controller: _vendorNameController,
              cursorHeight: 20,
              validator: (value){
                if(value != null){
                  if(value.isNotEmpty){
                    return null;
                  }
                }
                return "Enter a valid name for the vendor";
              },
              decoration: const InputDecoration(
                labelText: "Vendor name",
              ),
            ),
            const SizedBox(height: 10,),
            TextFormField(
              controller: _vendorLinkController,
              keyboardType: TextInputType.url,
              cursorHeight: 20,
              validator: (value){
                if(value != null){
                  if(value.isNotEmpty){
                    return null;
                  }
                }
                return "Enter a valid redirect link for the advert";
              },
              decoration: const InputDecoration(
                  labelText: "Advert go to link",
                  hintText: "https://website.com"
              ),
            ),
            const SizedBox(height: 50,),
            ElevatedButton(
                style: buttonPrimarySmStyle(),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    if(_file != null){
                      widget.onComplete(
                          AdsModel(
                              id: "",
                              fileURL: "",
                              createdAt: DateTime.now(),
                              expireAt: _expireAt,
                              name: _nameController.text,
                              createdBy: localStorage.user!.id,
                              vendorName: _vendorNameController.text,
                              vendorLink: _vendorLinkController.text
                          ),
                          _file!
                      );
                    }else{
                      Alerts(context).showToast("Upload an advert banner");
                    }
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.save, size: 20,),
                    SizedBox(width: 10,),
                    Text("Upload", style: TextStyle(fontSize: 20,),)
                  ],
                )
            )
          ],
        )
    );
  }
}
