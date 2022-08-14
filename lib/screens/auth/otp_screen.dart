import 'dart:async';

import 'package:afro_grids/blocs/auth/auth_bloc.dart';
import 'package:afro_grids/blocs/auth/auth_event.dart';
import 'package:afro_grids/main.dart';
import 'package:afro_grids/utilities/forms/auth_forms.dart';
import 'package:afro_grids/utilities/widgets/button_widget.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../blocs/auth/auth_state.dart';
import '../../utilities/alerts.dart';
import '../../utilities/colours.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _ctrller1 = TextEditingController();
  final _ctrller2 = TextEditingController();
  final _ctrller3 = TextEditingController();
  final _ctrller4 = TextEditingController();
  String? _verCode;
  num _minuteTimer = 0;
  bool _runningTimer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colours.tertiary,
        appBar: AppBar(
          title: const Text("Verification"),
        ),
        body: CustomLoadingOverlay(
          widget: BlocProvider(
            create: (context)=>AuthBloc()..add(SendPhoneVerificationEvent(user: localStorage.user!)),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state){
                if(state is AuthLoadingState){
                  context.loaderOverlay.show();
                }else{
                  context.loaderOverlay.hide();
                }
                if(state is SentPhoneVerificationState){
                  if(state.verificationCode != null){
                    runTimer();
                    _verCode = state.verificationCode!;
                    Alerts(context).showToast("Sent verification code");
                  }else{
                    Alerts(context).showToast("Unable to send verification code");
                  }
                }
                if(state is AuthErrorState){
                  Alerts(context).showErrorDialog(title: "Verification Error", message: state.message);
                }
                if(state is AuthenticatedState){
                  if(state.user!.isProvider){
                    Navigator.of(context).pushReplacementNamed("/provider-dashboard");
                  }else{
                    Navigator.of(context).pushReplacementNamed("/user-dashboard");
                  }
                  Alerts(context).showToast("Logged in");
                }
                if(state is UnAuthenticatedState){
                  Navigator.of(context).pushReplacementNamed("/signin");
                }
                if(state is PhoneUpdatedState){
                  localStorage.user!.setPhone(state.phone);
                  BlocProvider.of<AuthBloc>(context).add(SendPhoneVerificationEvent(user: localStorage.user!));
                }
              },
              builder: (context, state){
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: SingleChildScrollView(
                    child: AnimatedCrossFade(
                      firstChild: PhoneUpdateForm(
                          onComplete: (phone){
                            BlocProvider.of<AuthBloc>(context).add(UpdatePhoneEvent(user: localStorage.user!, phone: phone));
                          }
                      ),
                      secondChild: verificationForm(context),
                      crossFadeState: localStorage.user!.phone.isEmpty? CrossFadeState.showFirst: CrossFadeState.showSecond,
                      duration: const Duration(seconds: 1),
                    ),
                  ),
                );
              },
            ),
          ),
        )
    );
  }

  Widget verificationForm(BuildContext context){
    return Column(
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
        Text(
          localStorage.user!.phone,
          style: const TextStyle(color: Colours.secondary, fontSize: 17),
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
          children: [
            const Text("Resend code in "),
            Text("00:00:${_minuteTimer==0?'00':_minuteTimer}", style: const TextStyle(color: Colours.secondary),)
          ],
        ),
        Center(
          child:  Column(
            children: [
              TextButton(
                  onPressed: (){
                    if(!_runningTimer){
                      BlocProvider.of<AuthBloc>(context).add(SendPhoneVerificationEvent(user: localStorage.user!));
                    }
                  },
                  child: Text("Resend code", style: TextStyle(color: _runningTimer? Colors.grey: Colours.secondary),)
              ),
              const SizedBox(height: 30,),
              ElevatedButton(
                  style: buttonMdStyle(),
                  onPressed: ()=>{
                    if(_verCode != null){
                      BlocProvider.of<AuthBloc>(context).add(PostPhoneVerificationLoginEvent(_verCode!, getInputCode))
                    }else{
                      Alerts(context).showToast("Unable to proceed")
                    }
                  },
                  child: const Text("Continue")
              ),
              _verCode !=null? Text(_verCode!): const Text("")
            ],
          ),
        ),
      ],
    );
  }

  String get getInputCode{
    return "${_ctrller1.text}${_ctrller2.text}${_ctrller3.text}${_ctrller4.text}";
  }

  void runTimer(){
    _runningTimer = true;
    _minuteTimer = 60;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if(mounted){
        setState((){
          if(_runningTimer && _minuteTimer > 0){
            _minuteTimer--;
          }else{
            _minuteTimer = 0;
            _runningTimer = false;
            timer.cancel();
          }
        });
      }
    });
  }
}
