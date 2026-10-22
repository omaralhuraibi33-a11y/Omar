import 'package:flutter/material.dart';
import 'db_helper.dart';

class AuditScreen extends StatelessWidget {
  const AuditScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('سجل العمليات')),
    body: FutureBuilder<List<Map<String, Object?>>>(
      future: DBHelper.getAuditLog(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text('خطأ: ${snapshot.error}'));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        if (snapshot.data!.isEmpty) return const Center(child: Text('لا توجد عمليات مسجلة بعد'));
        return ListView.builder(itemCount: snapshot.data!.length, itemBuilder: (context, index) {
          final row = snapshot.data![index];
          return ListTile(leading: const Icon(Icons.history),
            title: Text('${row['operation']} - ${row['table_name']}'),
            subtitle: Text('السجل: ${row['record_id'] ?? '-'} | ${row['created_at']}'));
        });
      },
    ),
  );
}
