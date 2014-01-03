/**
 * Created with JetBrains RubyMine.
 * User: wayne
 * Date: 13-12-21
 * Time: 下午10:17
 * To change this template use File | Settings | File Templates.
 */
/**
 * Cdted with JetBrains RubyMine.
 * User: wayne
 * Date: 13-12-6
 * Time: 下午3:10
 * To change this template use File | Settings | File Templates.
 */
var STUDENTDETAIL=STUDENTDETAIL || {};
(function(){
    ////////////////////////////////////////// 最终成绩
    $("body").on("click","#grade .icon.plus",function(event){
        var left= $(this)[0].getBoundingClientRect().right,top=$(this)[0].getBoundingClientRect().bottom;
        $("#grade-add").css("left",left-10+"px").css("top",top+10+"px").find("input").focus();
    }).on("click","#grade .tabular.menu a",function(){
            if(!$(this).hasClass("active")){
                $(this).addClass("active").siblings().removeClass("active");
                $("#grade .label").remove();
                //$(this).append($("<div />").addClass("floating ui label").append($("<i />")));
                //post
                var data = {
                    id : '',
                    student_id: ''
                }
                data.id = $(this).attr("sub");
                data.student_id = $("div#detail-content").attr("student");

                achievement_manager.sub_achievement(data,function(data){
                    if(data.result){
                        $("#grade table tbody").empty();
                        $("#myChart").remove();
                        var mustache_template={grade:data.object};
                        var render=Mustache.render('{{#grade}}{{#achieve}}<tr>'+
                            '{{#object}}<td>{{date}}</td>'+
                            '<td class="score">{{grade}}</td>'+
                            '<td>{{enter_school}}</td>{{/object}}'+
                            '</tr>{{/achieve}}{{/grade}}',mustache_template);
                        $("#grade table tbody").append(render);
                        var labels=[],datas=[],item;
                        for(var i=0;i<data.object.length;i++){
                            item=data.object[i].achieve.object;
                            labels.push(item.date);
                            datas.push(item.grade);
                        }
                        STUDENTDETAIL.generateCanvas(labels,datas);
                    }
                    else{
                        MessageBox_content(data.content);
                    }
                });
            }
        }).on("dblclick","#grade .score",function(){
            var text=$(this).text();
            $(this).empty().append($("<input />"));
            $("input",this).focus().val(text);
        }).on("keyup","#grade .score input",function(event){
            var target=adapt_event(event).target;
            clearNoNumZero(target);
            var e=adapt_event(event).event;
            if(e.keyCode==13){
                $(this).blur();
            }
        });

    $(window).resize(function(){
        STUDENTDETAIL.check++;
        window.setTimeout(function(){
            if(STUDENTDETAIL.check==1){
                var width=$("#my-achieve-wrap").width()-10;
                $("#grade canvas").attr("height",400).attr("width",width);
                var canvas = $('#myChart')[0];
                canvas.width=canvas.width;
                canvas.height=canvas.height;
                var data = {
                    labels : STUDENTDETAIL.labels,
                    datasets : [
                        {
                            fillColor : "rgba(151,187,205,0.5)",
                            strokeColor : "rgba(151,187,205,1)",
                            pointColor : "rgba(151,187,205,1)",
                            pointStrokeColor : "#fff",
                            data :STUDENTDETAIL.data
                        }
                    ]
                }
                var ctx = $("#myChart").get(0).getContext("2d");
                var myNewChart = new Chart(ctx);
                new Chart(ctx).Line(data,STUDENTDETAIL.option);
                STUDENTDETAIL.check--;
            }
            else{
                STUDENTDETAIL.check--;
            }
        },300);
    });

    $(document).ready(function(){
        /*var href=window.location.href.split("/");
        var new_href=href[href.length-1].split("#")[0];
        if( new_href=="achieve"){*/
            if($("#achieve_final_tabular>a").length>=1){
                $("#achieve_final_tabular>a").eq(0).click();
            }
        //}
//        	STUDENTDETAIL.generateCanvas(["2013-01-28","2013-01-29","2013-10-02"],[57,68,89]);
    });

})();
STUDENTDETAIL.errors=new Array(2);
STUDENTDETAIL.labels;
STUDENTDETAIL.data;
STUDENTDETAIL.check=0;
STUDENTDETAIL.option={
    scaleOverride : true,
    scaleSteps : 20,
    scaleStartValue :0,
    bezierCurve:false
}
function sortNumber(a, b)
{
    return b-a
}
STUDENTDETAIL.generate_option=function(){
    var c=[];
    var p=STUDENTDETAIL.data;
    c=deepCopy(p,c);
    c.sort(sortNumber);
    STUDENTDETAIL.option.scaleStepWidth=Math.ceil(c[0]/STUDENTDETAIL.option.scaleSteps);
}
STUDENTDETAIL.generateCanvas=function(labels,scores){
    STUDENTDETAIL.labels=labels;
    STUDENTDETAIL.data=scores;
    if(labels.length<=1){
        $("#myChart").remove();
    }
    else{
        if($("#myChart").length==0){
            $("#grade").append($("<canvas />").attr("id","myChart"))
        }
        var width=$("#my-achieve-wrap").width()-10;
        $("#grade canvas").attr("height",400).attr("width",width);
        var canvas = $('#myChart')[0];
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
        var ctx = $("#myChart").get(0).getContext("2d");
        var myNewChart = new Chart(ctx);
        STUDENTDETAIL.generate_option();
        new Chart(ctx).Line(data,STUDENTDETAIL.option);
    }
};
STUDENTDETAIL.editCanvas=function(index,score){
    if(arguments.length==3){
        var label=arguments[2];
        STUDENTDETAIL.labels.push(label);
    }
    STUDENTDETAIL.data[index]=score;
    if(STUDENTDETAIL.labels.length>1){
        if($("#myChart").length==0){
            var width=$("#grade").width();
            $("#grade").append($("<canvas />").attr("id","myChart").attr("height",400).attr("width",width))
        }
        var canvas = $('#myChart')[0];
        canvas.width=canvas.width;
        canvas.height=canvas.height;
        var data = {
            labels : STUDENTDETAIL.labels,
            datasets : [
                {
                    fillColor : "rgba(151,187,205,0.5)",
                    strokeColor : "rgba(151,187,205,1)",
                    pointColor : "rgba(151,187,205,1)",
                    pointStrokeColor : "#fff",
                    data :STUDENTDETAIL.data
                }
            ]
        }
        var ctx = $("#myChart").get(0).getContext("2d");
        var myNewChart = new Chart(ctx);
        STUDENTDETAIL.generate_option();
        new Chart(ctx).Line(data,STUDENTDETAIL.option);
    }

}
STUDENTDETAIL.deleteCanvas=function(index){
    STUDENTDETAIL.labels.splice(index,1);
    STUDENTDETAIL.data.splice(index,1);
    if(STUDENTDETAIL.labels.length<=1){
        $("#myChart").remove();
    }
    else{
        if($("#myChart").length==0){
            var width=$("#grade").width();
            $("#grade").append($("<canvas />").attr("id","myChart").attr("height",400).attr("width",width))
        }
        var canvas = $('#myChart')[0];
        canvas.width=canvas.width;
        canvas.height=canvas.height;
        var data = {
            labels : STUDENTDETAIL.labels,
            datasets : [{
                fillColor : "rgba(151,187,205,0.5)",
                strokeColor : "rgba(151,187,205,1)",
                pointColor : "rgba(151,187,205,1)",
                pointStrokeColor : "#fff",
                data :STUDENTDETAIL.data
            }]
        }
    }
    var ctx = $("#myChart").get(0).getContext("2d");
    var myNewChart = new Chart(ctx);
    STUDENTDETAIL.generate_option();
    new Chart(ctx).Line(data,STUDENTDETAIL.option);
}


