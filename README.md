# toast_tiku

**Toast题库**的**新拟态**、**Flutter**版本.
## 截屏
<table>
  <tr>
    <td>
	    <img width="200px" src="https://raw.githubusercontent.com/CustedNG/toast_tiku_neumorphic_flutter/main/screenshots/IMG_3211.PNG">
    </td>
    <td>
	    <img width="200px" src="https://raw.githubusercontent.com/CustedNG/toast_tiku_neumorphic_flutter/main/screenshots/IMG_3212.PNG">
    </td>
    <td>
	    <img width="200px" src="https://raw.githubusercontent.com/CustedNG/toast_tiku_neumorphic_flutter/main/screenshots/IMG_3213.PNG">
    </td>
    </td>
  </tr>
</table>

<table>
  <tr>
    <td>
	    <img width="200px" src="https://raw.githubusercontent.com/CustedNG/toast_tiku_neumorphic_flutter/main/screenshots/IMG_3214.PNG">
    </td>
    <td>
	    <img width="200px" src="https://raw.githubusercontent.com/CustedNG/toast_tiku_neumorphic_flutter/main/screenshots/IMG_3215.PNG">
    <td>
	    <img width="200px" src="https://raw.githubusercontent.com/CustedNG/toast_tiku_neumorphic_flutter/main/screenshots/IMG_3216.PNG">
    </td>
  </tr>
</table>

## 使用
**请使用`make.dart`进行运行、编译操作**
```shell
# Windows平台下请将命令 ./make.dart 替换为 dart make.dart

# 编译Android 64bit版本
./make.dart build android
# 编译Android 32bit版本
./make.dart build android 32
# 编译iOS 64bit版本
./make.dart build ios
```

## 提示

#### 参考链接
[Dart语言概览](https://dart.cn/samples)，[Flutter入门](https://flutterchina.club/get-started/install/)，[Flutter实践](https://book.flutterchina.club)，[PUB库](https://pub.dev)  
以上链接大部分为中文，有能力可以看官网英文原版

#### 项目结构
```shell
├── LICENSE                 # 开源证书
├── README.md               # 本README Markdown文件
├── android                 # Android平台特有代码
├── build                   # 构建缓存
├── ios                     # iOS平台代码
├── lib                     # Flutter项目中主要代码，通常在该目录内修改文件
├── macos                   # macOS平台代码
├── make.dart               # 编译脚本
├── pubspec.lock            # PUB版本锁
├── pubspec.yaml            # PUB依赖文件
├── release                 # 编译好的包
├── test                    # 测试文件
├── tiku                    # 题库资源目录
├── toast_tiku.iml          # 项目配置
└── web                     # web平台代码
```

#### 

## 里程碑
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
- [x] 使用hash作为id，储存题目历史选项

## License
`Apache License 2.0`
