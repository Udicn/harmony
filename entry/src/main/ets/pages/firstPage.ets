import { promptAction } from '@kit.ArkUI';
import router from '@ohos.router';
import http from '@ohos.net.http';
import { BusinessError } from '@ohos.base';
import { hilog } from '@kit.PerformanceAnalysisKit';

interface user {
  id:number
  password :string
  username :string
}

interface date{
  data:user
  success:boolean
}

@Entry
@Component

struct FirstPage {

  @State username: string = '';
  @State password: string = '';
  async sendHttpRequest(url:String,method:String) {
    let httpRequest = http.createHttp();
    if(method=='GET')
    {
      let Url :string =`${url}`
      httpRequest.request(
        Url, // 确保这里的URL是您实际的API端点
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
              console.info(`${data.result.toString()}`);
              // 使用 ApiResponse 接口进行类型断言
              let response = JSON.parse(data.result.toString()) as date;
                // weatherData 现在是 RealtimeData 类型
                // infos 现在是 WeatherInfo 类型
              let username1:  String=response.data.username
              console.info(`${username1}`);
              hilog.error(0x0000,'WeatherTag',`${this.username}`);
              // 更新状态变量
                  if(username1 == this.username)
                  {
                    router.pushUrl({url:'pages/Index'})
                    promptAction.showToast({ message: '登录成功' })
                    //页面跳转
                  }
            } catch (e) {
              // 断言错误类型，如果需要更具体的错误处理
              const errorMessage = (e instanceof Error) ? e.message : '未知解析错误';
              //promptAction.showToast({ message: `解析数据库返回数据失败: ${errorMessage}` });
              console.error(`Failed to parse weather data: ${errorMessage}`);
            }
          } else {
            let errorMsg:string= '数据库数据请求失败';
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

  }

  build() {
    Column(){
      Text('登录')
        .width(100)
        .height(100)
        .fontSize(50)
        .fontColor('#ffffffff')
      Column(){
        Text('账号')
          .fontSize(25)
          .margin({left:-250,top:100})
        TextInput({ placeholder: '用户名', text: this.username })
          .onChange(value => this.username = value)
          .fontColor('#ff000000')
          .width(300)
        Text('密码')
          .fontSize(25)
          .margin({left:-250,top:10})
            TextInput({ placeholder: '密码', text: this.password })
              .onChange(value => this.password = value)
              .width(300)

        Button('登录')
          .margin({top:100})
          .type(ButtonType.Normal)
          .onClick(()=>{
           // http://10.33.69.119:5000/users/admin
            this.sendHttpRequest('http://10.34.75.131:5000/users/admin','GET');
            // if(this.username=='admin'&& this.password=='123456')
            // {
            //  // router.pushUrl({url:'pages/Index'})
            //   promptAction.showToast({message:'登录成功'})
            // }
            // else if (this.username!='admin') {
            //   promptAction.showToast({message:'账号或者用户名错误'})
            // }
            // else if(this.password!='123456')
            // {
            //   promptAction.showToast({message:'密码错误'})
            // }

          })
        //Button('注册')

      }


        //   .id('admin')
        //   .alignRules({
        //     top: { anchor: 'loginText', align: VerticalAlign.Bottom }, // 贴在 loginText 底部
        //     start: { anchor: 'loginText', align: HorizontalAlign.Start } // 和 loginText 左对齐
        //   })

    }
    .backgroundImage($rawfile('2.jpg'),ImageRepeat.NoRepeat)
    .backgroundImageSize(ImageSize.Cover)
    .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])
    .height('100%')
    .width('100%')
  }
}