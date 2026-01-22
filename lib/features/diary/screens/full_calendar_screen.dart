import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:krishi_rath/features/diary/models/diary_models.dart';
import 'package:krishi_rath/services/localization_service.dart';
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

  String _tr(String key) => localizationService.translate(key);

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
        title: Text(
          widget.plan.title,
          style: TextStyle(fontSize: 17.sp),
        ),
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
            calendarStyle: CalendarStyle(
              todayDecoration: const BoxDecoration(
                color: Colors.orangeAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(fontSize: 13.sp),
              defaultTextStyle: TextStyle(fontSize: 13.sp),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: ValueListenableBuilder<List<Activity>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                if (value.isEmpty) {
                  return Center(child: Text(_tr('diary_no_activities'), style: TextStyle(fontSize: 13.sp)));
                }
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final activity = value[index];
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: ExpansionTile(
                        leading: Icon(activity.icon, color: Colors.green, size: 22.sp),
                        title: Text(activity.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp)),
                        subtitle: Text(DateFormat.yMMMd().format(activity.scheduledDate), style: TextStyle(fontSize: 13.sp)),
                        children: [
                          if (activity.steps.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.h, horizontal: 12.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_tr('diary_steps'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
                                  SizedBox(height: 6.h),
                                  ...activity.steps.map((step) => Padding(
                                    padding: EdgeInsets.only(bottom: 6.h),
                                    child: Text(step, style: TextStyle(color: Colors.grey[700], fontSize: 13.sp)),
                                  )),
                                ],
                              ),
                            )
                          else
                            Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Text(_tr('diary_no_specific_steps'), style: TextStyle(fontSize: 13.sp)),
                            ),
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
