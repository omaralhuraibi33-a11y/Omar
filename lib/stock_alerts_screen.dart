import 'package:flutter/material.dart';
import 'db_helper.dart';

class StockAlertsScreen extends StatefulWidget {
  const StockAlertsScreen({super.key});
  @override
  State<StockAlertsScreen> createState() => _StockAlertsScreenState();
}
class _StockAlertsScreenState extends State<StockAlertsScreen> {
  final controller = TextEditingController(text: '5');
  @override
  void dispose() { controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('تنبيهات المخزون')),
    body: Column(children: [
      Padding(padding: const EdgeInsets.all(16), child: Row(children: [
        Expanded(child: TextField(controller: controller, keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'تنبيه عند كمية أقل أو تساوي', border: OutlineInputBorder()))),
        IconButton(onPressed: () => setState(() {}), icon: const Icon(Icons.refresh)),
      ])),
      Expanded(child: FutureBuilder<List<Map<String, Object?>>>(
        future: DBHelper.getStockAlerts(minimum: double.tryParse(controller.text) ?? 5),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('خطأ: ${snapshot.error}'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (snapshot.data!.isEmpty) return const Center(child: Text('لا توجد أصناف أقل من الحد'));
          return ListView.builder(itemCount: snapshot.data!.length, itemBuilder: (context, i) {
            final row = snapshot.data![i];
            return ListTile(leading: const Icon(Icons.warning_amber, color: Colors.orange),
              title: Text('${row['name']}'), subtitle: Text('الكمية الحالية: ${row['quantity']}'));
          });
        },
      )),
    ]),
  );
}
