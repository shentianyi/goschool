/**
 * Created with JetBrains RubyMine.
 * User: wayne
 * Date: 13-12-1
 * Time: 下午8:08
 * To change this template use File | Settings | File Templates.
 */
//init
var SCHEDULE = SCHEDULE || {};
(function() {
     //lighbox中的输入
     $("body").on("keyup", "#schedule-course", function(event) {
          var e = adapt_event(event).event;
          if((e.keyCode == 32 || e.keyCode == 13) && $("#autoComplete-call").find(".active").length > 0) {
               var $this = $(this);
               $this.blur();
          }
     }).on("blur", "#schedule-course", function() {
          $("#schedule-course").attr("course_id", $("#autoComplete-call").find(".active").attr("id"));
          //post(判断是否有subclass两种情况)
          if($("#autoComplete-call").find(".active").length > 0) {
               $.get("/courses/subs", {
                    id : $("#autoComplete-call").find(".active").attr("id")
               }, function(data) {
                    if(data.result) {
                         $("#new-schedule-teachers").empty();
                         $("#schedule-sub-courses").empty();
                         if(data.content.sub_courses.length == 0) {
                              $("#schedule-sub-courses").append($("<option />").attr("id", "wzx").text("无").attr("is_base",false))
                         } else {
                              var length = data.content.sub_courses.length;
                              for(var i = 0; i < length; i++) {
                                   var item = data.content.sub_courses[i]
                                   $("#schedule-sub-courses").append($("<option />").attr("id", item.id).text(item.name).attr("is_base",item.is_base))
                              }
                         }
                         var teachers = data.content.teachers.join(",");
                         $("#new-schedule-teachers").text(teachers);
                    } else {
                         MessageBox_content(data.content);
                    }
               })
          }
     }).on("change", "#schedule-sub-courses", function() {
          var id = $("#schedule-sub-courses :selected").attr("id")
          $.get("/sub_courses/teachers", {
               id : id
          }, function(data) {
               if(data.result) {
                    $("#new-schedule-teachers").empty();
                    var teachers = data.content.join(",");
                    $("#new-schedule-teachers").text(teachers);
               } else {
                    MessageBox_content(data.content);
               }
          })
     });
     //选择机构
     $("body").on("click", "#schedule-select-institution .menu>div", function() {
          SCHEDULE.institution.choose();
     });
     //在右边删除课程
     $("body").on("click", "#search-list .search-class-schedule i", function() {
          if(confirm("是否删除课程？")) {
               var id = $(this).attr('affect');
               var validate = SCHEDULE.calendar.delete_item(id);
               if(validate) {
                    $("#search-list .search-class-schedule").find("#" + id).remove();
                    scheduler.deleteEvent(id, "static");
               }
          }
     });
     //选择颜色
     $("body").on("click", "#schedule-color li", function() {
          if(!$(this).hasClass("active")) {
               $(this).addClass("active").siblings().removeClass("active");
          }
     });
    // search by course
     //右边的搜索框回车事件
     $("body").on("keyup", "#search-courses", function(event) {
          var e = adapt_event(event).event;
          if(e.keyCode == 13 && $("#autoComplete-call .active").length > 0) {
               var id = $("#autoComplete-call .active").attr("id");
               var type = $("#autoComplete-call .active").attr("type");
              //type=Course
              SCHEDULE.serchByType(id,type);
          }
     });
     // search by teacher
     //右边的搜索框回车事件
     $("body").on("keyup", "#search-teacher", function(event) {
          var e = adapt_event(event).event;
          if(e.keyCode == 13 && $("#autoComplete-call .active").length > 0) {
               var id = $("#autoComplete-call .active").attr("id");
              SCHEDULE.serchByType(id,null);

          }
     });
     //右边的搜索框的点击事件
//     $("body").on("click", "#search-teacher+.search", function() {
//          if($("#autoComplete-call .active").length > 0) {
//               var id = $("#autoComplete-call .active").attr("id");
//               $.get("/schedules/teacher", {
//                    teacher_id : id
//               }, function(data) {
//                    if(data.result) {
//                         $("#search-list").empty();
//                         $("#search-courses").val("");
//                         if(data.content.length == 0) {
//                              $("#search-list").append($("<p />").text("尚未安排课程..."))
//                         } else {
//                              SCHEDULE.generate_search_result(data.content);
//                         }
//                    } else {
//                         MessageBox_content(data.content);
//                    }
//               })
//          }
//     });

     //发送课表
     $("body").on("click", "#send-schedule-button", function() {
          $("#send-schedule").css("left", "0").css("right", 0);
     }).on("click", "#send-schedule .icon.remove", function() {
          $("#send-schedule").css("left", "-999em").css("right", "auto");
          $("#send-schedule").find("input").val("");
          var i,
              teacherChildren=$("#total-teachers>ul").children(),
              studentChildren=$("#total-students>ul").children(),
              teacherLength=teacherChildren.length,
              studentLength=studentChildren.length;
          if(teacherLength>1){
             for(i=0;i<teacherLength-1;i++){
                 teacherChildren.eq(i).remove();
             }
          }
          if(studentLength>1){
              for(i=0;i<studentLength-1;i++){
                  studentChildren.eq(i).remove();
              }
          }
     });

     $(".schedule-sender-button").click(function() {
          // alert($(this).attr('sender'))
          var institution = $("#schedule-select-institution .menu>div.active").attr("value");
          var user_ids = null;
          var params = {
               type : $(this).attr('sender'),
               institution_id : $("#schedule-select-institution .menu>div.active").attr("value")
          };
          var send = true;
          if($(this).attr('by-condition')) {
               params.user_ids = [];
               var users = $(this).prev("ul").children();
               var length = users.length;
               if(length > 0) {
                    params.user_ids = [];
                    for( i = 0; i < length - 1; i++) {
                         var teacher_id = users.eq(i).find("div").attr("id");
                         params.user_ids.push(teacher_id);
                    }
               } else {
                    send = false;
               }
          }
          if(send)
               schedule_manager.send_email(params, function(data) {
                    if(data.result) {
                         MessageBox(data.content, 'top', 'success');
                    } else {
                         MessageBox_content(data.content);
                    }
               });
     });

     $(document).ready(function() {
          $('#schedule-select-institution').dropdown();
          $("#schedule-select-institution .item").eq(0).addClass("active");
          SCHEDULE.widget.init();
          scheduler.init('schedule-here', new Date(), "month");
          SCHEDULE.calendar.have_load.institution = $("#schedule-select-institution .item.active").attr("value");
          SCHEDULE.calendar.getData();
          $("body").on("click", ".dhx_cal_tab,.dhx_cal_prev_button,.dhx_cal_next_button", function() {
               SCHEDULE.calendar.getData();
          });
     })
})();
SCHEDULE.generate_search_result = function(content,type) {
     var course_name = content[0].text,
         teacher_name = $.trim($("#search-teacher").val()),
         i,
         length = content.length;
    if(type=="Course"){
        $("#search-list").append($("<p />").addClass("search-class-name")
            .append($("<span />").text("课程："))
            .append($("<span />").text(course_name)));
    }
    //search by teacher
    else{
        $("#search-list").append($("<p />").addClass("search-class-name")
            .append($("<span />").text("老师："))
            .append($("<span />").text(teacher_name)));
    }
     var ul = "<ul class='search-class-schedule'>";
     for( i = 0; i < length; i++) {
          var data = {};
          data.template = content[i];
          data.template.start_date = new Date(parseInt(content[i].start_date)).toWayneString().minute;
          data.template.end_date = (new Date(parseInt(content[i].end_date)).toWayneString().minute).split(" ")[1];
          data.template.teachers = type=="Course"?content[i].teachers.join(","):course_name;
          data.template.sub_courses = content[i].sub_courses.is_default == 0 ? content[i].sub_courses.text : "";
          var render = Mustache.render("{{#template}}<li id='{{id}}'>" +
              "<span>{{start_date}}-{{end_date}}</span>" +
              "<span>{{teachers}}</span>" +
              "<i class='trash icon' affect='{{id}}'></i>" +
              "<span>{{sub_courses}}</span>" +
              "</li>{{/template}}", data);
          ul += render;
     }
     ul += "</ul>";
     $("#search-list").append(ul);
};
SCHEDULE.institution.choose = function() {
     SCHEDULE.calendar.getData();
};
//2014.3.26
SCHEDULE.serchByType=function(id,type){
    if(type=="Course"){
        $.get("/schedules/courses", {
            id : id,
            type : type
        }, function(data) {
            if(data.result) {
                $("#search-list").empty();
                $("#search-teacher").val("");
                SCHEDULE.generate_search_result(data.content,type);

            } else {
                MessageBox_content(data.content);
            }
        })
    }
    //search via teacher
    else{
        $.get("/schedules/teacher", {
            teacher_id : id
        }, function(data) {
            if(data.result) {
                $("#search-list").empty();
                $("#search-courses").val("");
                SCHEDULE.generate_search_result(data.content,null);
            } else {
                MessageBox_content(data.content);
            }
        })
    }
}
