import 'package:flutter/material.dart';

void main() => runApp(const GPAApp());

class GPAApp extends StatelessWidget {
  const GPAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GPA Calculator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const GPAPage(),
    );
  }
}

class Subject {
  final name = TextEditingController();
  final grade = TextEditingController();
  final credit = TextEditingController();
}

class GPAPage extends StatefulWidget {
  const GPAPage({super.key});

  @override
  State<GPAPage> createState() => _GPAPageState();
}

class _GPAPageState extends State<GPAPage> {
  final List<Subject> subjects = [];
  double gpa = 0;
  int credits = 0;
  
  void addSubject() => setState(() => subjects.add(Subject()));

  void removeSubject(int i) => setState(() => subjects.removeAt(i));

  double gradePoint(double g) {
    if (g >= 90) return 4;
    if (g >= 80) return 3;
    if (g >= 70) return 2;
    if (g >= 60) return 1;
    return 0;
  }

  void calculateGPA() {
    double points = 0;
    credits = 0;

    for (var s in subjects) {
      if (s.grade.text.isEmpty || s.credit.text.isEmpty) continue;

      final g = double.tryParse(s.grade.text) ?? 0;
      final c = int.tryParse(s.credit.text) ?? 0;

      points += gradePoint(g) * c;
      credits += c;
    }

    setState(() => gpa = credits == 0 ? 0 : points / credits);
  }

  Widget subjectCard(int i) {
    final s = subjects[i];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Text("Subject ${i + 1}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => removeSubject(i),
                )
              ],
            ),
            TextField(
              controller: s.name,
              decoration: const InputDecoration(labelText: "Subject Name"),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: s.grade,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: "Grade (0–100)"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: s.credit,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: "Credits"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Semester GPA Calculator"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: addSubject,
        icon: const Icon(Icons.add),
        label: const Text("Add Subject"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: subjects.isEmpty
                  ? const Center(
                      child: Text("Add subjects to calculate GPA"),
                    )
                  : ListView.builder(
                      itemCount: subjects.length,
                      itemBuilder: (_, i) => subjectCard(i),
                    ),
            ),

            Card(
              color: const Color.fromARGB(255, 153, 238, 199),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "GPA: ${gpa.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10, width: 350),
                    Text("Total Credits: $credits"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: calculateGPA,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 30),
                      ),
                      child: const Text("Calculate GPA"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
