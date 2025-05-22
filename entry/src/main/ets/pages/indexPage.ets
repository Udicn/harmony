import { promptAction } from '@kit.ArkUI';
import router from '@ohos.router'; // 添加这一行
@Entry
@Component
struct IndexPage {
  @State message: string = 'Hello World';
items: Array<string> = ['组长:科瑞','技术总监：柴飞扬','成员:王传奇','成员:邹雷','成员:吕心成','成员:王可欣','成员:董梦阳','成员:王广辉','成员:周杨飞','成员:杨世涵']
  build() {
    Column() {

      Text('组名:长得帅是我们不队')
        .fontSize(30)
        .margin({'top':'30'})
      Text('口号：对对对，我们答得的都对')
        .fontSize(30)
        .margin({ 'top': '30' })

      Image($rawfile('1.jpg'))
        .width(350)
        .height(200)
      //列表
      List({ 'space': '10' }){
        // 将 ForEach 移到 ListItem 外面，作为 List 的直接子组件
        // ForEach 会为 this.items 中的每个元素创建一个 ListItem
        ForEach(this.items, (item: string) => {
          ListItem(){ // ListItem 现在由 ForEach 生成
            // Row 是 ListItem 的唯一直接子组件
            Row(){
              Image($rawfile('wcq.jpg'))
                .width(50)
                .height(50)
                .borderRadius(10)
                .margin({'right':50})
              Text(item)
                .onClick(()=>{
                  promptAction.showToast({message:item})
                })
            }
          }
        })
      }
      .margin({'top':'10'})
      .scrollBar(BarState.Auto)
      .height(300)
      .width(300)
      //Text('组长:科瑞,技术总监：不知道，成员：王传奇，邹磊，柴飞扬，谢广坤，王可欣，张三，李四，王五，不知道')
      //$r->引用资源的意思

      Button('返回')
        .margin({ 'top': '10' })
        .width(100)
        .height(100)
        .type(ButtonType.Normal)
        .onClick(() => {
          router.pushUrl({ 'url': 'pages/Index' })
        })
    }
    .backgroundImage($rawfile('2.jpg'), ImageRepeat.NoRepeat)
    .backgroundImageSize(ImageSize.Cover)
    .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])

  }
}