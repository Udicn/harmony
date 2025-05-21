import { promptAction } from '@kit.ArkUI';
import router from '@ohos.router'; // 添加这一行
import http from '@ohos.net.http'

@Entry
//页面中带entyr代表页面是入口页面
@Component
//表示这个页面还是一个组件

  //这个UI既是一个页面也是一个组件
//这俩玩意是注解
struct Index {
  //组件结构

  //state声明状态变量
  items: Array <string>=['空气质量：','温度：','湿度：']
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#007DFF'
  @State currentIndex: number = 0
  @State selectedIndex: number = 0
  private controller: TabsController = new TabsController()

  @State fontColor1: string = '#182431'
  @State selectedFontColor1: string = '#007DFF'
  @State currentIndex1: number = 0
  @State selectedIndex1: number = 0
  private controller1: TabsController = new TabsController()

  @State message: string = '武软';
  //build：构建一个界面

  @Builder tabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(this.selectedIndex == index ? this.selectedFontColor : this.fontColor)
        .fontSize(16)
        .fontWeight(this.selectedIndex == index ? 500 : 400)
        .lineHeight(22)
        .margin({ top: 17, bottom: 7 })
      Divider()
        .strokeWidth(2)
        .color('#007DFF')
        .opacity(this.selectedIndex === index ? 1 : 0)
    }.width('100%')
  }
  @Builder tabBuilder1(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(this.selectedIndex1 == index ? this.selectedFontColor1 : this.fontColor1)
        .fontSize(16)
        .fontWeight(this.selectedIndex1 == index ? 500 : 400)
        .lineHeight(22)
        .margin({ top: 17, bottom: 7 })
      Divider()
        .strokeWidth(2)
        .color('#007DFF')
        .opacity(this.selectedIndex1 === index ? 1 : 0)
    }.width('100%')
  }
  build() {
    //纵向布局
  Column(){
    Tabs({ barPosition: BarPosition.End, index: this.currentIndex, controller: this.controller }) {
      TabContent() {
        Column() {
          Text(this.message)
            .fontSize(30)
            .fontColor('#ff7e1291')
          Button('点一下')
            .type(ButtonType.Normal)//回调函数中加入匿名函数
            .onClick(() => {
              if(this.message=='王传奇')
              {
                this.message='武软'
              }
              else
              {
                this.message='王传奇'
              }
              //promptAction.showToast提示弹窗,会消失
              promptAction.showToast({ message: `${this.message}` })

            })//'top'可空，空则上下左右皆为20
              //margin->外边距
              //pading->外边距
            .margin({ 'top': 20 })
          Button('介绍')
            .margin({ 'top': '20' })
            .onClick(() => {
              //完成页面跳转
              router.pushUrl({ 'url': 'pages/indexPage' })
            })
        }
      }
      .tabBar(this.tabBuilder(0, '首页'))

      TabContent() {
        Column(){
          Row(){
            Text('王传奇的家')
              .fontColor("#007DFF")
            Image($rawfile('dao_san_jiao.png'))
              .width(20)
              .height(20)
              .margin({left:5})
          }.margin({right:260})


          Tabs({ barPosition: BarPosition.Start, index: this.currentIndex1, controller: this.controller1 }) {
            TabContent() {
              Column(){
                Row(){
                  Text('空气质量：')
                    .margin({left:-55})
                  Image($rawfile('line.png'))
                    .width(2)
                    .height(20)
                    //.margin({left:})
                  Text('温度：')
                    .margin({left:60})
                  Image($rawfile('line.png'))
                    .width(2)
                    .height(20)
                  Text('湿度：')
                    .margin({left:60})
                }.margin({top:-295})
              }
            }
            .tabBar(this.tabBuilder1(0, '全屋'))

            TabContent() {
            }
            .tabBar(this.tabBuilder1(1, '卫生间'))

            TabContent() {
            }
            .tabBar(this.tabBuilder1(2, '客厅'))
            TabContent() {
            }
            .tabBar(this.tabBuilder1(3, '主卧'))
          }
          .vertical(false)
          .barMode(BarMode.Fixed)
          .barWidth(360)
          .barHeight(720)
          .animationDuration(400)
          .onChange((index: number) => {
            // currentIndex控制TabContent显示页签
            this.currentIndex1 = index
            this.selectedIndex1 = index
          })
          .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
            if (index === targetIndex) {
              return
            }
            // selectedIndex控制自定义TabBar内Image和Text颜色切换
            this.selectedIndex1 = targetIndex
          })

        }
        //.margin({top:10})
      }
      .tabBar(this.tabBuilder(1, '搜索'))

      TabContent() {

      }
      .tabBar(this.tabBuilder(2, '消息'))

      TabContent() {

      }
      .tabBar(this.tabBuilder(3, '我的'))
    }
    .vertical(false)
    .barMode(BarMode.Fixed)
    .barWidth(360)
    .barHeight(720)
    .animationDuration(400)
    .onChange((index: number) => {
      // currentIndex控制TabContent显示页签
      this.currentIndex = index
      this.selectedIndex = index
    })
    .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
      if (index === targetIndex) {
        return
      }
      // selectedIndex控制自定义TabBar内Image和Text颜色切换
      this.selectedIndex = targetIndex
    })
  }


  .width('100%')
  .height('100%')
  }
}