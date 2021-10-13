# toast_tiku

**Toast题库**的**新拟态**、**Flutter**版本.

## Usage
**请使用`make.dart`进行运行、编译操作**
`./make.dart run`，以debug模式运行
`./make.dart run release`， 以release模式运行
`./make.dart build android`，编译Android 64bit版本
`./make.dart build android 32`，编译Android 32bit版本
`./make.dart build ios`，编译iOS 64bit版本

## Milestone
- [x] 题库自动更新，根据版本id，酌情更新
- [x] 单元测试页面：每个科目、每个单元单独的、按照顺序的测试页面
- [x] 收藏功能
- [x] 题目搜索：全局题目搜索
- [x] 整合：收藏、测验、考试底部的题目跳转sheet
- [x] App更新
- [x] 科目考试页面：单个科目抽取题目，做成考试
- [x] 底部sheet，参数：显示对错、按题目类型分类
- [ ] ~~用户系统：错题库、历史记录、云同步~~
- [ ] ~~每日小测：随机从题库抽取题目~~
- [x] 考试模式：为填空题提供支持
- [ ] 整合做题界面：ti_view.dart。AppBar以下的部分，全部做进一个通用view，参数：显示对错、保存做题记录等

## License
`Apache License 2.0`
