/**
 * Created with JetBrains RubyMine.
 * User: wayne
 * Date: 13-12-6
 * Time: 下午3:10
 * To change this template use File | Settings | File Templates.
 */
var STUDENTDETAIL=STUDENTDETAIL || {};
(function(){
////////////////////////////////////////////////////////最终成绩
    //最终成就
    $("body").on("click","#achieve .icon.plus",function(){
        if($("#achieve-template").length!=1){
            $("#achieve .list").append($("<dd id='achieve-template'/>")
                .append($("<input type='text'/>")).
                append($("<i />").addClass("icon remove template-remove"))
            );
            $("#achieve-template input[type='text']").focus();
        }
    }).on("keyup","#achieve .list input[type='text']",function(event){
            var e=adapt_event(event).event;
            if(e.keyCode==13){
                var text=$("#achieve-template input[type='text']").val();
                if(text.length>0){
                    //post
                    $("#achieve .list").append($("<dd/>")
                        .text(text).
                        append($("<i />").addClass("icon remove"))
                    );
                    $("#achieve-template .template-remove").click();
                }
                else{
                    MessageBox("请填写成就内容","top","warning");
                }
            }
            else if(e.keyCode== 27){
                $("#achieve-template .template-remove").click();
            }
        }).on("click","#achieve dd i",function(){
            if($(this).hasClass("template-remove")){
                $("#achieve-template").remove();
            }
            else{
                //post
                $(this).parents("dd").eq(0).remove();
            }
        });
    //所有录取
    $("body").on("click","#offer .icon.plus",function(){
        if($("#offer-template").length!=1){
            var tr=Mustache.render("<tr id='offer-template'>"+
                "<td><input type='text'></td>"+
                "<td><input type='text'></td>"+
                "<td><input type='text' id='offer-template-time'></td>"+
                "<td><select><option value='0'>否</option><option value='1'>是</option></select></td>"+
                "<td class='offer-template-operate'><span id='offer-template-ok'>完成</span><span class='remove' id='offer-template-cancel'>删除</span></td>"+
                "</tr>",{});
            $("#offer tbody").append(tr);
            $("#offer-template input").eq(0).focus();
            $("#offer-template-time").datepicker({
                showOtherMonths: true,
                selectOtherMonths: true,
                changeMonth: true,
                changeYear: true,
                dateFormat:'yy-mm'
            });
        }
    }).on("keyup","#offer-template input",function(event){
            var e=adapt_event(event).event;
            if(e.keyCode==13){
                $("#offer-template-ok").click()
            }
            else if(e.keyCode== 27){
                $("#offer-template-cancel").click();
            }
    }).on("click","#offer-template-ok",function(){
            var school=$("#offer-template input").eq(0).val();
            var major=$("#offer-template input").eq(1).val();
            var time=$("#offer-template input").eq(2).val();
            var scholarship=$("#offer-template select :selected").text();
            var scholarship_value=$("#offer-template select :selected").attr("value");
            if(school.length>0&&major.length>0&&time.length>0){
                //post
                var data={offer:{school:school,major:major,time:time,scholarship:scholarship}};
                var tr=Mustache.render("{{#offer}}<tr>"+
                    "<td>{{school}}</td>"+
                    "<td>{{major}}</td>"+
                    "<td>{{time}}</td>"+
                    "<td>{{scholarship}}</td>"+
                    "<td><span class='remove'>删除</span></td>"+
                    "</tr>{{/offer}}",data);
                $("#offer tbody").append(tr);
                $("#offer-template-cancel").click();
            }
            else{
                MessageBox("信息填写不完整","top","warning");
            }
    }).on("click","#offer .remove",function(){
            if($(this).attr("id")=="offer-template-cancel"){
                 $("#offer-template").remove();
            }
            else{
                //post
                $(this).parents("tr").eq(0).remove()
            }
    });
    //最终成就
    $("body").on("click","#grade .icon.plus",function(event){
            var left= $(this)[0].getBoundingClientRect().right,top=$(this)[0].getBoundingClientRect().bottom;
            $("#grade-add").css("left",left-10+"px").css("top",top+10+"px").find("input").focus();
    }).on("keyup","#grade-add input",function(event){
            var e=adapt_event(event).event;
            if(e.keyCode==13){
                //post
                if($.trim($(this).val()).length>0){
                    $("#grade .tabular.menu").append($("<a />").addClass("item").text($(this).val()));
                    $(this).blur();
                }
                else{
                    MessageBox("请输入名称","top","warning");
                }
            }
            else if(e.keyCode==27){
                $(this).blur();
            }
    }).on("blur","#grade-add input",function(){
            $(this).val("");
            $("#grade-add").css("left","-999em");
    }).on("click","#grade .tabular.menu a",function(){
         if(!$(this).hasClass("active")){
            $(this).addClass("active").siblings().removeClass("active");
            $("#grade .label").remove();
            $(this).append($("<div />").addClass("floating ui label").append($("<i />").addClass("icon remove")));
            //post
         }
    }).on("click","#grade .tabular.menu a .label",function(){
         //post
         $(this).parents(".item").eq(0).remove();
         if($("#grade .tabular.menu a").length>0){
             $("#grade .tabular.menu a").eq(0).click();
         }
    }).on("click","#grade tfoot th",function(){
            if($("#grade-template").length!=1){
                var tr=Mustache.render("<tr id='grade-template'>"+
                    "<td><input type='text' id='grade-template-time'></td>"+
                    "<td><input type='text' id='grade-template-score'></td>"+
                    "<td><select><option value='0'>入校前</option><option value='1' selected>入校后</option></select></td>"+
                    "<td class='grade-template-operate'><span id='grade-template-ok'>完成</span><span class='remove' id='grade-template-cancel'>删除</span></td>"+
                    "</tr>",{});
                $("#grade tbody").append(tr);
                $("#grade-template-time").datepicker({
                    showOtherMonths: true,
                    selectOtherMonths: true,
                    changeMonth: true,
                    changeYear: true,
                    dateFormat:'yy-mm-dd'
                });
            }
    }).on("keyup","#grade-template input",function(event){
            var e=adapt_event(event).event;
            if(e.keyCode==13){
                 $("#grade-template-ok").click();
            }
            else if(e.keyCode==27){
                 $("#grade-template-cancel").click();
            }
            if($(this).attr("id")=="grade-template-score"){
                var target=adapt_event(event).target;
                clearNoNumZero(target);
            }

    }).on("click","#grade-template-ok",function(){
            var time=$("#grade-template input").eq(0).val();
            var score= $("#grade-template input").eq(1).val();
            var join_time=$("#grade-template select :selected").text();
            var join_time_value=$("#grade-template select :selected").attr("value");
            if(time.length>0&& $.trim(score).length>0){
                //post
                var data={grade:{time:time,score:score,join_time:join_time}};
                var tr=Mustache.render("{{#grade}}<tr>"+
                    "<td>{{time}}</td>"+
                    "<td class='score'>{{score}}</td>"+
                    "<td>{{join_time}}</td>"+
                    "<td><span class='remove'>删除</span></td>"+
                    "</tr>{{/grade}}",data);
                $("#grade tbody").append(tr);
                var index=$("#grade-template").prevAll().length;
                STUDENTDETAIL.editCanvas(index,parseInt(score),time);
                $("#grade-template-cancel").click();
            }
            else{
                MessageBox("信息没有填写完整")
            }
    }).on("click","#grade .remove",function(){
            if($(this).attr("id")=="grade-template-cancel"){
                 $("#grade-template").remove();
            }
            else{
                //post
                var index=$(this).parents("tr").eq(0).prevAll().length;
                $(this).parents("tr").eq(0).remove();
                STUDENTDETAIL.deleteCanvas(index);
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
    }).on("blur","#grade .score input",function(){
           if($.trim($(this).val()).length>0){
               //post
               var text=$(this).val();
               var index=$(this).parents("tr").prevAll().length;
               $(this).parent().text(text);
               $(this).remove();
               STUDENTDETAIL.editCanvas(index,parseInt(text))
           }
            else{
               MessageBox("请输入分数","top","warning");
               $(this).focus();
           }
    });
//////////////////////////////////////////////////////// 咨询记录
    $("body").on("click","#consult-record .item .icon.remove",function(){
            //post
            $(this).parent().remove();
    }).on("click","#consult-record .comment-block .button",function(){
            var value=$(this).prev().val();
            var date=new Date().toWayneString().day;
            if($.trim(value).length>0){
                $(this).prev().val("");
                $(this).parents(".comment-block").prev("dl")
                    .append($("<dd />")
                        .append($("<span />").text(value))
                        .append($("<span />").text(date))
                        .append($("<i />").addClass("icon remove"))
                    )
            }
            else{
                MessageBox("请输入内容","top","warning");
            }
    });
    $(document).ready(function(){
        STUDENTDETAIL.generateCanvas(["2013-01-28","2013-01-29","2013-10-02"],[57,68,89]);
    });
})();
STUDENTDETAIL.labels;
STUDENTDETAIL.data;
STUDENTDETAIL.option={
    bezierCurve:false
}
STUDENTDETAIL.generateCanvas=function(labels,scores){
    STUDENTDETAIL.labels=labels;
    STUDENTDETAIL.data=scores;
    if(labels.length<=1){
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
            labels : labels,
            datasets : [
                {
                    fillColor : "rgba(151,187,205,0.5)",
                    strokeColor : "rgba(151,187,205,1)",
                    pointColor : "rgba(151,187,205,1)",
                    pointStrokeColor : "#fff",
                    data :scores
                }
            ]
        }
        var ctx = $("#myChart").get(0).getContext("2d");
        var myNewChart = new Chart(ctx);
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
    }
    var ctx = $("#myChart").get(0).getContext("2d");
    var myNewChart = new Chart(ctx);
    new Chart(ctx).Line(data,STUDENTDETAIL.option);
}


