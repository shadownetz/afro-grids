import 'dart:ui';

import 'package:afro_grids/blocs/withdraw/withdraw_bloc.dart';
import 'package:afro_grids/blocs/withdraw/withdraw_event.dart';
import 'package:afro_grids/blocs/withdraw/withdraw_state.dart';
import 'package:afro_grids/models/user/user_model.dart';
import 'package:afro_grids/models/withdraw_model.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/class_constants.dart';
import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../utilities/currency.dart';
import '../../../utilities/widgets/button_widget.dart';
import '../../../utilities/widgets/widgets.dart';


class WithdrawRequestScreen extends StatefulWidget {
  final UserModel user;
  const WithdrawRequestScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<WithdrawRequestScreen> createState() => _WithdrawRequestScreenState();
}

class _WithdrawRequestScreenState extends State<WithdrawRequestScreen> {
  var amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomLoadingOverlay(
        widget: BlocProvider<WithdrawBloc>(
          create: (context)=>WithdrawBloc(),
          child: BlocConsumer<WithdrawBloc, WithdrawState>(
            listener: (context, state) async {
              if(state is WithdrawLoadingState){
                context.loaderOverlay.show();
              }else{
                context.loaderOverlay.hide();
              }
              if(state is WithdrawErrorState){
                Alerts(context).showErrorDialog(title: "Unable to submit request", message: state.message);
              }
              if(state is WithdrawLoadedState){
                await Alerts(context).showInfoDialog(
                    title: "Message",
                    message: "Your withdrawal request have been sent for processing. Kindly note that this request will be handled in less than 24 hours"
                );
                NavigationService.exitPage(true);
              }
            },
            builder: (context, state){
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom
                  ),
                  child: Container(
                    // alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20,),
                          TextFormField(
                            controller: amountController,
                            cursorHeight: 20,
                            style: const TextStyle(fontSize: 18),
                            validator: (value){
                              if(value != null){
                                var val = double.tryParse(value);
                                if(val != null){
                                  if(val <= widget.user.availableBalance){
                                    return null;
                                  }
                                }
                              }
                              return "Enter a valid amount";
                            },
                            decoration: InputDecoration(
                              labelText: "Withdrawal Amount",
                              hintText: "0.00",
                              helperText: "available: ${CurrencyUtil().currencySymbol(widget.user.currency)}${widget.user.availableBalance}",
                              filled: true,
                              fillColor: const Color.fromRGBO(240, 240, 240, 1),
                              border: InputBorder.none,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          ElevatedButton(
                              onPressed: (){
                                if(_formKey.currentState!.validate()){
                                  var withdraw = WithdrawModel(
                                      id: "",
                                      createdBy: widget.user.id,
                                      amount: double.parse(amountController.text),
                                      currency: widget.user.currency,
                                      status: WithdrawalStatus.pending,
                                      createdAt: DateTime.now()
                                  );
                                  BlocProvider
                                      .of<WithdrawBloc>(context)
                                      .add(PlaceWithdrawalEvent(withdrawModel: withdraw));
                                }
                              },
                              style: buttonPrimaryLgStyle(),
                              child: const Text("Submit")
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
    );
  }

}
