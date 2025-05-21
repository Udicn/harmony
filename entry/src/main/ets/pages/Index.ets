import { promptAction } from '@kit.ArkUI';
import router from '@ohos.router'; // 添加这一行
@Entry
//页面中带entyr代表页面是入口页面
@Component
//表示这个页面还是一个组件

  //这个UI既是一个页面也是一个组件
//这俩玩意是注解
struct Index {
  //组件结构
  //state声明状态变量

  @State message: string = '武软';
  //build：构建一个界面
  build() {
    //纵向布局
  Column(){
    Text(this.message)
      .fontSize(30)
      .fontColor('#ff7e1291')
    Button('点一下')
      .type(ButtonType.Normal)
      //回调函数中加入匿名函数
      .onClick(()=>{
        this.message='王传奇'
        //promptAction.showToast提示弹窗,会消失
        promptAction.showToast({ 'message': '武软' })
      })
      //'top'可空，空则上下左右皆为20
      //margin->外边距
      //pading->外边距
      .margin({'top':20})
    Button('主页')
      .margin({ 'top': '20' })
      .onClick(()=>{
      //完成页面跳转
        router.pushUrl({'url':'pages/indexPage'})
      })

  }


  .width('100%')
  .height('50%')
  }
}