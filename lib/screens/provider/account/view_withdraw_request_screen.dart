import 'package:afro_grids/blocs/withdraw/withdraw_bloc.dart';
import 'package:afro_grids/models/user/user_model.dart';
import 'package:afro_grids/utilities/type_extensions.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../blocs/withdraw/withdraw_event.dart';
import '../../../blocs/withdraw/withdraw_state.dart';
import '../../../models/withdraw_model.dart';
import '../../../utilities/alerts.dart';
import '../../../utilities/colours.dart';
import '../../../utilities/currency.dart';

class ViewWithdrawRequestScreen extends StatefulWidget {
  final UserModel user;
  const ViewWithdrawRequestScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ViewWithdrawRequestScreen> createState() => _ViewWithdrawRequestScreenState();
}

class _ViewWithdrawRequestScreenState extends State<ViewWithdrawRequestScreen> {
  List<WithdrawModel>? _withdrawals;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(color: Colors.white,),
        title: const Text("Withdraw Requests"),
      ),
      body: CustomLoadingOverlay(
        widget: BlocProvider<WithdrawBloc>(
          create: (context)=>WithdrawBloc()..add(FetchUserWithdrawalsEvent(user: widget.user)),
          child: BlocConsumer<WithdrawBloc, WithdrawState>(
            listener: (context, state){
              if(state is WithdrawLoadingState){
                context.loaderOverlay.show();
              }else{
                context.loaderOverlay.hide();
              }
              if(state is WithdrawErrorState){
                Alerts(context).showToast(state.message, duration: const Duration(seconds: 3));
              }
              if(state is WithdrawLoadedState){
                setState(()=>_withdrawals = state.withdrawals);
              }
            },
            builder: (context, state){
              if(_withdrawals != null){
                if(_withdrawals!.isNotEmpty){
                  return ListView(
                    children: buildWithdrawals(),
                  );
                }
              }
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Text("You have not placed a withdrawal request", style: TextStyle(fontSize: 20, color: Colors.grey),),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> buildWithdrawals(){
    return _withdrawals!.map((withdraw){
      return ListTile(
        title: Text("${CurrencyUtil().currencySymbol(withdraw.currency)}${withdraw.amount}"),
        subtitle: Text(withdraw.createdAt.toDateTimeStr()),
        trailing: Text(
          withdraw.status,
          style: TextStyle(
              color: withdraw.status.statusColor()
          ),
        ),
      );
    }).toList();
  }
}
