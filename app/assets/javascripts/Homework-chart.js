/**
 * Created with JetBrains RubyMine.
 * User: wayne
 * Date: 13-12-21
 * Time: 下午6:52
 * To change this template use File | Settings | File Templates.
 */
var HOMEWORKCHART=HOMEWORKCHART || {};
(function(){
    $("body").on("click","#homework-line-wrap .buttons .button",function(){
        if(!$(this).hasClass("active")){
            $(this).siblings().removeClass("active");
            $(this).addClass("active");
            //post
            $.get('/student_homeworks/scores',{id:$("#detail-content").attr('student'),sid:$(this).attr('sub-course')},function(data){
                var labels=[],scores=[],day;
                for(var i=0;i<data.length;i++){
                    day=new Date(parseInt(data[i].time)).toWayneString().day;
                    labels.push(day);
                    scores.push(parseFloat(data[i].score));
                }
                STUDENT_FRONT.line={
                    labels:labels,
                    scores:scores
                };
                HOMEWORKCHART.generateLine(STUDENT_FRONT.line.labels,STUDENT_FRONT.line.scores,"homework-line-wrap");
            });
//            STUDENT_FRONT.line={
//                labels:["2013-01-03","2013-01-04","2013-01-05"],
//                scores:[100,200,300]
//            };
//            HOMEWORKCHART.generateLine(STUDENT_FRONT.line.labels,STUDENT_FRONT.line.scores,"homework-line-wrap");
        }
    })
})()
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
        var width= arguments[2]=="small" ? $("#"+target_wrap).width()-80: $("#"+target_wrap).width()-10;
        var height= arguments[2]=="small" ? $("#"+target_wrap).width()-80: $("#"+target_wrap).height()-20;
        $("#"+target_wrap).find("canvas").attr("height",height).attr("width",width);
        var canvas = $("#"+target_wrap).find("canvas")[0];
        canvas.width=canvas.width;
        canvas.height=canvas.height;
        var data = [
            {value:scores[0],color:"rgba(151,187,205,0.5)"},
            {value:scores[1]-scores[0],color : "#F38630"}
        ]
        var ctx = $("#"+target_wrap).find("canvas").get(0).getContext("2d");
        var myNewChart = new Chart(ctx);
        new Chart(ctx).Pie(data);
        var percentage=((scores[0]/scores[1])*100).toFixed(1)+"%";
        $("#deal-on-date").text(percentage);
    }
};