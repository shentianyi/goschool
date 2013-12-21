/**
 * Created with JetBrains RubyMine.
 * User: wayne
 * Date: 13-12-21
 * Time: 下午6:52
 * To change this template use File | Settings | File Templates.
 */
var HOMEWORKCHART=HOMEWORKCHART || {};
//////////////////////////////////////////////////////////////  针对直线图的一些设置
HOMEWORKCHART.generateLine=function(labels,scores,target_wrap){
    if(scores.length==0){
       return
    }
    else{
        if(scores.length==1){
            scores.unshift(0);
            labels.unshift("");
        }
        if($("#"+target_wrap).find("[name='line_chart']").length==0){
            $("#"+target_wrap).append($("<canvas />").attr("name","line_chart"))
        }
        var width=$("#"+target_wrap).width()-10;
        var height=$("#"+target_wrap).height()-40;
        $("#"+target_wrap).find("canvas").attr("height",height).attr("width",width);
        var canvas = $("#"+target_wrap).find("canvas")[0];
        canvas.width=canvas.width;
        canvas.height=canvas.height;
        var data = {
            labels : labels,
            datasets : [{
                fillColor : "rgba(151,187,205,0.5)",
                strokeColor : "rgba(151,187,205,1)",
                pointColor : "rgba(151,187,205,1)",
                pointStrokeColor : "#fff",
                data :scores
            }]
        }
        var ctx = $("#"+target_wrap).find("canvas").get(0).getContext("2d");
        var myNewChart = new Chart(ctx);
        HOMEWORKCHART.generate_line_option(scores);
        new Chart(ctx).Line(data,HOMEWORKCHART.line_option);
    }
};
HOMEWORKCHART.line_option={
    scaleOverride : true,
    scaleSteps : 8,
    scaleStartValue :0,
    bezierCurve:false
}
HOMEWORKCHART.generate_line_option=function(data){
    var c=[];
    var p=data;
    c=deepCopy(p,c);
    c.sort(sortNumber);
    HOMEWORKCHART.line_option.scaleStepWidth=Math.ceil(c[0]/HOMEWORKCHART.line_option.scaleSteps);
}
function sortNumber(a, b)
{
    return b-a
}
//////////////////////////////////////////////////////////////  针对饼状图图的一些设置
HOMEWORKCHART.generatePie=function(scores,target_wrap){
    if(scores.length==0){
        return
    }
    else{
        if($("#"+target_wrap).find("[name='pie_chart']").length==0){
            $("#"+target_wrap).append($("<canvas />").attr("name","pie_chart"))
        }
        var width=$("#"+target_wrap).width()-10;
        var height=$("#"+target_wrap).height()-20;
        $("#"+target_wrap).find("canvas").attr("height",height).attr("width",width);
        var canvas = $("#"+target_wrap).find("canvas")[0];
        canvas.width=canvas.width;
        canvas.height=canvas.height;
        var data = [
            {value:scores[0],color:"rgba(151,187,205,0.5)"},
            {value :scores[1],color : "#F38630"}
        ]
        var ctx = $("#"+target_wrap).find("canvas").get(0).getContext("2d");
        var myNewChart = new Chart(ctx);
        new Chart(ctx).Pie(data);
        var percentage=((scores[0]/(scores[0]+scores[1]))*100).toFixed(1)+"%";
        $("#deal-on-date").text(percentage);
    }
};