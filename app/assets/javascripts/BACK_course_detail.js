/**
 * Created with JetBraie.
 * User: wayne
 * Dsfd 13-12-4
 * Time: n12:36
 * To change this template use File | Settings | File Templates.
 */
var DETAIL=DETAIL || {};
DETAIL.course={};
(function(){
    $(".ui.checkbox[name='join'],.ui.checkbox[name='choose']").checkbox({
        onChange:function(){
            $(this).parents("tr").eq(0).toggleClass("positive");
        }
    });
    $(".ui.checkbox[name='join-pay']").checkbox({
        onChange:function(){
            var $this=$(this);
            $(this).parent().parent().toggleClass("positive");
            //post
            var id=$(this).parents("tr").eq(0).attr("id");
            var paid=$(this).parent().parent().hasClass("positive");
            $.ajax({
                url:"/student_courses/"+id,
                data:{student_course:{paid:paid}},
                type:'PUT',
                success:function(data){
                    if(data.result){
                        MessageBox("操作成功","top","success");
                    }
                    else{
                        $this.checkbox('toggle');
                        MessageBox_content(data.content);
                    }
                }
            })
        }
    });
    $("body").on("click","#course-detail-edit",function(){
        $("#teacher").children().removeClass("active");
        $(".back-index-add[name='course']").css("left","0px").css("right","0px");
        //post(get edit course/service template)
        course_manager.edit($("#course-detail-info").attr('course'), function(data) {
			$("#course-edit-section").html(data);
		});
    });
    $("body").on("click","#delete-course-button",function(){
         if(confirm('确定删除？')){
              course_manager.destroy($("#course-detail-info").attr('course'),function(data){
                   if(data.result){
                        alert('删除成功');
                         window.location="/courses";
                        }else{
                          MessageBox(data.content,"top","warning");
                   }
              });
         }
    });
    $("body").on("click",".out-class",function(){
          if(confirm("确认为该学生退班吗？")){
              var id=$(this).attr("affect");
              //post
              $.ajax({
                  url:"/student_courses/"+id,
                  type:'DELETE',
                  success:function(data){
                      if(data.result){
                          $("#student").find("#"+id).remove();
                          var number=parseInt($("#actual-student").text())-1;
                          $("#actual-student").text(number);
                      }
                      else{
                          MessageBox_content(data.content);
                      }
                  }
              })

          }
    });
    //为学生报班
    $("body").on("keyup","#join-for-student",function(event){
        var e=adapt_event(event).event;
        if(e.keyCode==13){
             $("#join-student").click();
        }
    })
    $("body").on("click","#join-student",function(){
        if($("#autoComplete-call").find(".active").length>0){
            var id=$("#autoComplete-call").find(".active").attr("id");
            var course_id=$("#course-detail-info").attr('course');
            $.post("/student_courses",{student_course:{student_id:id,course_id:course_id}},function(data){
                if(data.result){
                    var object_item={};
                    object_item.id=data.content;
                    object_item.name= $.trim($("#join-for-student").val());
                    object_item.img=Math.floor(Math.random()*9)+".jpg";
                    object_item.time=new Date().toWayneString().day;
                    var data={student:object_item};
                    var render=Mustache.render(DETAIL.course.student.template,data);
                    $("#student tbody").append(render);
                    $(".ui.checkbox[name='join-pay']").checkbox({
                        onChange:function(){
                            var $this=$(this);
                            $(this).parent().parent().toggleClass("positive");
                            //post
                            var id=$(this).parents("tr").eq(0).attr("id");
                            var paid=$(this).parent().parent().hasClass("positive");
                            $.ajax({
                                url:"/student_courses/"+id,
                                data:{student_course:{paid:paid}},
                                type:'PUT',
                                success:function(data){
                                    if(data.result){
                                        MessageBox("操作成功","top","success");
                                    }
                                    else{
                                        $this.checkbox('toggle');
                                        MessageBox_content(data.content);
                                    }
                                }
                            })
                        }
                    });
                    var number=parseInt($("#actual-student").text())+1;
                    $("#actual-student").text(number);
                    MessageBox(object_item.name+"报班成功","top","success");
                }
                else{
                    MessageBox_content(data.content);
                }
            });
        }
        else{
            MessageBox("您输入的学生不存在","top","warning");
        }
    });

    $("body").on("click",".out-teacher",function(){
        if(confirm("确认删除该老师吗？")){
            var id=$(this).attr("affect");
            //post
            $("#teacher").find("#"+id).remove();
        }
    })
        .on("click",".detail-add .ok",function(){
        var name=$(this).attr("for"),object=[];
        if(name=="student"){
            //post
            $(".table-wrap:visible tbody tr.positive").each(function(){
                var object_item={};
                object_item.id=$(this).attr("id");
                object_item.name=$("td:nth-of-type(1)",this).text();
                object_item.checked=$("td:nth-of-type(2)",this).find("input[type='checkbox']").prop("checked");
                object_item.img=Math.floor(Math.random()*9)+".jpg";
                object_item.time=new Date().toWayneString().day;
                object.push(object_item);
            });
            var data={student:object};
            var render=Mustache.render(DETAIL.course.student.template,data);
            $("#student tbody").append(render);
            $(".detail-add-close:visible").click();
            $(".ui.checkbox[name='join-pay']").checkbox({
                onChange:function(){
                    $(this).parent().parent().toggleClass("positive");
                }
            });
        }
        else if(name=='teacher'){
            //post
            $(".table-wrap:visible tbody tr.positive").each(function(){
                var object_item={};
                object_item.id=$(this).attr("id");
                object_item.name=$("td:nth-of-type(1)",this).text();
                object_item.class=$("td:nth-of-type(2)",this).find("input[type='text']").val();
                object.push(object_item);
            });
            var data={teacher:object};
            var render=Mustache.render(DETAIL.course.teacher.template,data);
            $("#teacher tbody").append(render);
            $(".detail-add-close:visible").click();
        }
    })
        .on("click",".join-class",function(){
            //post
            var $target=$(this).parents("tr").eq(0);
            var object={};
            object.id=$target.attr("id");
            object.name=$target.find(".name").text();
            object.checked=false;
            object.time=new Date().toWayneString().day;
            var src=$target.find("img").attr("src").split("/");
            object.img=src[src.length-1];
            var data={student:object};
            var render=Mustache.render(DETAIL.course.student.template,data);
            $("#student tbody").append(render);
            $(".ui.checkbox[name='join-pay']").checkbox({
                onChange:function(){
                    $(this).parent().parent().toggleClass("positive");
                }
            });
            MessageBox(object.name+" 报班成功","top","success");
            $target.remove();
    });
    //课程编辑
    $("body").on("change",".update-input",function() {
        var data = {
            course : {}
        };
        data['course'][$(this).attr('name')] = $(this).val();
        course_manager.update($("#course-detail-info").attr('course'), data);
    });
    $("body").on("change", ".sub-course-name-input", function() {
        var id = $(this).parent().nextAll("i").attr("id");
        var sub = $(this).parent().parent();
        var i = $(this).parent().nextAll("i");
        if(id == null) {
            sub_course_manager.create({
                course_id : $("#course-detail-info").attr('course'),
                sub_course : {
                    name : $(this).val()
                }
            }, function(data) {
                if(data.result) {
                    i.attr("id", data.content);
                    sub.attr('sub-course', data.content);
                    sub.find('.sub-course-teachers-input-complete').removeAttr('disabled');
                } else {
                    MessageBox(data.content, "top", "warning");
                }
            });
        } else {
            sub_course_manager.update(id, {
                sub_course : {
                    name : $(this).val()
                }
            }, function(data) {
                if(!data.result) {
                    MessageBox(data.content, "top", "warning");
                }
            });
        }
    });
    $("body").on("blur",".tag-input-blur",function() {
        var data = {
            course : {}
        };
        var tags = [];
        $.each($('.tags-items>li>div'), function() {
            tags.push($.trim($(this).text()));
        });
        data['course']['tags'] = tags;
        console.log(data);
        course_manager.update($("#course-detail-info").attr('course'), data);
    });
    $("body").on("click_add", "#autoComplete-call li", function(event, msg) {
        if(msg.id) {
            var callback = function(data) {
                msg.result = data.result;
                if(data.result) {
                    msg.callback = function(label) {
                        label.data.id = data.content;
                    }
                } else {
                    MessageBox(data.content, "top", "warning");
                    stopEvent(event);
                }
            }
            if($(".ui.mini.button.teal.active").attr('for') == 'total-course-teachers') {
                var params = {
                    id : $("#course-detail-info").attr('course'),
                    teacher_id : msg.id
                };
                course_manager.add_teacher(params, callback, false);
            } else {
                var params = {
                    teacher_course : {
                        sub_course_id : $("#selected-sub-course").val(),
                        user_id : msg.id
                    }
                };
                if(params.teacher_course.sub_course_id != "")
                    teacher_course_manager.create(params, callback, false);
            }
        }
    });

    $("body").on("click_remove", ".teachers .delete.icon", function(event, msg) {
        var item = $(this);
        teacher_course_manager.destroy(item.parent().attr('id'), function(data) {
            msg.result = data.result;
            if(data.result) {
                item.parents("li").eq(0).remove();
            } else {
                MessageBox(data.content, "top", "warning");
                stopEvent(event);
            }
        }, false);
    });
    $("body").on('focus', ".sub-course-teachers-input-complete", function() {
        $("#selected-sub-course").val($(this).parents(".sub-course-block-item").attr('sub-course'));
    });

    $("body").on("click_remove", ".icon.collapse", function(event, msg) {
        var item = $(this);
        if(item.attr('id') != null)
            if(confirm('确认删除子课程？')) {
                sub_course_manager.destroy(item.attr('id'), function(data) {
                    msg.result = data.result;
                    if(!data.result) {
                        MessageBox(data.content, "top", "warning");
                        stopEvent(event);
                    }
                }, false);
            } else {
                msg.result = false;
            }
    });
    $("body").on('click',"#finish-edit-course-button,#close-edit-course-icon", function() {
        course_manager.detail($("#course-detail-info").attr('course'), function(data) {
            $("#course-detail-content").html(data);
            $("#course-edit-section").css("left","-999em").css("right","auto");
        });
    });

    $(document).ready(function(){
        $("#add-class-choose-institution,#add-service-choose-institution").dropdown();
        $("#add-class-choose-institution .item").eq(0).addClass("active");
        $("#add-service-choose-institution .item").eq(0).addClass("active");

    });
})();
DETAIL.course.student={};
DETAIL.course.teacher={};
//<img class="ui avatar image" src="/assets/portrait/{{img}}"/>\
DETAIL.course.student.template='\
    {{#student}}<tr id="{{id}}">\
        <td>\
        <img class="ui avatar image" src="/assets/portrait/{{img}}"/>\
        </td>\
        <td>{{name}}</td>\
        <td>{{time}}</td>\
        <td ><div class="ui checkbox" name="join-pay">\
            <input type="checkbox">\
            <label>已经支付</label>\
        </div></td>\
        <td>\
            <div class="red button ui mini out-class" affect="{{id}}">退班</div>\
        </td>\
    </tr>{{/student}}';
DETAIL.course.teacher.template='\
    {{#teacher}}<tr id="{{id}}">\
        <td>{{name}}</td>\
        <td>{{class}}</td>\
        <td>\
            <div class="red button ui mini out-teacher" affect="{{id}}">删除</div>\
        </td>\
    </tr>{{/teacher}}';