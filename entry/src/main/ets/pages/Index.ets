import { promptAction } from '@kit.ArkUI';
import router from '@ohos.router';
import http from '@ohos.net.http';
import { BusinessError } from '@ohos.base';

// 为天气API响应定义接口
interface WeatherInfo {
  weather: string;
  temperature: number; // API返回的是数字，这里保持数字类型
  wind_direction: string;
  wind_power: string;
  humidity: number; // API返回的是数字
}

interface RealtimeData {
  province: string;
  city: string;
  district: string;
  adcode: number;
  update_time: string;
  infos: WeatherInfo; // 确保这里是 WeatherInfo 类型
}

interface WeatherResult {
  realtime: RealtimeData[];
}

interface ApiResponse {
  status: number;
  message: string;
  request_id: string;
  result: WeatherResult;
}

@Entry
//页面中带entyr代表页面是入口页面
@Component
//表示这个页面还是一个组件

  //这个UI既是一个页面也是一个组件
//这俩玩意是注解
struct Index {
  //组件结构
  //url1 : string="https://apis.map.qq.com/ws/geocoder/v1/?location=30.444615000000045,114.42752399999995&key=RLOBZ-MN4LH-CG7DA-WMPXK-23TW7-WPFA2&get_poi=0"

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

  // 天气相关状态变量
  @State weather: string = '未知'
  @State temperature: string = '未知'
  @State windInfo: string = '未知'
  @State humidity: string = '未知'
  @State location: string = '未知'

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

  aboutToAppear() {
    // 首次加载时获取天气数据
    this.sendHttpRequest();
    // 每10分钟（600000毫秒）发送一次GET请求
  }

  async sendHttpRequest() {
    let httpRequest = http.createHttp();
    // 请将 'https://api.example.com/data' 替换为您的实际API端点
    httpRequest.request(
      "https://apis.map.qq.com/ws/weather/v1/?key=TCUBZ-35YLT-R6HXM-LBUBN-FHILQ-TBF4X&location=30.444615000000045,114.42752399999995&type=now", // 确保这里的URL是您实际的API端点
      {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        },
        readTimeout: 60000,
        connectTimeout: 60000
      },
      (err: BusinessError | null, data: http.HttpResponse) => {
        if (!err && data.responseCode === 200) { // 使用 === 进行严格比较
          try {
            // 使用 ApiResponse 接口进行类型断言
            let response = JSON.parse(data.result as string) as ApiResponse;
            if (response.status === 0 && response.result && response.result.realtime && response.result.realtime.length > 0) {
              // weatherData 现在是 RealtimeData 类型
              let weatherData: RealtimeData = response.result.realtime[0];
              // infos 现在是 WeatherInfo 类型
              let infos: WeatherInfo = weatherData.infos;

              // 更新状态变量
              this.location = `${weatherData.province}${weatherData.city}${weatherData.district}`;
              this.weather = infos.weather;
              this.temperature = `${infos.temperature}℃`; // infos.temperature 是数字，需要转换为字符串
              this.windInfo = `${infos.wind_direction} ${infos.wind_power}`;
              this.humidity = `${infos.humidity}%`; // infos.humidity 是数字，需要转换为字符串
              promptAction.showToast({ message: '天气数据已更新' });
            } else {
              let message = '天气数据解析失败';
              // 检查 response.message 是否存在，因为此时 response 已经有了类型定义
              if (response.message && response.status !== 0) {
                message = `请求成功但处理失败: ${response.message}`;
              }
              promptAction.showToast({ message: message });
            }
          } catch (e) {
            // 断言错误类型，如果需要更具体的错误处理
            const errorMessage = (e instanceof Error) ? e.message : '未知解析错误';
            promptAction.showToast({ message: `解析天气返回数据失败: ${errorMessage}` });
            console.error(`Failed to parse weather data: ${errorMessage}`);
          }
        } else {
          let errorMsg = '天气数据请求失败';
          if (err) {
            errorMsg = `请求错误: ${err.message} (code: ${err.code})`;
            console.error(`HTTP request error: ${err.message}, code: ${err.code}`);
          } else if (data) { // 确保 data 对象存在再访问其属性
            errorMsg = `请求失败，状态码: ${data.responseCode}`;
            console.error(`HTTP request failed, status code: ${data.responseCode}`);
          }
          promptAction.showToast({ message: errorMsg });
        }
        // 确保 httpRequest.destroy() 在回调函数结束前被调用
        // 并且只在 httpRequest 实例存在时调用
        if (httpRequest) {
          httpRequest.destroy();
        }
      }
    )
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
          // 在这里可以显示天气信息，例如：

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
        .width('100%') // 确保Column填满TabContent
        .padding(10)   // 给内容一些边距
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
                  // Text('空气质量：') // 您可以在这里显示 this.items[0] 或其他相关数据
                  //   .margin({left:-55})
                  // Image($rawfile('line.png'))
                  //   .width(2)
                  //   .height(20)
                    //.margin({left:})
                  Text(`温度：${this.temperature}`) // 使用状态变量显示温度
                    .margin({left:-55})
                  Image($rawfile('line.png'))
                    .width(2)
                    .height(20)
                  Text(`湿度：${this.humidity}`) // 使用状态变量显示湿度
                    .margin({left:60})
                }.margin({top:-450}) // 这个负边距可能需要调整
                 // 可以添加更多天气信息显示
                Text(`地点: ${this.location}`).margin({top: 10})
                Text(`天气: ${this.weather}`).margin({top: 5})
                Text(`风力: ${this.windInfo}`).margin({top: 5})
                Button('刷新').onClick((event: ClickEvent) => {
                  this.sendHttpRequest();

                })
                Text('广告位收租')
                  .fontColor('#ffff0000')
                  .fontSize(15)
              }
              .width('100%')
              .height('100%')
              .justifyContent(FlexAlign.Center) // 尝试居中内容
            }
            .tabBar(this.tabBuilder1(0, '全屋'))

            TabContent() {
              // 可以在这里为“卫生间”标签页添加内容
              Text('卫生间内容区')
            }
            .tabBar(this.tabBuilder1(1, '卫生间'))

            TabContent() {
              //Image($rawfile('TV.png'))
               // .width(100)
              // 可以在这里为“客厅”标签页添加内容
              Text('客厅内容区')
            }
            .tabBar(this.tabBuilder1(2, '客厅'))
            TabContent() {
              // 可以在这里为“主卧”标签页添加内容
              Text('主卧内容区')
            }
            .tabBar(this.tabBuilder1(3, '主卧'))
          }
          .vertical(false)
          .barMode(BarMode.Fixed)
          .barWidth(360)
          .barHeight(800) // 调整高度以适应内容
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
        .width('100%') // 确保Column填满TabContent
        //.margin({top:-110})
      }
      .tabBar(this.tabBuilder(1, '搜索'))

      TabContent() {
        // 可以在这里为“消息”标签页添加内容
        Text('消息内容区')
      }
      .tabBar(this.tabBuilder(2, '消息'))

      TabContent() {
        // 可以在这里为“我的”标签页添加内容
        Text('我的内容区')
      }
      .tabBar(this.tabBuilder(3, '我的'))
    }
    .vertical(false)
    .barMode(BarMode.Fixed)
    .barWidth(360) // 通常应为 '100%' 或具体数值适应屏幕
    .barHeight(56)  // TabBar 的高度
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
    .layoutWeight(1) // 让Tabs占据剩余空间
  }
  .width('100%')
  .height('100%')
  }
}