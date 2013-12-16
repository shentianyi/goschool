function init_course_edit() {
     $(function() {
          $("#course-begin-date").datepicker({
               showOtherMonths : true,
               selectOtherMonths : true,
               changeMonth : true,
               changeYear : true,
               dateFormat : 'yy-mm-dd',
               onClose : function(selectedDate) {
                    $("#course-end-date").datepicker("option", "minDate", selectedDate);
               }
          });
          $("#course-end-date").datepicker({
               showOtherMonths : true,
               selectOtherMonths : true,
               changeMonth : true,
               changeYear : true,
               dateFormat : 'yy-mm-dd',
               onClose : function(selectedDate) {
                    $("#course-begin-date").datepicker("option", "maxDate", selectedDate);
               }
          });
          // $("body").on("click", ".sub-course-block-item>i", function() {
               // var msg = {
                    // result : true
               // };
               // $(this).trigger('click_remove', [msg]);
               // if(msg.result) {
                    // $(this).parent().remove();
               // }
          // });
          $("body").on("click", "#add-sub-course", function() {
               var data = {
                    counts : {
                         count : BACKCOURSE.sub_teacher.count
                    }
               };
               var render = Mustache.render(BACKCOURSE.sub_teacher.class.template, data);
               $(this).before(render);
               BACKCOURSE.sub_teacher.count++;
               $(".labelForm").each(function() {
                    var $input = $(this).find("input");
                    var max_width = parseInt($(this).css("width")) * 0.45;
                    $input.css("width", max_width).css("maxWidth", "999em").addClass('sub-course-teachers-input-complete');
               });
          });
          $("body").on("keyup", "input[name='expect_number'],input[name='lesson']", function(event) {
               var obj = adapt_event(event).target;
               integerOnly(obj)
          });
          $("body").on("click", ".sub-course-block-item>i", function() {
               var msg = {
                    result : true
               };
               $(this).trigger('click_remove', [msg]);
               if(msg.result) {
                    $(this).parent().remove();
               }
          });
          $("body").on("click", "#choose-teacher-delivery div,#choose-teacher-course-delivery div", function() {
               if(!$(this).hasClass('active') && !$(this).hasClass('or')) {
                    $(this).siblings().removeClass("teal active");
                    $(this).addClass("teal active");
                    var id = $(this).attr("for");
                    if($(this).parent().attr("name") == "class") {
                         $("#choose-teacher-delivery").nextAll().css("display", "none");
                    } else {
                         $("#choose-teacher-course-delivery").nextAll().css("display", "none");
                    }
                    $("#" + id).css("display", "block");
               }
          });
          $(".update-input").change(function() {
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

          $(".tag-input-blur").blur(function() {
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
          $("#finish-edit-course-button,#close-edit-course-icon").bind('click', function() {
               course_manager.detail($("#course-detail-info").attr('course'), function(data) {
                    $("#course-detail-content").html(data);
               });
          });

          $.each($("input[type=text]"), function() {
               if($(this).attr('placeholder')) {
                    $(this).attr('title', $(this).attr('placeholder'));
               }
          });
     });
}
