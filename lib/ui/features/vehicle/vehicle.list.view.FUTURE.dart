import 'package:app/app/helpers/api/responses/api.response.helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/app/constants/env.dart';
import 'package:app/app/extensions/asyncSnapshot.extension.dart';
import 'package:app/app/helpers/debugger.helper.dart';
import 'package:app/app/routes/route.dart';
import 'package:app/domain/models/vehicle/vehicle.model.dart';
import 'package:app/domain/providers/vehicle/vehicle.dependencies.dart';
import 'package:app/domain/services/vehicle.service.dart';
import 'package:app/ui/widgets/headers/header.items.widget.dart';
import 'package:app/ui/widgets/headers/header.control.widget.dart';

class VehicleListFUTUREView extends StatefulWidget {
  const VehicleListFUTUREView._();

  static Widget init() => ChangeNotifierProvider(
        lazy: false,
        create: (context) => VehicleService(
          provider: context.read<VehicleProviderProtocol>(),
        ),
        child: const VehicleListFUTUREView._(),
      );

  @override
  State<VehicleListFUTUREView> createState() => _VehicleListFUTUREViewState();
}

class _VehicleListFUTUREViewState extends State<VehicleListFUTUREView> {
  late VehicleService service;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Vehicle> data = [];

  @override
  void initState() {
    setUp();

    super.initState();
  }

  void setUp() {
    service = context.read<VehicleService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Column(
        children: [
          headerControls,
          contentHandler,
        ],
      ),
    );
  }

  Widget get headerControls => HeaderControls(
        title: 'Locais de Trabalho',
        rightActions: [
          HeaderItem(
            route: Routes.vehicleFormView,
            completion: completion,
          ),
        ],
      );

  Widget get contentHandler {
    return FutureBuilder<ApiResponse>(
      future: service.getAll(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            snapshot.requestErrorHandler(context);
            data = snapshot.data?.object ?? [];
            Widget content = const SizedBox();
            if (data.isEmpty) {
              content = const Center(child: Text("Empty List"));
            } else {
              content = buildList(data);
            }

            return Expanded(child: content);

          case ConnectionState.waiting:
            return const Text("Loading");
          default:
            if (snapshot.error != null) {
              Log.e(snapshot.error.toString());
            }
            return Text(Remote.appMessageErrorGeneric.string);
        }
      },
    );
  }

  Widget buildList(List<Vehicle> data) {
    return Column(
      children: data.map((e) => Text(e.name)).toList(),
    );
  }

  void completion() {
    setState(() {});
  }
}
