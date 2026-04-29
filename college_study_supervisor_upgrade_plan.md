# 大学生学习监督 App：工程化升级方案

## 1. 项目定位

项目名称建议：**基于 Flutter 的大学生学习监督与自律管理系统**

目标是从“单机打卡 Demo”升级为一个可展示、可发布、可继续扩展的多端 App：

- Android：学生日常使用主端
- Linux：课程设计演示 / 桌面自习监督端
- Web / Chrome：GitHub Pages 部署展示端
- 后续可扩展 iOS / Windows / macOS

核心价值：

> 帮助大学生把课程任务、番茄钟专注、自律积分、学习统计、同学监督和 AI 学习建议整合在一个系统中。

---

## 2. 新功能模块

### 2.1 任务监督模块

已有功能可以增强为：

- 课程任务创建、编辑、删除
- 任务类型：复习、作业、代码、阅读、实验、考试
- 任务优先级：低 / 中 / 高 / 紧急
- 任务截止时间
- 任务预计用时
- 任务完成证明：文字备注 / 图片附件 / 链接
- 今日任务自动生成
- 逾期任务自动扣自律分

### 2.2 专注学习模块

从普通番茄钟升级为：

- 5 / 15 / 25 / 45 / 60 分钟专注模式
- 正计时自由专注
- 专注中断惩罚
- 专注结束奖励
- 专注 Session 历史记录
- 每门课程专注时间统计
- 专注目标：每天 60 / 120 / 180 分钟
- 深度学习模式：连续专注 2 个番茄钟以上

### 2.3 自律积分模块

设计一个可解释的积分系统：

| 行为 | 积分变化 |
|---|---:|
| 完成普通任务 | +5 ~ +15 |
| 完成高优先级任务 | +20 |
| 完成一轮专注 | +5 ~ +20 |
| 连续打卡一天 | +10 |
| 提前放弃专注 | -5 |
| 任务逾期 | -10 |
| 当日未达最低目标 | -15 |

自律分展示：

- 0 ~ 40：摸鱼危险
- 41 ~ 70：状态一般
- 71 ~ 85：状态良好
- 86 ~ 100：自律优秀

### 2.4 学习统计模块

新增图表：

- 最近 7 天专注时长折线图
- 课程专注占比饼图
- 每日任务完成柱状图
- 自律分趋势图
- 连续监督天数热力图
- 本周总结卡片

### 2.5 同学监督模块

可以设计成“轻社交”：

- 创建学习小组
- 邀请同学加入
- 查看组员今日完成状态
- 互相点赞 / 催促
- 排行榜：本周专注时长、连续打卡天数
- 组内挑战：例如“7 天不摆烂挑战”

### 2.6 AI 学习助手模块

前沿一点的卖点：

- 根据课程任务自动生成今日学习计划
- 根据最近 7 天数据生成学习周报
- 根据逾期任务给出补救方案
- 输入考试时间，自动倒排复习计划
- 输入课程名，生成复习清单

建议先做“规则 + 伪 AI 文案”，后续再接大模型 API 或 Supabase Edge Function。

---

## 3. 推荐技术栈

### 3.1 前端主框架

```yaml
Flutter stable
Dart 3
Material 3
```

用途：一套代码同时发布 Android、Linux、Web。

### 3.2 状态管理

```yaml
flutter_riverpod
riverpod_annotation
riverpod_generator
riverpod_lint
```

用途：替代 StatefulWidget 里堆状态，让任务、专注、统计、设置分模块管理。

### 3.3 路由

```yaml
go_router
go_router_builder
```

用途：适配 Android / Linux / Web，多页面 URL 路由、深链接、ShellRoute 底部导航。

### 3.4 本地数据库

```yaml
drift
sqlite3_flutter_libs
path_provider
path
```

用途：替代 shared_preferences，保存任务、专注记录、统计数据、用户设置。

### 3.5 云同步与后端

```yaml
supabase_flutter
```

用途：

- 用户登录
- 云端 PostgreSQL 数据库
- 多设备同步
- 实时学习小组状态
- 文件存储
- Edge Functions 调 AI 接口

### 3.6 通知提醒

```yaml
flutter_local_notifications
timezone
```

用途：

- 任务截止提醒
- 番茄钟结束提醒
- 每日学习提醒
- 断签提醒

### 3.7 图表

```yaml
fl_chart
```

用途：

- 折线图
- 柱状图
- 饼图
- 雷达图

### 3.8 数据模型与代码生成

```yaml
freezed
freezed_annotation
json_annotation
json_serializable
build_runner
```

用途：不可变模型、JSON 序列化、减少手写样板代码。

---

## 4. 建议 pubspec.yaml

```yaml
name: college_study_supervisor
description: A Flutter app for college study supervision, focus tracking, and self-discipline management.
publish_to: 'none'

version: 0.2.0+2

environment:
  sdk: ^3.8.0

dependencies:
  flutter:
    sdk: flutter

  # 状态管理
  flutter_riverpod: ^3.0.0
  riverpod_annotation: ^3.0.0

  # 路由
  go_router: ^16.0.0

  # 本地存储
  drift: ^2.26.0
  sqlite3_flutter_libs: ^0.5.30
  path_provider: ^2.1.5
  path: ^1.9.1

  # 云同步，可后续接入
  supabase_flutter: ^2.8.0

  # 通知
  flutter_local_notifications: ^19.0.0
  timezone: ^0.10.0

  # 图表
  fl_chart: ^0.71.0

  # 工具
  intl: ^0.20.0
  uuid: ^4.5.1
  shared_preferences: ^2.5.0

  # 模型
  freezed_annotation: ^3.0.0
  json_annotation: ^4.9.0

  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^6.0.0
  build_runner: ^2.4.15
  riverpod_generator: ^3.0.0
  riverpod_lint: ^3.0.0
  custom_lint: ^0.8.0
  freezed: ^3.0.0
  json_serializable: ^6.9.0
  drift_dev: ^2.26.0

flutter:
  uses-material-design: true
```

版本号可以根据 `flutter pub outdated` 再微调。

---

## 5. 推荐目录结构

```text
lib/
├── main.dart
├── app.dart
├── router/
│   └── app_router.dart
├── core/
│   ├── theme/
│   │   └── app_theme.dart
│   ├── constants/
│   │   └── app_constants.dart
│   └── utils/
│       └── date_utils.dart
├── data/
│   ├── local/
│   │   ├── app_database.dart
│   │   ├── tables.dart
│   │   └── daos/
│   │       ├── task_dao.dart
│   │       ├── focus_dao.dart
│   │       └── stats_dao.dart
│   ├── remote/
│   │   └── supabase_service.dart
│   └── repositories/
│       ├── task_repository.dart
│       ├── focus_repository.dart
│       └── stats_repository.dart
├── features/
│   ├── dashboard/
│   │   ├── dashboard_page.dart
│   │   └── widgets/
│   │       ├── supervisor_card.dart
│   │       └── today_task_list.dart
│   ├── tasks/
│   │   ├── task_editor_page.dart
│   │   ├── task_list_page.dart
│   │   └── task_controller.dart
│   ├── focus/
│   │   ├── focus_page.dart
│   │   ├── focus_controller.dart
│   │   └── widgets/
│   │       └── focus_timer_ring.dart
│   ├── stats/
│   │   ├── stats_page.dart
│   │   └── widgets/
│   │       ├── weekly_focus_chart.dart
│   │       ├── course_pie_chart.dart
│   │       └── streak_heatmap.dart
│   ├── groups/
│   │   ├── group_page.dart
│   │   └── group_controller.dart
│   ├── ai_plan/
│   │   ├── ai_plan_page.dart
│   │   └── ai_plan_service.dart
│   └── settings/
│       └── settings_page.dart
└── models/
    ├── study_task.dart
    ├── focus_session.dart
    ├── study_goal.dart
    └── study_group.dart
```

---

## 6. 数据库设计

### 6.1 tasks 表

```text
tasks
├── id: text primary key
├── title: text
├── course: text
├── type: text
├── priority: int
├── points: int
├── estimated_minutes: int
├── deadline: datetime nullable
├── done: bool
├── created_at: datetime
├── completed_at: datetime nullable
└── synced: bool
```

### 6.2 focus_sessions 表

```text
focus_sessions
├── id: text primary key
├── course: text nullable
├── planned_minutes: int
├── actual_minutes: int
├── completed: bool
├── interrupted: bool
├── started_at: datetime
├── ended_at: datetime nullable
└── synced: bool
```

### 6.3 daily_stats 表

```text
daily_stats
├── date: text primary key
├── completed_tasks: int
├── total_tasks: int
├── focus_minutes: int
├── discipline_score: int
├── success: bool
└── synced: bool
```

### 6.4 groups 表

```text
study_groups
├── id: text primary key
├── name: text
├── invite_code: text
├── created_at: datetime
└── synced: bool
```

---

## 7. Supabase 云端表设计

```sql
create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  nickname text,
  avatar_url text,
  school text,
  major text,
  created_at timestamptz default now()
);

create table study_tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  title text not null,
  course text not null,
  type text not null,
  priority int default 1,
  points int default 10,
  estimated_minutes int default 25,
  deadline timestamptz,
  done boolean default false,
  completed_at timestamptz,
  created_at timestamptz default now()
);

create table focus_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  course text,
  planned_minutes int not null,
  actual_minutes int not null,
  completed boolean default false,
  interrupted boolean default false,
  started_at timestamptz default now(),
  ended_at timestamptz
);

create table study_groups (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  invite_code text unique not null,
  created_by uuid references auth.users(id),
  created_at timestamptz default now()
);

create table group_members (
  group_id uuid references study_groups(id) on delete cascade,
  user_id uuid references auth.users(id) on delete cascade,
  role text default 'member',
  joined_at timestamptz default now(),
  primary key (group_id, user_id)
);
```

---

## 8. AI 学习计划 Prompt 设计

### 输入

```json
{
  "major": "计算机科学与技术",
  "grade": "大二",
  "courses": ["操作系统", "计算机网络", "软件工程", "Flutter"],
  "unfinished_tasks": [
    {"title": "完成交换机 VLAN 实验报告", "deadline": "2026-05-02", "priority": 3},
    {"title": "复习 CPU 调度算法", "deadline": "2026-05-01", "priority": 2}
  ],
  "today_available_minutes": 180,
  "recent_focus_minutes": [40, 60, 25, 90, 0, 110, 70]
}
```

### 输出

```json
{
  "summary": "今天建议先完成高优先级实验报告，再安排操作系统复习。",
  "plan": [
    {"time": "09:00-09:45", "task": "交换机 VLAN 实验报告截图说明", "mode": "deep_focus"},
    {"time": "10:00-10:25", "task": "CPU 调度算法复习", "mode": "review"},
    {"time": "20:00-20:45", "task": "Flutter 页面改造", "mode": "coding"}
  ],
  "risk": "最近有一天专注为 0，建议设置晚间提醒避免断签。"
}
```

---

## 9. 迭代路线

### v0.2.0：工程化重构

- 拆分目录结构
- 引入 Riverpod
- 引入 go_router
- 统一 Theme
- 保留当前功能不回退

### v0.3.0：数据库版本

- shared_preferences 迁移到 Drift
- 保存任务历史
- 保存专注 Session
- 支持统计图表

### v0.4.0：学习统计增强

- 周报
- 月报
- 图表
- 课程维度分析
- 自律分趋势

### v0.5.0：通知提醒

- 截止日期提醒
- 每日打卡提醒
- 专注完成通知
- 断签提醒

### v0.6.0：云同步

- Supabase 登录
- 多端同步
- 云端备份
- Web 端登录查看数据

### v0.7.0：同学监督

- 学习小组
- 排行榜
- 组内挑战
- 点赞 / 催促

### v0.8.0：AI 学习助手

- AI 今日计划
- AI 学习周报
- AI 补救计划
- 考试倒排复习计划

---

## 10. 课程设计展示亮点

答辩时可以说：

1. **多端跨平台**：一套 Flutter 代码支持 Android、Linux、Web。
2. **现代 UI**：Material 3、响应式布局、动画过渡。
3. **工程化架构**：Riverpod + Repository + Drift 分层。
4. **数据持久化**：从 key-value 升级到关系型本地数据库。
5. **可扩展后端**：Supabase 支持认证、云数据库、实时同步。
6. **学习行为量化**：任务、专注、自律分、连续打卡形成闭环。
7. **AI 能力预留**：通过 Edge Function 接入学习计划生成。

---

## 11. 最小可交付版本建议

如果时间有限，优先实现：

- Riverpod 重构
- go_router 路由
- Drift 本地数据库
- fl_chart 统计图
- flutter_local_notifications 提醒

Supabase 和 AI 可以作为“扩展功能设计”，先在报告中写清楚架构和接口预留。

