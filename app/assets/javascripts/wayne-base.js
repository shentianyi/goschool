//保持event兼容性
function adapt_event(event) {
    var e = event ? event : window.event;
    var target = e.target ? e.target : e.srcElement;
    return {
        event: e,
        target: target
    }
}
//阻止冒泡事件
function stop_propagation(event) {
    var e = adapt_event(event);
    var event = e.event;
    if (event.stopPropagation) {
        event.stopPropagation();
    }
    else {
        event.cancelBubble = true;
    }
}
//从月份转化为季度
if(!Date.prototype.monthToQuarter){
    Date.prototype.monthToQuarter=function(){
        switch(Math.floor(this.getMonth()/3)){
            case 0:
                return 1;
            break;
            case 1:
                return 2;
                break;
            case 2:
                return 3;
                break;
            case 3:
                return 4;
                break;
        }
    }
}
//化为标准格式显示用
if(!Date.prototype.toWayneString){
    Date.prototype.toWayneString=function(){
       var second=this.getSeconds()<10?"0"+this.getSeconds():this.getSeconds();
       var minute=this.getMinutes()<10?"0"+this.getMinutes():this.getMinutes();
       var hour=this.getHours()<10?"0"+this.getHours():this.getHours();
       var day=this.getDate()<10?"0"+this.getDate():this.getDate();
       var month=this.getMonth()+1<10?"0"+(this.getMonth()+1):this.getMonth()+1;
       var year=this.getFullYear();
       return{
            second: year+"-"+month+"-"+day+" "+hour+":"+minute+":"+second,
            minute: year+"-"+month+"-"+day+" "+hour+":"+minute,
            hour:year+"-"+month+"-"+day+" "+hour+":00",
            day:year+"-"+month+"-"+day,
            week:year+"-"+month+"-"+day,
            month:year+"-"+month,
            quarter:year+"-"+month,
            year:year.toString()
       }
    }
}
//yy-mm-dd hh:ii格式解析
function standardParse(date_value){
    var date_value=(date_value.replace(/\s/g,"-").replace(/:/g,"-").replace(/T/g,"-")).split("-");
    var date_template={
        "0":'0000',
        "1":'00',
        "2":'01',
        "3":'00',
        "4":'00'
    };
    for (var i=0;i<date_value.length;i++){
        date_template[i.toString()]=date_value[i];
    }
    if(date_template["1"]!="00"){
        date_template["1"]=(parseInt(date_template["1"])-1).toString();
    }
    return {
        date:new Date(date_template["0"],date_template["1"],date_template["2"],date_template["3"],date_template["4"]),
        template:date_template
    }
}
//获取窗口可视部分的宽、高
function inner_size(){
    var width,height
    if (window.innerWidth)
        width = window.innerWidth;
    else if (document.body.clientWidth)
        width = document.body.clientWidth;
    if (window.innerHeight)
        height = window.innerHeight;
    else if (document.body.clientHeight)
        height = document.body.clientHeight;
    return {
        height:height,
        width:width
    }
}
//得到日期，登出该日期所在周的最后一天的日期以及年份
function last_date_of_week(date_value){
    var date=new Date(date_value),endDate;
    if(date.getDay() == 0) {
        endDate = new Date(date.getFullYear(), date.getMonth(), date.getDate());
    } else {
        endDate = new Date(date.getFullYear(), date.getMonth(), date.getDate() - date.getDay() + 7);
    }
    return {
        date:endDate,
        year:endDate.getFullYear()
    }
}
//得到日期，返回所在周
if(!Date.prototype.toWeekNumber){
    Date.prototype.toWeekNumber=function(){
        this.setHours(0, 0, 0);
        this.setDate(this.getDate() + 4 - (this.getDay() || 7));
        var yearStart = new Date(this.getFullYear(), 0, 1);
        var weekNo = Math.ceil(( ( (this - yearStart) / 86400000) + 1) / 7);
        return  weekNo;
    }
}
//compare time,return first and last
function compare_time(begin_time,end_time){
    var begin=standardParse(begin_time).date-standardParse(end_time).date<=0?begin_time:end_time;
    var end=standardParse(begin_time).date-standardParse(end_time).date>=0?begin_time:end_time;
    return{
        begin:begin,
        end:end
    }
}
//深度拷贝
function deepCopy(p,c){
    var c= c || {};
    for(var i in p){
        if(typeof p[i]=='object'){
            c[i] = (p[i].constructor==Array) ? [] : {};
            deepCopy(p[i],c[i])
        }
        else{
            c[i]=p[i]
        }
    }
    return c
}

//计算百分率
function TCR(a,t){
    var a=parseFloat(a);
    var t=parseFloat(t);
    var judge= (a / t) < 1 ? "low" : ((a / t) == 1 ? "middle" : "high");
    return {
        value: (a / t * 100).toFixed(1)+" %",
        judge: judge
    }
}
//Message box
function MessageBox(str,position, type) {
    $('#MessageBox').addClass(type).addClass(position).find("p").text(str);
    $('#MessageBox').slideDown("2500");
    setTimeout(function(){
        $("#MessageBox").slideUp("2500");
    },2500)
}
//loader
function loader(id){
    if(id=="body"){
        $("body").append($("<div />").attr("id","loader").addClass('ui active loader medium text').text('loading'));
    }
    else{
        $("#"+id).append($("<div />").attr("id","loader").addClass('ui active loader medium text').text('loading'));
    }
    if(arguments.length>1){
        $("#"+id).find(".loader").css("top",arguments[1]).css("right",arguments[2]).css("bottom",arguments[3]).css("left",arguments[4])
    }
}
function remove_loader(){
    $("#loader").remove();
}
//激活所有的radio和ccheckbox
$('.ui.checkbox')
    .checkbox()
;