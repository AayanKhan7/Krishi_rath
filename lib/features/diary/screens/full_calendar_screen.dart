import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:krishi_rath/features/diary/models/diary_models.dart';
import 'package:table_calendar/table_calendar.dart';

class FullCalendarScreen extends StatefulWidget {
  final CropPlan plan;
  const FullCalendarScreen({super.key, required this.plan});

  @override
  State<FullCalendarScreen> createState() => _FullCalendarScreenState();
}

class _FullCalendarScreenState extends State<FullCalendarScreen> {
  late final ValueNotifier<List<Activity>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  List<Activity> _getEventsForDay(DateTime day) {
    return widget.plan.activities.where((activity) {
      return isSameDay(activity.scheduledDate, day);
    }).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plan.title),
      ),
      body: Column(
        children: [
          TableCalendar<Activity>(
            firstDay: widget.plan.sowDate.subtract(const Duration(days: 30)),
            lastDay: widget.plan.sowDate.add(const Duration(days: 120)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            onDaySelected: _onDaySelected,
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.orangeAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Activity>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                if (value.isEmpty) {
                  return const Center(child: Text('No activities on this day.'));
                }
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final activity = value[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ExpansionTile(
                        leading: Icon(activity.icon, color: Colors.green),
                        title: Text(activity.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(DateFormat.yMMMd().format(activity.scheduledDate)),
                        children: [
                          if (activity.steps.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0, bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Steps:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  ...activity.steps.map((step) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(step, style: TextStyle(color: Colors.grey[700])),
                                  )).toList(),
                                ],
                              ),
                            )
                          else
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('No specific steps provided for this task.'),
                            )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}