import 'package:afro_grids/utilities/widgets/button_widget.dart';
import 'package:flutter/material.dart';

import '../../utilities/colours.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  var _ctrller1 = TextEditingController();
  var _ctrller2 = TextEditingController();
  var _ctrller3 = TextEditingController();
  var _ctrller4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colours.tertiary,
        appBar: AppBar(
          title: const Text("Verification"),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 20,),
                const Text(
                  "Enter your code",
                  style: TextStyle(
                    fontSize: 35,
                  ),
                ),
                const SizedBox(height: 10,),
                const Text(
                  "We sent a one time verification code to ",
                  style: TextStyle(fontSize: 17),
                ),
                const Text(
                  "+1 234 567 890",
                  style: TextStyle(color: Colours.secondary, fontSize: 17),
                ),
                const SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // input one
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _ctrller1,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 40, color: Colors.grey),
                        maxLength: 1,
                        cursorColor: Colors.grey,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterText: "",
                            hintText: "*"
                        ),
                        onChanged: (value){
                          if(value.isNotEmpty){
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    ),
                    // input two
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextField(
                          controller: _ctrller2,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 40, color: Colors.grey),
                          maxLength: 1,
                          cursorColor: Colors.grey,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              counterText: "",
                              hintText: "*"
                          ),
                          onChanged: (value){
                            if(value.isNotEmpty){
                              FocusScope.of(context).nextFocus();
                            }else{
                              FocusScope.of(context).previousFocus();
                            }
                          }
                      ),
                    ),
                    // input three
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child:  TextField(
                          controller: _ctrller3,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 40, color: Colors.grey),
                          maxLength: 1,
                          cursorColor: Colors.grey,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              counterText: "",
                              hintText: "*"
                          ),
                          onChanged: (value){
                            if(value.isNotEmpty){
                              FocusScope.of(context).nextFocus();
                            }else{
                              FocusScope.of(context).previousFocus();
                            }
                          }
                      ),
                    ),
                    // input four
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextField(
                          controller: _ctrller4,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 40, color: Colors.grey),
                          maxLength: 1,
                          cursorColor: Colors.grey,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              counterText: "",
                              hintText: "*"
                          ),
                          onChanged: (value){
                            if(value.isNotEmpty){
                              FocusScope.of(context).nextFocus();
                            }else{
                              FocusScope.of(context).previousFocus();
                            }
                          }
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Resend code in "),
                    Text("00:00:30", style: TextStyle(color: Colours.secondary),)
                  ],
                ),
                Center(
                  child:  Column(
                    children: [
                      TextButton(
                          onPressed: ()=>{},
                          child: const Text("Resend code", style: TextStyle(color: Colours.secondary),)
                      ),
                      const SizedBox(height: 30,),
                      ElevatedButton(
                          style: buttonMdStyle(),
                          onPressed: ()=>{},
                          child: const Text("Continue")
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
