

# cartographer_common_task_thread_pool



## Task 和 Thread_pool

线程池：一定数量的线程集合。 用于执行task（任务，可以简单理解为函数）。执行过程中，task  被插入任务队列task_queue,线程池根据插入顺序依次执行。task之间可能有依赖关系，如task_b依赖于task_a。在，task依赖没执行完时，task不能执行，因此task有新建、调配、依赖执行完成、执行、执行完成等多个状态。包括：

 **NEW：**新建任务，还未schedule到线程池。

 **DISPATCHED：** 任务已经schedule 到线程池。

 **DEPENDENCIES_COMPLETED：** 任务依赖已经执行完成。

 **RUNNING：** 任务执行中。 **COMPLETED：** 任务完成。

 对任一个任务的状态转换顺序为： **NEW->DISPATCHED->DEPENDENCIES_COMPLETED->RUNNING->COMPLETED**



## **Task 和 Thread_pool 关系**

1. 新的Task 通过Thread_pool -> Schedule 部署到 线程池Thread_pool 的  tasks_not_ready_队列中。  当该Task没有依赖，直接插入task_queue，准备执行，否则，等待DEPENDENCIES_COMPLETED 。

2. Thread_pool 通过固定数量的thread 与 task_queue（待执行的task队列）执行函数绑定。Thread_pool 按照队列首尾顺序不断执行Task。

3. 在执行Task过程中，tasks_not_ready_中的Task状态不断变化，一旦变为DEPENDENCIES_COMPLETED就插入到task_queue中。最终所有Task都会插入task_queue中，得到执行。 当Task状态变为DEPENDENCIES_COMPLETED，即从tasks_not_ready_转移到task_queue，准备执行。

