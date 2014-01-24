/**
 * Cdted with JetBrains RubyMine.
 * User: wayne
 * Date: 13-12-6
 * Time: 下午3:10
 * To change this template use File | Settings | File Templates.
 */
var STUDENTDETAIL = STUDENTDETAIL || {};
var STUDENT_FRONT = STUDENT_FRONT || {};
STUDENT_FRONT.check = 0;
(function () {
    //课程及服务
    $("body").on("keyup", "#class-and-service tbody input", function (event) {
        var e = adapt_event(event).event;
        if (e.keyCode == 13) {
            //liqi xie post
            var target = $(this);
            var id = target.parent().parent().attr("id");
            var data = {
                student_course: {
                    progress: target.val()
                }
            };
            if (data.student_course.progress.length > 0) {
                student_course_manager.update(id, data, function (data) {
                    if (data.result) {
                        MessageBox("修改成功", "top", "success");
                    }
                });
            }
            else {
                MessageBox_content("请输入内容");
            }
        }
    });
    //编辑学生信息
    $("body").on("click", "#student-detail-edit", function () {
        $("#student-edit-section").css("left", "0px").css("right", "0px");
        //        post(get edit course/service template)
        student_manager.edit($("#student-detail-info").attr('student'), function (data) {
            $("#student-edit-section").html(data);
        });
    });
    //删除学生
    $("body").on("click", "#delete-student-button", function () {
        if (confirm('确定删除？')) {
            student_manager.destroy($("#student-detail-info").attr('student'), function (data) {
                if (data.result) {
                    alert("删除成功！");
                    window.location = "/students";
                } else {
                    MessageBox(data.content, "top", "warning");
                }
            });
        }
    });
    ////////////////////////////////////////////////////////最终成绩
    //最终成就
    $("body").on("click", "#final-achieve .icon.plus",function () {
        if ($("#achieve-template").length != 1) {
            $("#final-achieve .list").append($("<dd id='achieve-template'/>")
                .append($("<input type='text'/>")).
                append($("<i />").addClass("icon remove template-remove"))
            );
            $("#achieve-template input[type='text']").focus();
        }
    }).on("keyup", "#final-achieve .list input[type='text']",function (event) {
            var e = adapt_event(event).event;
            if (e.keyCode == 13) {
                var text = $("#achieve-template input[type='text']").val();
                if (text.length > 0) {
                    //post
                    var data = {
                        id: '',
                        achievementresult: {}
                    }
                    data.id = $("#final-achieve").attr("achieve");
                    data.achievementresult.student_id = $("div#detail-content div.info").attr("student");
                    data.achievementresult.valuestring = text;
                    data.achievementresult.achievement_id = data.id;
                    data.achievementresult.achievetime = new Date().toWayneString();

                    achievementres_manager.create(data, function (data) {
                        if (data.result) {
                            var res = data.object;
                            $("#final-achieve .list").append($("<dd/>")
                                .text(res.achieve.object).
                                append($("<i />").addClass("icon remove").attr("final", res.id))
                            );
                            $("#achieve-template .template-remove").click();
                        }
                        else {
                            MessageBox_content(data.content);
                        }
                    });
                }
                else {
                    MessageBox("请填写成就内容", "top", "warning");
                }
            }
            else if (e.keyCode == 27) {
                $("#achieve-template .template-remove").click();
            }
        }).on("click", "#final-achieve dd i", function () {
            if ($(this).hasClass("template-remove")) {
                $("#achieve-template").remove();
            }
            else {
                //post
                var target = $(this)
                var id = target.attr("final")
                achievementres_manager.destroy(id, function (data) {
                    if (data.result) {
                        target.parents("dd").eq(0).remove();
                    } else {
                        MessageBox_content(data.content);
                    }
                });
                //

            }
        });
    ////////////////////////////////////////// 所有录取
    $("body").on("click", "#offer .icon.plus",function () {
        if ($("#offer-template").length != 1) {
            var tr = Mustache.render("<tr id='offer-template'>" +
                "<td><input type='text'></td>" +
                "<td><input type='text'></td>" +
                "<td><input type='text' id='offer-template-time'></td>" +
                "<td><input type='text'></td>" +
                "<td><select><option value='0'>否</option><option value='1'>是</option></select></td>" +
                "<td><select><option value='0'>否</option><option value='1'>是</option></select></td>" +
                "<td><select><option value='0'>否</option><option value='1'>是</option></select></td>" +
                "<td class='offer-template-operate'><span id='offer-template-ok'>完成</span><span class='remove' id='offer-template-cancel'>删除</span></td>" +
                "</tr>", {});
            $("#offer tbody").append(tr);
            $("#offer-template input").eq(0).focus();
            $("#offer-template-time").datepicker({
                showOtherMonths: true,
                selectOtherMonths: true,
                changeMonth: true,
                changeYear: true,
                dateFormat: 'yy-mm'
            });
        }
    }).on("click", "#offer-template-ok",function () {
            var school = $.trim($("#offer-template input").eq(0).val());
            var major = $.trim($("#offer-template input").eq(1).val());
            var time = $.trim($("#offer-template input").eq(2).val());
            var score = $.trim($("#offer-template input").eq(3).val());
            var scholarship = $("#offer-template select").eq(0).find(":selected").text();
            var offer = $("#offer-template select").eq(1).find(":selected").text();
            var final_choose = $("#offer-template select").eq(2).find(":selected").text();
            var scholarship_value = $("#offer-template select").eq(0).find(":selected").attr("value");
            var offer_value = $("#offer-template select").eq(1).find(":selected").attr("value");
            var final_choose_value = $("#offer-template select").eq(2).find(":selected").attr("value");
            if (school.length > 0 && major.length > 0 && time.length > 0 && score.length>0 ) {
                //post
                var data = {
                    id: '',
                    achievementresult: {}
                }
                data.id = $("#offer").attr("achieve")
                data.achievementresult.student_id = $("div#detail-content div.info").attr("student");
                data.achievementresult.valuestring = school + ";" + major + ";"+ time + ";"+ score + ";"  + scholarship+";"+ scholarship_value+";"+offer+";"+offer_value+";"+final_choose+";"+final_choose_value;
                data.achievementresult.achievement_id = data.id;
                data.achievementresult.achievetime = time;
                achievementres_manager.create(data, function (data) {
                    if (data.result) {
                        var res = {achieve:{
                            school:school,
                            major:major,
                            time:time,
                            score:score,
                            scholarship:scholarship,
                            offer:offer,
                            final_choose:final_choose,
                            final_choose_value:final_choose_value,
                            id:data.object.achieve.id
                        }};
                        var tr = Mustache.render("{{#achieve}}<tr id='{{id}}'>" +
                            "<td>{{school}}</td>" +
                            "<td>{{major}}</td>" +
                            "<td>{{time}}</td>" +
                            "<td>{{score}}</td>" +
                            "<td value={{scholarship_value}}>{{scholarship}}</td>" +
                            "<td value={{offer_value}}>{{offer}}</td>" +
                            "<td value={{final_choose_value}} target='admitted'>{{final_choose}}</td>" +
                            "<td><span class='edit' admit='{{id}}'>编辑</span><span class='remove' admit='{{id}}'>删除</span></td>" +
                            "</tr>{{/achieve}}", res);
                        $("#offer tbody").append(tr);
                        $("#offer-template-cancel").click();
                        if(final_choose_value==1){
                            $("#offer").find("#"+res.achieve.id).addClass("final-choose");
                        }

                    }
                    else {
                        MessageBox_content(data.content)
                    }
                });
            }
            else {
                MessageBox("信息填写不完整", "top", "warning");
            }
        }).on("click", "#offer .remove", function () {
            if ($(this).attr("id") == "offer-template-cancel") {
                $("#offer-template").remove();
            }
            else {
                //post
                var target = $(this);
                var id = target.attr("admit");
                achievementres_manager.destroy(id, function (data) {
                    if (data.result) {
                        target.parents("tr").eq(0).remove()
                    } else {
                        MessageBox_content(data.content)
                    }
                });
            }
        }).on("click", "#offer .edit", function () {
            var target = $(this);
            var id = target.attr("admit"),
                count=$("#offer thead tr").children().length,
                text,
                value,
                $column_item,
                temp_datepicker_id
            var $column=$("#offer").find("#"+id).children();
            for(var i=0;i<count-1;i++){
                $column_item=$column.eq(i);
                text=$column_item.text();
                if(i<4){
                    $column_item.text("").append($("<input type='text'/>").val(text));
                    if(i==2){
                        temp_datepicker_id="datepicker-"+id;
                        $column_item.find("input").attr("id",temp_datepicker_id);
                        $("#"+temp_datepicker_id).datepicker({
                            showOtherMonths: true,
                            selectOtherMonths: true,
                            changeMonth: true,
                            changeYear: true,
                            dateFormat: 'yy-mm'
                        });
                    }
                }
                else if(i<count-1){
                   value=$column_item.attr("value");
                   $column_item.text("").append("<select><option value='0'>否</option><option value='1'>是</option></select>");
                   if(value==="0"){
                       $column_item.find("option").eq(0).prop("selected",true);
                   }
                   else{
                       $column_item.find("option").eq(1).prop("selected",true);
                   }
                }
            }
            $("#offer").find("#"+id).find(".edit").removeClass("edit").addClass("finish").text("完成");
        }).on("click","#offer .finish",function(){
            var target = $(this);
            var id = target.attr("admit");
            var $target=$("#offer").find("#"+id),
                $input=$target.find("input"),
                $select=$target.find("select");
            var school = $.trim($input.eq(0).val());
            var major = $.trim($input.eq(1).val());
            var time = $.trim($input.eq(2).val());
            var score = $.trim($input.eq(3).val());
            var scholarship = $select.eq(0).find(":selected").text();
            var offer = $select.eq(1).find(":selected").text();
            var final_choose = $select.eq(2).find(":selected").text();
            var scholarship_value = $select.eq(0).find(":selected").attr("value");
            var offer_value = $select.eq(1).find(":selected").attr("value");
            var final_choose_value = $select.eq(2).find(":selected").attr("value");
            if (school.length > 0 && major.length > 0 && time.length > 0 && score.length>0 ) {
                var result={};
                result.valuestring=school + ";" + major + ";"+ time + ";"+ score + ";"  + scholarship+";"+ scholarship_value+";"+offer+";"+offer_value+";"+final_choose+";"+final_choose_value;

                achievementres_manager.update(id,{result:result}, function (data) {
                    if (data.result) {
                        var $target_item,
                            text,
                            value;
                        for(var i=0;i<7;i++){
                                $target_item=$target.children().eq(i);
                            if(i<4){
                                text=$target_item.find("input").val();
                                $target_item.empty().text(text);
                            }
                            else{
                                text=$target_item.find(":selected").text();
                                value=$target_item.find(":selected").attr("value");
                                $target_item.empty().text(text).attr("value",value);
                            }
                        }
                        if($target.find("[target='admitted']").attr("value")==="1"){
                            $target.addClass("final-choose");
                        }
                        else{
                            $target.removeClass("final-choose");
                        }
                        $target.find(".finish").removeClass("finish").addClass("edit").text("编辑");
                    }
                    else {
                        MessageBox_content(data.content)
                    }
                });
            }
            else {
                MessageBox("信息填写不完整", "top", "warning");
            }
        }).on("keyup","#offer td input",function(event){
            var e=adapt_event(event).event;
            if (e.keyCode == 13) {
                $(this).parents("tr").eq(0).find("span").eq(0).click();
            }
            else if (e.keyCode == 27) {
                $(this).parents("tr").eq(0).find("span").eq(1).click();
            }
        });
    ////////////////////////////////////////// 最终成就
    $("body").on("click", "#grade .icon.plus",function (event) {
        var left = $(this)[0].getBoundingClientRect().right, top = $(this)[0].getBoundingClientRect().bottom;
        $("#grade-add").css("left", left - 10 + "px").css("top", top + 10 + "px").find("input").focus();
    }).on("keyup", "#grade-add input",function (event) {
            var e = adapt_event(event).event;
            if (e.keyCode == 13) {
                //post
                var data = {
                    id: '',
                    name: ''
                }
                var target = $(this);
                if ($.trim($(this).val()).length > 0) {
                    data.id = $("#grade").attr("achieve");
                    data.name = $.trim($(this).val());
                    achievement_manager.create_sub(data, function (data) {

                        if (data.result) {
                            var res = data.object;
                            $("#grade .tabular.menu").append($("<a />").addClass("item").text(res.name).attr("sub", res.id));
                            target.blur();
                        }
                        else {
                            MessageBox_content(data.content);
                        }
                    });
                }
                else {
                    MessageBox("请输入名称", "top", "warning");
                }
            }
            else if (e.keyCode == 27) {
                $(this).blur();
            }
        }).on("blur", "#grade-add input",function () {
            $(this).val("");
            $("#grade-add").css("left", "-999em");
        }).on("click", "#grade .tabular.menu a",function () {
            if (!$(this).hasClass("active")) {
                $(this).addClass("active").siblings().removeClass("active");
                $("#grade .label").remove();
                $(this).append($("<div />").addClass("floating ui label").append($("<i />").addClass("icon remove")));
                //post
                var data = {
                    id: '',
                    student_id: ''
                }
                data.id = $(this).attr("sub");
                data.student_id = $("div#detail-content div.info").attr("student");

                achievement_manager.sub_achievement(data, function (data) {
                    if (data.result) {
                        $("#grade table tbody").empty();
                        $("#myChart").remove();
                        var mustache_template = {grade: data.object};
                        var render = Mustache.render('{{#grade}}{{#achieve}}<tr>' +
                            '{{#object}}<td>{{date}}</td>' +
                            '<td class="score">{{grade}}</td>' +
                            '<td>{{enter_school}}</td>{{/object}}' +
                            '<td><span class="remove" grade="{{id}}">删除</span></td>' +
                            '</tr>{{/achieve}}{{/grade}}', mustache_template);
                        $("#grade table tbody").append(render);
                        var labels = [], datas = [], item;
                        for (var i = 0; i < data.object.length; i++) {
                            item = data.object[i].achieve.object;
                            labels.push(item.date);
                            datas.push(item.grade);
                        }
                        STUDENTDETAIL.generateCanvas(labels, datas);
                    }
                    else {
                        MessageBox_content(data.content);
                    }
                });
            }
        }).on("click", "#grade .tabular.menu a .label",function (event) {
            //post
            var target = $(this)
            var id = target.parent().attr("sub");
            achievement_manager.destroy(id, function (data) {
                if (data.result) {
                    target.parents(".item").eq(0).remove();
                    if ($("#grade .tabular.menu a").length > 0) {
                        $("#grade .tabular.menu a").eq(0).click();
                    }
                }
                else {
                    MessageBox_content(data.content)
                }
            })
            //
        }).on("click", "#grade tfoot th",function () {
            if ($("#grade-template").length != 1) {
                var tr = Mustache.render("<tr id='grade-template'>" +
                    "<td><input type='text' id='grade-template-time'></td>" +
                    "<td><input type='text' id='grade-template-score'></td>" +
                    "<td><select><option value='0'>入校前</option><option value='1' selected>入校后</option></select></td>" +
                    "<td class='grade-template-operate'><span id='grade-template-ok'>完成</span><span class='remove' id='grade-template-cancel'>删除</span></td>" +
                    "</tr>", {});
                $("#grade tbody").append(tr);
                $("#grade-template-time").datepicker({
                    showOtherMonths: true,
                    selectOtherMonths: true,
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            }
        }).on("keyup", "#grade-template input",function (event) {
            var e = adapt_event(event).event;
            if (e.keyCode == 13) {
                $("#grade-template-ok").click();
            }
            else if (e.keyCode == 27) {
                $("#grade-template-cancel").click();
            }
            if ($(this).attr("id") == "grade-template-score") {
                var target = adapt_event(event).target;
                clearNoNumZero(target);
            }
        }).on("click", "#grade-template-ok",function () {
            var time = $("#grade-template input").eq(0).val();
            var score = $("#grade-template input").eq(1).val();
            var join_time = $("#grade-template select :selected").text();
            var join_time_value = $("#grade-template select :selected").attr("value");
            if (time.length > 0 && $.trim(score).length > 0) {
                //post
                var data = {
                    id: '',
                    achievementresult: {}
                }
                data.id = $("#grade .menu .active").attr("sub");
                data.achievementresult.student_id = $("div#detail-content div.info").attr("student");
                data.achievementresult.valuestring = time + ';' + score + ';' + join_time;
                data.achievementresult.achievement_id = data.id;
                data.achievementresult.achievetime = time;

                achievementres_manager.create(data, function (data) {
                    if (data.result) {
                        var res = data.object;
                        var tr = Mustache.render("{{#achieve}}<tr>" +
                            "<td>{{object.date}}</td>" +
                            "<td class='score'>{{object.grade}}</td>" +
                            "<td>{{object.enter_school}}</td>" +
                            "<td><span grade='{{id}}'class='remove'>删除</span></td>" +
                            "</tr>{{/achieve}}", res);
                        $("#grade tbody").append(tr);
                        var index = $("#grade-template").prevAll().length;
                        STUDENTDETAIL.editCanvas(index, parseInt(score), time);
                        $("#grade-template-cancel").click();
                    }
                    else {
                        MessageBox_content(data.content);
                    }
                });
            }
            else {
                MessageBox("信息没有填写完整", "top", "warning")
            }
        }).on("click", "#grade table .remove",function () {
            if ($(this).attr("id") == "grade-template-cancel") {
                $("#grade-template").remove();
            }
            else {
                //post
                var target = $(this);
                var id = target.attr("grade");
                achievementres_manager.destroy(id, function (data) {
                    if (data.result) {
                        var index = target.parents("tr").eq(0).prevAll().length;
                        target.parents("tr").eq(0).remove();
                        STUDENTDETAIL.deleteCanvas(index);
                    }
                    else {
                        MessageBox_content(data.content)
                    }
                });

            }
        }).on("dblclick", "#grade .score",function () {
            var text = $(this).text();
            $(this).empty().append($("<input />"));
            $("input", this).focus().val(text);
        }).on("keyup", "#grade .score input",function (event) {
            var target = adapt_event(event).target;
            clearNoNumZero(target);
            var e = adapt_event(event).event;
            if (e.keyCode == 13) {
                $(this).blur();
            }
        }).on("blur", "#grade .score input", function () {
            if ($.trim($(this).val()).length > 0) {
                //post
                var $this = $(this);
                var $parent = $this.parents("tr").eq(0);
                var $tds = $parent.find("td");
                var data = {
                    id: $parent.find(".remove").attr("grade"),
                    result: {
                        valuestring: $tds.eq(0).text() + ";" + $this.val() + ";" + $tds.eq(2).text()
                    }
                }
                achievementres_manager.update(data.id, data, function (data) {
                    if (data.result) {
                        var text = $this.val();
                        var index = $this.parents("tr").prevAll().length;
                        $this.parent().text(text);
                        $this.remove();
                        STUDENTDETAIL.editCanvas(index, parseInt(text));
                    }
                    else {
                        MessageBox_content(data.content);
                    }
                });
            }
            else {
                MessageBox("请输入分数", "top", "warning");
                $(this).focus();
            }
        });
    //////////////////////////////////////////////////////// 咨询记录
    $("body").on("click", "#consult-record .item .icon.remove",function () {
        //post
        //$(this).parent().remove();
        var target = $(this)
        //

        var id = target.attr("comment");
        consultcomment_managet.destroy(id, function (data) {
            if (data.result) {
                target.parent().remove();
            }
        });
        /*
         consultation_manager.comment(data,function(data){
         if(data.result){
         target.parent().remove();
         }
         });
         */
    }).on("click", "#consult-record .comment-block .button", function () {

            var value = $(this).prev().val();
            var date = new Date().toWayneString().second;
            var data = {
                consultcomment: {
                    consultation_id: $(this).attr("id"),
                    comment: value,
                    comment_time: date
                }
            }
            var target = $(this);
            if ($.trim(value).length > 0) {
                consultcomment_managet.create(data, function (data) {
                    if (data.result) {
                        var res = data.object.consultcomment;
                        target.prev().val("");
                        target.parents(".comment-block").prev("dl")
                            .append($("<dd />")
                                .append($("<span />").text(res.comment))
                                .append($("<span />").text(res.comment_time))
                                .append($("<i />").addClass("icon remove").attr("comment", res.id))
                            )
                    }
                });
            }
            else {
                MessageBox("请输入内容", "top", "warning");
            }
        }).on("keyup","#consult-record .comment-block input",function(event){
            var e=adapt_event(event).event;
            if(e.keyCode==13){
                $(this).next().click();
            }
        }).on("click","[affect='remove-consult']",function(){

        });
    $(window).resize(function () {
        if ($("#class-performance .title").hasClass("active")) {
            STUDENT_FRONT.check++;
            window.setTimeout(function () {
                if (STUDENT_FRONT.check == 1) {
                    HOMEWORKCHART.generateLine(STUDENT_FRONT.line.labels, STUDENT_FRONT.line.scores, "homework-line-wrap");
                    HOMEWORKCHART.generatePie(STUDENT_FRONT.pie.scores, "homework-pie-wrap","small");
                    STUDENT_FRONT.check--;
                }
                else {
                    STUDENT_FRONT.check--;
                }
            }, 300);
        }
        if ($("#achieve .title").hasClass("active")) {
            STUDENTDETAIL.check++;
            window.setTimeout(function () {
                if (STUDENTDETAIL.check == 1) {
                    var width = $("#accordion").width() - 40;
                    $("#grade canvas").attr("height", 400).attr("width", width);
                    var canvas = $('#myChart')[0];
                    canvas.width = canvas.width;
                    canvas.height = canvas.height;
                    var data = {
                        labels: STUDENTDETAIL.labels,
                        datasets: [
                            {
                                fillColor: "rgba(151,187,205,0.5)",
                                strokeColor: "rgba(151,187,205,1)",
                                pointColor: "rgba(151,187,205,1)",
                                pointStrokeColor: "#fff",
                                data: STUDENTDETAIL.data
                            }
                        ]
                    }
                    var ctx = $("#myChart").get(0).getContext("2d");
                    var myNewChart = new Chart(ctx);
                    new Chart(ctx).Line(data, STUDENTDETAIL.option);
                    STUDENTDETAIL.check--;
                }
                else {
                    STUDENTDETAIL.check--;
                }
            }, 600);
        }

    });
    //添加咨询记录验证
    $('.detail-add[type="consult-record"] .form').form({
        time: {
            identifier: 'time',
            rules: [
                {
                    type: 'empty',
                    prompt: '请选择时间'
                }
            ]
        },
        customer: {
            identifier: 'customer',
            rules: [
                {
                    type: 'empty',
                    prompt: '请填写咨询人姓名'
                }
            ]
        },
        content: {
            identifier: 'content',
            rules: [
                {
                    type: 'empty',
                    prompt: '请填写咨询内容'
                }
            ]
        }
    }, {
        inline: true,
        onSuccess: function () {
            STUDENTDETAIL.add_consult_record();
        }
    });
    $("#consult-record-time").datepicker({
        showOtherMonths: true,
        selectOtherMonths: true,
        changeMonth: true,
        changeYear: true,
        dateFormat: 'yy-mm-dd',
        onOpen: function (selectedDate) {
            $("#consult-record-time").datepicker("option", "maxDate", new Date());
        }
    });
    $("body").on("click", "div[for='detail-add'][type='consult-record']",function () {
        if ($(".detail-add[type='consult-record'] select").attr("state") == "unload") {
            for (var i = 0; i <= 23; i++) {
                var hour = i < 10 ? "0" + i + ":00" : i + ":00";
                $(".detail-add[type='consult-record'] select").append($("<option />").text(hour))
            }
            $(".detail-add[type='consult-record'] select").attr("state", "loaded");
        }
    }).on("click", ".detail-add-close", function () {
            $(".detail-add select").find("option").eq(0).prop("selected", true);
            $(".detail-add .field").removeClass("error");
            $(".prompt.label").remove()
        });
    /////////////////////////////////////////////////////// 编辑学生信息
    $("body").on("change", ".update-input",function () {
        if ($(this).attr("id") == "name" && $(this).val().length == 0) {
            MessageBox("抱歉，名字不能为空", "top", "warning");
            window.setTimeout(function () {
                $("#name").focus();
            }, 100)
            STUDENTDETAIL.errors[0] = "errors";
        }
        else {
            if ($(this).attr("id") == "email" && ($(this).val().length == 0 || !easy_email_validate($(this).val()))) {
                MessageBox("抱歉，请填写正确的邮箱", "top", "warning");
                window.setTimeout(function () {
                    $("#email").focus();
                }, 100)
                STUDENTDETAIL.errors[1] = "errors";
            }
            else {
                data = {
                    student: {}
                }
                //data.id = $("#student-detail-info").attr('student');
                //if(BACKSTUDENT.check.test($(this).val(),$(this).attr('id'))){
                data['student'][$(this).attr('id')] = $(this).val();
                student_manager.update($("#student-detail-info").attr('student'), data), function () {
                    if (data.result) {
                    }
                    else {
                    }
                };
                //}
            }
        }
    }).on("click", "#close-student-detail-edit",function () {
            if (STUDENTDETAIL.errors[0] === undefined && STUDENTDETAIL.errors[1] === undefined) {
                $("#student-edit-section").css("left", "-999em").css("right", "auto");

                student_manager.detail($("#student-detail-info").attr("student"),function(data){
                    $("#student-detail").html(data);
                });
            }
            else {
                if (STUDENTDETAIL.errors[0] !== undefined && $("#name").val().length == 0) {
                    MessageBox("抱歉，名字不能为空", "top", "warning");
                    window.setTimeout(function () {
                        $("#name").focus();
                    }, 100)
                }
                else if (STUDENTDETAIL.errors[1] !== undefined && ( $("#email").val().length == 0 || !BACKSTUDENT.check.test($("#email").val(),"email"))) {
                    MessageBox("抱歉，请填写正确的邮箱", "top", "warning");
                    window.setTimeout(function () {
                        $("#email").focus();
                    }, 100)
                }
                else {
                    $("#student-edit-section").css("left", "-999em").css("right", "auto");
                    STUDENTDETAIL.errors = new Array(2);
                }
            }
        }).on("click", "#edit-student", function () {
            $("#close-student-detail-edit").click();
        });
    $("body").on("click_remove", "#referrer .delete.icon", function (event, msg) {
        var item = $(this);
        student_manager.update($("#student-detail-info").attr('student'), {student: {referrer_id: null}}, function (data) {
            msg.result = data.result;
            if (!data.result) {
                MessageBox(data.content, "top", "warning");
                stopEvent(event);
            }
        });
    });
    $("body").on("blur", ".tag-input-blur", function () {
        var data = {
            student: {
                tags:[]
            }
        };
        var tags = [];
        $.each($('.tags-items>li>div'), function () {
            tags.push($.trim($(this).text()));
        });
        data['student']['tags'] = tags;
        student_manager.update($("#student-detail-info").attr('student'), data);
    });
    $("body").on("click_add", "#autoComplete-call li", function (event, msg) {
        if (msg.id) {
            if ($("#autoComplete-call").attr("target") == "edit_referrer") {
                if ($("#edit_referrer").parent().prevAll().length == 1) {
                    msg.callback = function (data) {
                        return false;
                    }
                    MessageBox("抱歉,只能添加一个推荐人", "top", "warning");
                    $("#edit_referrer").val("");
                }
                else {
                    student_manager.update($("#student-detail-info").attr('student'), {student: {referrer_id: msg.logininfo_id}}, function (data) {
                        if (data.result) {

                        }
                        else {
                            msg.callback = function (data) {
                                return false;
                            }
                            MessageBox_content(data.content);
                        }
                    })
                }
            }
        }
    });

    $(document).ready(function () {
        var href = window.location.href.split("/");
        var new_href = href[href.length - 1].split("#")[0];
        if (new_href == "achieve") {
            if ($("#achieve_final_tabular>a").length >= 1) {
                $("#achieve_final_tabular>a").eq(0).click();
            }
        }
        else if(new_href == "class-performance"){
            $.get("/student_homeworks/submit_calculate",{id:$("#student-detail-info").attr("student")},function(data){
                STUDENT_FRONT.pie={
                    scores:data
                };
                HOMEWORKCHART.generatePie(STUDENT_FRONT.pie.scores,"homework-pie-wrap","small");
            });
            $("#homework-line-wrap .buttons .button").eq(0).click();
        }

    });

})();
STUDENTDETAIL.errors = new Array(2);
STUDENTDETAIL.labels;
STUDENTDETAIL.data;
STUDENTDETAIL.check = 0;
STUDENTDETAIL.option = {
    scaleOverride: true,
    scaleSteps: 20,
    scaleStartValue: 0,
    bezierCurve: false
}
function sortNumber(a, b) {
    return b - a
}
STUDENTDETAIL.generate_option = function () {
    var c = [];
    var p = STUDENTDETAIL.data;
    c = deepCopy(p, c);
    c.sort(sortNumber);
    STUDENTDETAIL.option.scaleStepWidth = Math.ceil(c[0] / STUDENTDETAIL.option.scaleSteps);
}
STUDENTDETAIL.generateCanvas = function (labels, scores) {
    STUDENTDETAIL.labels = labels;
    STUDENTDETAIL.data = scores;
    if (labels.length <= 1) {
        $("#myChart").remove();
    }
    else {
        if ($("#myChart").length == 0) {
            $("#grade").append($("<canvas />").attr("id", "myChart"))
        }
        var width = $("#accordion").width() - 40;
        $("#grade canvas").attr("height", 400).attr("width", width);
        var canvas = $('#myChart')[0];
        canvas.width = canvas.width;
        canvas.height = canvas.height;
        var data = {
            labels: labels,
            datasets: [
                {
                    fillColor: "rgba(151,187,205,0.5)",
                    strokeColor: "rgba(151,187,205,1)",
                    pointColor: "rgba(151,187,205,1)",
                    pointStrokeColor: "#fff",
                    data: scores
                }
            ]
        }
        var ctx = $("#myChart").get(0).getContext("2d");
        var myNewChart = new Chart(ctx);
        STUDENTDETAIL.generate_option();
        new Chart(ctx).Line(data, STUDENTDETAIL.option);
    }
};
STUDENTDETAIL.editCanvas = function (index, score) {
    if (arguments.length == 3) {
        var label = arguments[2];
        STUDENTDETAIL.labels.push(label);
    }
    STUDENTDETAIL.data[index] = score;
    if (STUDENTDETAIL.labels.length > 1) {
        if ($("#myChart").length == 0) {
            var width = $("#grade").width();
            $("#grade").append($("<canvas />").attr("id", "myChart").attr("height", 400).attr("width", width))
        }
        var canvas = $('#myChart')[0];
        canvas.width = canvas.width;
        canvas.height = canvas.height;
        var data = {
            labels: STUDENTDETAIL.labels,
            datasets: [
                {
                    fillColor: "rgba(151,187,205,0.5)",
                    strokeColor: "rgba(151,187,205,1)",
                    pointColor: "rgba(151,187,205,1)",
                    pointStrokeColor: "#fff",
                    data: STUDENTDETAIL.data
                }
            ]
        }
        var ctx = $("#myChart").get(0).getContext("2d");
        var myNewChart = new Chart(ctx);
        STUDENTDETAIL.generate_option();
        new Chart(ctx).Line(data, STUDENTDETAIL.option);
    }

}
STUDENTDETAIL.deleteCanvas = function (index) {
    STUDENTDETAIL.labels.splice(index, 1);
    STUDENTDETAIL.data.splice(index, 1);
    if (STUDENTDETAIL.labels.length <= 1) {
        $("#myChart").remove();
    }
    else {
        if ($("#myChart").length == 0) {
            var width = $("#grade").width();
            $("#grade").append($("<canvas />").attr("id", "myChart").attr("height", 400).attr("width", width))
        }
        var canvas = $('#myChart')[0];
        canvas.width = canvas.width;
        canvas.height = canvas.height;
        var data = {
            labels: STUDENTDETAIL.labels,
            datasets: [
                {
                    fillColor: "rgba(151,187,205,0.5)",
                    strokeColor: "rgba(151,187,205,1)",
                    pointColor: "rgba(151,187,205,1)",
                    pointStrokeColor: "#fff",
                    data: STUDENTDETAIL.data
                }
            ]
        }
    }
    var ctx = $("#myChart").get(0).getContext("2d");
    var myNewChart = new Chart(ctx);
    STUDENTDETAIL.generate_option();
    new Chart(ctx).Line(data, STUDENTDETAIL.option);
}
STUDENTDETAIL.add_consult_record = function () {
    //post
    var time = $("#consult-record-time").val() + " " + $("#consult-record-hour :selected").text(),
        customer = $("#consult-record-customer").val(),
        content = $("#consult-record-content").val(),
        service = $("#consult-record-service").val();

    var student_id = $("div#detail-content div.info").attr("student");
    var consultation = {};
    consultation.student_id = student_id;
    consultation.consultants = customer;
    consultation.consult_time = time;
    consultation.content = content;

    $.post("/consultations", {
        id: student_id,
        consultation: consultation
    }, function (data) {
        if (data.result) {
            var res = data.object;
            var render = Mustache.render("{{#consultation}}<div class='item'>" +
                "<p>{{consult_time_display}}" + " " + "{{consultants}}</p>" +
                "<p>{{content}}</p>" +
                "<p>接线人:{{recorder}}</p>" +
                "<dl>" +
                "<dt>评论：</dt>" +
                "</dl>" +
                "<div class='comment-block'>" +
                "<input type='text'/>" +
                "<div class='ui button tiny'>评论</div>" +
                "</div>" +
                "</div>{{/consultation}}", res);
            $("#consult-record .content").append(render);
            $(".detail-add[type='consult-record'] .icon.remove").click();
        } else {
            MessageBox_content(data.content);
        }
    });
}