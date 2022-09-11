import 'dart:ui';

import 'package:afro_grids/blocs/report/report_bloc.dart';
import 'package:afro_grids/blocs/report/report_event.dart';
import 'package:afro_grids/blocs/report/report_state.dart';
import 'package:afro_grids/blocs/service/service_bloc.dart';
import 'package:afro_grids/blocs/service/service_event.dart';
import 'package:afro_grids/main.dart';
import 'package:afro_grids/models/report_model.dart';
import 'package:afro_grids/models/service_model.dart';
import 'package:afro_grids/models/user/user_model.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../blocs/service/service_state.dart';
import '../../utilities/widgets/button_widget.dart';
import '../../utilities/widgets/widgets.dart';

class ReportScreen extends StatefulWidget {
  final UserModel user;
  const ReportScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  var reportController = TextEditingController();
  ServiceModel? _service;

  @override
  Widget build(BuildContext context) {
    return CustomLoadingOverlay(
        widget: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context)=>ServiceBloc()..add(GetServiceEvent(widget.user.serviceId))),
            BlocProvider(create: (context)=>ReportBloc())
          ],
          child: BlocListener<ServiceBloc, ServiceState>(
            listener: (context, state){
              if(state is ServiceLoadedState){
                setState(()=>_service=state.service);
              }
            },
            child: BlocConsumer<ReportBloc, ReportState>(
              listener: (context, state){
                if(state is ReportLoadingState){
                  context.loaderOverlay.show();
                }else{
                  context.loaderOverlay.hide();
                }
                if(state is ReportErrorState){
                  Alerts(context).showErrorDialog(title: "Error", message: state.message);
                }
                if(state is ReportLoadedState){
                  Alerts(context).showToast("Report submitted");
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
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // provider avatar
                              RoundImage(
                                image: (widget.user.avatar.isEmpty ?  const AssetImage('assets/avatars/man.png'): NetworkImage(widget.user.avatar)) as ImageProvider,
                                hasShadow: true,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 15,),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.user.name, style: const TextStyle(fontSize: 25),),
                                  Text(_service!=null? _service!.name: widget.user.accessLevel.toLowerCase(), style: const TextStyle(color: Colors.grey),)
                                ],
                              ))
                            ],
                          ),
                          const SizedBox(height: 20,),
                          TextField(
                            controller: reportController,
                            maxLength: 250,
                            maxLines: 10,
                            cursorHeight: 20,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              hintText: "State your reason",
                              filled: true,
                              fillColor: Color.fromRGBO(240, 240, 240, 1),
                              border: InputBorder.none,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          ElevatedButton(
                              onPressed: ()async{
                                if(reportController.text.isNotEmpty && reportController.text.length > 3){
                                  var report = ReportModel(
                                      id: '',
                                      reason: reportController.text,
                                      createdAt: DateTime.now(),
                                      createdFor: widget.user.id,
                                      createdBy: localStorage.user!.id
                                  );
                                  BlocProvider
                                      .of<ReportBloc>(context)
                                      .add(AddReportEvent(report: report));
                                }else{
                                  Alerts(context).showToast("Your reason is too short");
                                }

                              },
                              style: buttonPrimaryLgStyle(),
                              child: const Text("Submit")
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        )
    );
  }

}
