import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/app/routes/route.dart';
import 'package:app/domain/models/vehicle/vehicle.model.dart';
import 'package:app/domain/providers/vehicle/vehicle.dependencies.dart';
import 'package:app/domain/services/vehicle.service.dart';
import 'package:app/ui/widgets/headers/header.items.widget.dart';
import 'package:app/ui/widgets/headers/header.control.widget.dart';

class VehicleListView extends StatefulWidget {
  const VehicleListView._();
  static Widget init() => ChangeNotifierProvider(
        lazy: false,
        create: (context) => VehicleService(
          provider: context.read<VehicleProviderProtocol>(),
        ),
        child: const VehicleListView._(),
      );

  @override
  State<VehicleListView> createState() => _VehicleListViewState();
}

class _VehicleListViewState extends State<VehicleListView> {
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
        title: 'Veículos',
        rightActions: [
          HeaderItem(
            // item: const Text("Add"),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pushNamed(
                context,
                Routes.vehicleFormView.value,
              ).then((value) {
                completion();
              });
            },
            completion: completion,
          ),
        ],
      );

  Widget get contentHandler {
    Widget content = const SizedBox();
    data = service.getLocalVehicles;

    if (data.isEmpty) {
      content = const Center(child: Text("Empty List"));
    } else {
      content = buildList(data);
    }

    return Expanded(child: content);
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
