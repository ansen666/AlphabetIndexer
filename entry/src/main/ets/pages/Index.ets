import { contact } from '@kit.ContactsKit'
import { Contact } from '../model/Contact'
import { util } from '@kit.ArkTS'


import { pinyin } from "pinyin-pro";

@Entry
@Component
struct Index {
    scroller: Scroller = new Scroller()
    private list:Contact[]=[]

    private value: string[] = ['A', 'B', 'C', 'D', 'E', 'F', 'G',
        'H', 'I', 'J', 'K', 'L', 'M', 'N',
        'O', 'P', 'Q', 'R', 'S', 'T', 'U',
        'V', 'W', 'X', 'Y', 'Z','#']

    aboutToAppear(): void {
        this.initData();
    }

    build() {
        Row() {
            List({ space: 0, initialIndex: 0,scroller:this.scroller}){
                ForEach(this.list, (item:Contact,index) => {
                    ListItem() {
                        Column(){
                            if (index==0||this.list[index-1].index != item.index){
                                Text(item.index).width('100%').fontColor('#333333').fontSize(14).backgroundColor("#EAEAEA").padding({
                                    top:5,bottom:5,left:15
                                })
                            }

                            Text(item.name)
                                .fontSize(30)
                                .padding({
                                    top:15,bottom:15,left:15
                                })
                        }.alignItems(HorizontalAlign.Start)
                    }
                }, (item:Contact) => util.generateRandomUUID(true))//key随机生成
            }.layoutWeight(1).scrollBar(BarState.Off)
            .height('100%').divider({
                color:'#E5E5E5',
                strokeWidth:0.5
            })

            AlphabetIndexer({ arrayValue: this.value, selected: 0})
                .selectedColor(0xFFFFFF) // 选中项文本颜色
                .popupColor(0xFFFAF0) // 弹出框文本颜色
                .selectedBackgroundColor(0xCCCCCC) // 选中项背景颜色
                .popupBackground(0xD2B48C) // 弹出框背景颜色
                .usingPopup(false) // 是否显示弹出框
                .selectedFont({ size: 16, weight: FontWeight.Bolder }) // 选中项字体样式
                .popupFont({ size: 30, weight: FontWeight.Bolder }) // 弹出框内容的字体样式
                .itemSize(22) // 每一项的尺寸大小
                .alignStyle(IndexerAlign.Left) //弹出框在索引条右侧弹出
                .onSelect((index: number) => {
                    console.info(this.value[index] + ' Selected!')
                    this.onSelectIndexItem(this.value[index]);
                })
        }
        .width('100%')
        .height('100%')
    }

    initData(){
        const nameList = ["白虎","白天","白痴","常羲","嫦娥",
            "二郎神","伏羲","观世音","精卫","夸父","789范德萨范德萨","女娲","哪吒",
            "盘古","青龙","如来","孙悟空","沙僧","顺风耳","太白金星","太上老君","羲和","玄武",
            "猪八戒","朱雀","祝融","Abbey","Steven","Elizabeth","しんのすけ"];

        for(let i=0;i<nameList.length;i++){
            let pinyinStr=pinyin(nameList[i], { toneType: "none" });//根据姓名获取拼音
            let index=pinyinStr.substring(0,1).toUpperCase();// 获取拼音首字母并转成大写
            if (!/^[A-Z]$/.test(index)) { // 如果不在A-Z中则默认为“#”
                index = "#";
            }
            console.log(nameList[i]+" index:"+index)
            this.list.push(new Contact(index, nameList[i]));
        }

        this.list.sort((a, b) => {
            if (a.index === b.index) {
                return a.name.localeCompare(b.name);
            }
            if (a.index === "#") {
                return 1;
            }
            if (b.index === "#") {
                return -1;
            }
            return a.index.localeCompare(b.index);
        });
    }

    onSelectIndexItem(index:string){
        for (let i=0;i<this.list.length;i++){
            console.log("名字："+this.list[i].name+" index1:"+this.list[i].index+" index2:"+index)
            if (this.list[i].index == index){
                this.scroller.scrollToIndex(i)//滚动到索引位置
                break ;
            }
        }
    }
}