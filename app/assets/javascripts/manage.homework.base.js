function init_teacher_homework() {
     init_date_picker("#homework-deadline");
     init_date_picker("#homework-deadline-resubmit");
     bind_menu_event();

     $("#create-homework-button").click(function() {
          var homework = {};
          $.each($(".homework-input"), function() {
               homework[$(this).attr('name')] = $(this).val();
          });
          homework.attach = get_attach();
          homework['teacher_course_id'] = $("#teacher-course-hidden").val();
          // homework['content'] = CKEDITOR.instances['content'].getData();
          homework_manager.create({
               homework : homework
          }, function(data) {
               if(!data.result) {
                    MessageBox_content(data.content);
               } else {
                    $("#homework-post-add>.inner>.remove").click();
               }
          });
     });

     bind_sh_input_text_update_event(function(data) {
          if(data.result) {
               // 更新成功
               if(data.content) {
                    // 批改成功：即修改了分数
                    console.log('批改成功');
               }
          } else {
               // 跟新失败
               // data.content 未消息
               MessageBox_content(data.content);
          }
     });
     bind_th_input_text_update_event(function(data) {
          if(data.result) {
               $("#homework-status").text(data.content);
          } else {
               // 跟新失败
               // data.content 未消息
               MessageBox_content(data.content);
          }
     });

     // CKEDITOR.replace('content', {
     // preset : 'standard',
     // });
}

function init_student_homework() {
     bind_menu_event();
     bind_sh_submit_event();
     $('body').on('click', "#task-attach-uploader", function() {
          attach_upload();
     });
}

function bind_menu_event() {
     $(".homework-menu-a[pin=false]").click(function() {
          var homework_list = $(this).next('div');
          var menu_type = $(this).attr('type');
          homework_manager.list($("#teacher-course-hidden").val(), menu_type, $(this).attr('sid'), function(data) {
               homework_list.html(data);
          });
     });
     $('body').on('click', ".homework-menu-item-a", function() {
          homework_manager.show($(this).attr('id'), function(data) {
               $("#homework-post-right").html(data);
          });
          if(!$(this).parent().hasClass("active")) {
               $(this).parent().siblings().removeClass("active");
               $(this).addClass("active");
          }
     });
}

function bind_sh_input_text_update_event(callback) {
     $('body').on('change', ".student-homwork-input", function() {
          var data = {
               student_homework : {}
          };
          var value = get_input_value($(this));
          data['student_homework'][ $(this).attr('name')] = value;
          student_homework_manager.update($(this).attr('homework'), data, function(data) {
               if(callback)
                    callback(data);
          });
     });
}

function bind_th_input_text_update_event(callback) {
     $('body').on('change', '.teacher-homework-input', function() {
          var data = {
               homework : {}
          };
          var value = get_input_value($(this));
          data['homework'][$(this).attr('name')] = value;
          homework_manager.update($(this).attr('homework'), data, function(data) {
               if(callback)
                    callback(data);
          });
     });
}

function get_input_value(ele) {
     var value;
     switch(ele.attr('type')) {
          case 'text':
               value = ele.val();
               break;
          case 'checkbox':
               value = ele.attr('checked') ? true : false;
               break;
          default:
               value = null;
               break;
     }
     return value;
}

function bind_sh_submit_event() {
     $('body').on('click', "#student-homework-submit-button", function() {
          var submit = $(this);
          var sh = submit.attr('student-homework');
          if(sh && sh.length > 0) {
               student_homework_manager.update(sh, {
                    student_homework : {
                         homework_id : submit.attr('homework'),
                         content : $("#student-homework-content").val()
                    }
               }, function(data) {
                    if(data.result) {
                         show_homework(submit.attr('homework'), "#homework-post-right");
                    } else {
                         MessageBox_content(data.content);
                    }
               });
          } else {
               student_homework_manager.create({
                    student_homework : {
                         homework_id : submit.attr('homework'),
                         content : $("#student-homework-content").val(),
                         attach: get_attach()
                    }
               }, function(data) {
                    if(data.result) {
                         // alert('sumit success!');
                         submit.attr('student-homework', data.content);
                         show_homework(submit.attr('homework'), "#homework-post-right");
                         $("#upload-my-home-work>.inner>.remove").click();
                    } else {
                         MessageBox_content(data.content);
                    }
               });
          }
     });
}

function show_homework(id, content) {
     homework_manager.show(id, function(data) {
          $(content).html(data);
     });
}
