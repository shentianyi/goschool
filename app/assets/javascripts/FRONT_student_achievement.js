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
    ////////////////////////////////////////////////////////最终成绩
    //最终成就
    $("body").on("click","#final-achieve .icon.plus",function(){
        if($("#achieve-template").length!=1){
            $("#final-achieve .list").append($("<dd id='achieve-template'/>")
                .append($("<input type='text'/>")).
                append($("<i />").addClass("icon remove template-remove"))
            );
            $("#achieve-template input[type='text']").focus();
        }
    }).on("keyup","#final-achieve .list input[type='text']",function(event){
            var e=adapt_event(event).event;
            if(e.keyCode==13){
                var text=$("#achieve-template input[type='text']").val();
                if(text.length>0){
                    //post
                    var data = {
                        id:'',
                        achievementresult:{}
                    }
                    data.id = $("#final-achieve").attr("achieve");
                    data.achievementresult.student_id = $("div#detail-content div.info").attr("student");
                    data.achievementresult.valuestring = text;
                    data.achievementresult.achievement_id = data.id;

                    achievementres_manager.create(data,function(data){
                        if(data.result){
                            var res = data.object;
                            $("#final-achieve .list").append($("<dd/>")
                                .text(res.achieve.object).
                                append($("<i />").addClass("icon remove").attr("final",res.id))
                            );
                            $("#achieve-template .template-remove").click();
                        }
                        else{
                            MessageBox_content(data.content);
                        }
                    });
                }
                else{
                    MessageBox("请填写成就内容","top","warning");
                }
            }
            else if(e.keyCode== 27){
                $("#achieve-template .template-remove").click();
            }
        }).on("click","#final-achieve dd i",function(){
            if($(this).hasClass("template-remove")){
                $("#achieve-template").remove();
            }
            else{
                //post
                var target = $(this)
                var id = target.attr("final")
                achievementres_manager.destroy(id,function(data){
                    if(data.result){
                        target.parents("dd").eq(0).remove();
                    }else{
                        MessageBox_content(data.content);
                    }
                });
                //

            }
        });
    ////////////////////////////////////////// 所有录取
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
                var data = {
                    id:'',
                    achievementresult:{}
                }
                data.id = $("#offer").attr("achieve")
                data.achievementresult.student_id = $("div#detail-content div.info").attr("student");
                data.achievementresult.valuestring = school+";"+major+";"+time+";"+scholarship;
                data.achievementresult.achievement_id = data.id;

                achievementres_manager.create(data,function(data){
                    if(data.result){
                        var res = data.object
                        var tr=Mustache.render("{{#achieve}}<tr>"+
                            "<td>{{object.school}}</td>"+
                            "<td>{{object.specialty}}</td>"+
                            "<td>{{object.date}}</td>"+
                            "<td>{{object.scholarship}}</td>"+
                            "<td><span class='remove' admit='{{id}}'>删除</span></td>"+
                            "</tr>{{/achieve}}",res);
                        $("#offer tbody").append(tr);
                        $("#offer-template-cancel").click();
                    }
                    else
                    {
                        MessageBox_content(data.content)
                    }
                });
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
                var target = $(this);
                var id = target.attr("admit");
                achievementres_manager.destroy(id,function(data){
                    if(data.result){
                        target.parents("tr").eq(0).remove()
                    }else
                    {
                        MessageBox_content(data.content)
                    }
                });
            }
        });
    ////////////////////////////////////////// 最终成就
    $("body").on("click","#grade .icon.plus",function(event){
        var left= $(this)[0].getBoundingClientRect().right,top=$(this)[0].getBoundingClientRect().bottom;
        $("#grade-add").css("left",left-10+"px").css("top",top+10+"px").find("input").focus();
    }).on("keyup","#grade-add input",function(event){
            var e=adapt_event(event).event;
            if(e.keyCode==13){
                //post
                var data = {
                    id:'',
                    name:''
                }
                var target = $(this);
                if($.trim($(this).val()).length>0){
                    data.id = $("#grade").attr("achieve");
                    data.name = $.trim($(this).val());
                    achievement_manager.create_sub(data,function(data){

                        if(data.result){
                            var res = data.object;
                            $("#grade .tabular.menu").append($("<a />").addClass("item").text(res.name).attr("sub",res.id));
                            target.blur();
                        }
                        else
                        {
                            MessageBox_content(data.content);
                        }
                    });
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
                var data = {
                    id : '',
                    student_id: ''
                }
                data.id = $(this).attr("sub");
                data.student_id = $("div#detail-content div.info").attr("student");

                achievement_manager.sub_achievement(data,function(data){
                    if(data.result){
                        $("#grade table tbody").empty();
                        $("#myChart").remove();
                        var mustache_template={grade:data.object};
                        var render=Mustache.render('{{#grade}}{{#achieve}}<tr>'+
                            '{{#object}}<td>{{date}}</td>'+
                            '<td class="score">{{grade}}</td>'+
                            '<td>{{enter_school}}</td>{{/object}}'+
                            '<td><span class="remove" grade="{{id}}">删除</span></td>'+
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
        }).on("click","#grade .tabular.menu a .label",function(event){
            //post
            var target = $(this)
            var id = target.parent().attr("sub");
            achievement_manager.destroy(id,function(data){
                if(data.result){
                    target.parents(".item").eq(0).remove();
                    if($("#grade .tabular.menu a").length>0){
                        $("#grade .tabular.menu a").eq(0).click();
                    }
                }
                else{
                    MessageBox_content(data.content)
                }
            })
            //
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
                var data = {
                    id:'',
                    achievementresult:{}
                }
                data.id = $("#grade .menu .active").attr("sub");
                data.achievementresult.student_id = $("div#detail-content div.info").attr("student");
                data.achievementresult.valuestring = time+';'+score+';'+join_time;
                data.achievementresult.achievement_id = data.id;

                achievementres_manager.create(data,function(data){
                    if(data.result){
                        var res=data.object;
                        var tr=Mustache.render("{{#achieve}}<tr>"+
                            "<td>{{object.date}}</td>"+
                            "<td class='score'>{{object.grade}}</td>"+
                            "<td>{{object.enter_school}}</td>"+
                            "<td><span grade='{{id}}'class='remove'>删除</span></td>"+
                            "</tr>{{/achieve}}",res);
                        $("#grade tbody").append(tr);
                        var index=$("#grade-template").prevAll().length;
                        STUDENTDETAIL.editCanvas(index,parseInt(score),time);
                        $("#grade-template-cancel").click();
                    }
                    else{
                        MessageBox_content(data.content);
                    }
                });
            }
            else{
                MessageBox("信息没有填写完整","top","warning")
            }
        }).on("click","#grade table .remove",function(){
            if($(this).attr("id")=="grade-template-cancel"){
                $("#grade-template").remove();
            }
            else{
                //post
                var target = $(this);
                var id = target.attr("grade");
                achievementres_manager.destroy(id,function(data){
                    if(data.result){
                        var index=target.parents("tr").eq(0).prevAll().length;
                        target.parents("tr").eq(0).remove();
                        STUDENTDETAIL.deleteCanvas(index);
                    }
                    else
                    {
                        MessageBox_content(data.content)
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
        }).on("blur","#grade .score input",function(){
            if($.trim($(this).val()).length>0){
                //post
                var $this=$(this);
                var $parent=$this.parents("tr").eq(0);
                var $tds=$parent.find("td");
                var data = {
                    id:$parent.find(".remove").attr("grade"),
                    result:{
                        valuestring:$tds.eq(0).text()+";"+$this.val()+";"+$tds.eq(2).text()
                    }
                }
                achievementres_manager.update(data.id,data,function(data){
                    if(data.result){
                        var text=$this.val();
                        var index=$this.parents("tr").prevAll().length;
                        $this.parent().text(text);
                        $this.remove();
                        STUDENTDETAIL.editCanvas(index,parseInt(text));
                    }
                    else{
                        MessageBox_content(data.content);
                    }
                });
            }
            else{
                MessageBox("请输入分数","top","warning");
                $(this).focus();
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
        var href=window.location.href.split("/");
        var new_href=href[href.length-1].split("#")[0];
        if( new_href=="achieve"){
            if($("#achieve_final_tabular>a").length>=1){
                $("#achieve_final_tabular>a").eq(0).click();
            }
        }
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
STUDENTDETAIL.add_consult_record=function(){
    //post
    var time=$("#consult-record-time").val()+" "+$("#consult-record-hour :selected").text(),
        customer=$("#consult-record-customer").val(),
        content=$("#consult-record-content").val(),
        service=$("#consult-record-service").val();

    var student_id = $("div#detail-content div.info").attr("student");
    var consultation = {};
    consultation.student_id = student_id;
    consultation.consultants = customer;
    consultation.consult_time = time;
    consultation.content = content;

    $.post("/consultations",{
        id:student_id,
        consultation:consultation
    },function(data){
        if(data.result){
            var res = data.object;
            var render=Mustache.render("{{#consultation}}<div class='item'>"+
                "<p>{{consult_time_display}}"+" "+"{{consultants}}</p>"+
                "<p>{{content}}</p>"+
                "<p>接线人:{{recorder}}</p>"+
                "<dl>"+
                "<dt>评论：</dt>"+
                "</dl>"+
                "<div class='comment-block'>"+
                "<input type='text'/>"+
                "<div class='ui button tiny'>评论</div>"+
                "</div>"+
                "</div>{{/consultation}}",res);
            $("#consult-record .content").append(render);
            $(".detail-add[type='consult-record'] .icon.remove").click();
        }else
        {
            MessageBox_content(data.content);
        }
    });
}


