import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/States.dart';
import 'cubit/cubit.dart';

class Archivedtasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).archivedTasks;

        return ConditionalBuilder(
          condition: tasks.isNotEmpty,
          builder: (context) => ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => Dismissible(
                    key: Key('archive'),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Center(
                                  child: Text(
                                    '${tasks[index]['time']}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${tasks[index]['title']}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${tasks[index]['date']}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              AppCubit.get(context).updateDate(
                                  status: 'done', id: tasks[index]['id']);
                            },
                            icon: const Icon(
                              Icons.check_box_outlined,
                              color: Colors.green,
                              size: 35,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: IconButton(
                              onPressed: () {
                                AppCubit.get(context).updateDate(
                                    status: 'archive', id: tasks[index]['id']);
                              },
                              icon: const Icon(
                                Icons.archive_outlined,
                                color: Colors.black45,
                                size: 35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onDismissed: (direction) {
                      AppCubit.get(context).deleteDate(id: tasks[index]['id']);
                    },
                  ),
              separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsetsDirectional.only(start: 20),
                    child: Container(
                      width: double.infinity,
                      height: 1.0,
                      color: Colors.grey[300],
                    ),
                  ),
              itemCount: tasks.length),
          fallback: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.access_time,
                  size: 90,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'No Tasks Yet, Please Add some...',
                  style: TextStyle(color: Colors.black45, fontSize: 20),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
