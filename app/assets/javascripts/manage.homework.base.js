function init_teacher_homework() {
     init_date_picker("#homework-deadline");
     bind_menu_event();
     $("#create-homework-button").click(function() {
          var homework = {};
          $.each($(".homework-input"), function() {
               homework[$(this).attr('name')] = $(this).val();
          });
          homework['teacher_course_id'] = $("#teacher-course-hidden").val();
          homework_manager.create({
               homework : homework
          }, function(data) {
               if(!data.result) {
                    MessageBox_content(data.content);
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
}

function bind_menu_event() {
     $(".homework-menu-a[pin=false]").click(function() {
          var homework_list = $(this).next('div');
          var menu_type = $(this).attr('type');
          homework_manager.list($("#teacher-course-hidden").val(), menu_type, function(data) {
               homework_list.html(data);
          });
     });
     $('body').on('click', ".homework-menu-item-a", function() {
          homework_manager.show($(this).attr('id'), function(data) {
               $("#homework-content").html(data);
          });
     });
}

function bind_sh_input_text_update_event(callback) {
     $('body').on('change', ".student-homwork-input", function() {
          var data = {
               student_homework : {}
          };
          var value = "";
          switch($(this).attr('type')) {
               case 'text':
                    value = $(this).val();
                    break;
               case 'checkbox':
                    value = $(this).attr('checked') ? true : false;
                    break;
               default:
                    value = null;
                    break;
          }
          data['student_homework'][ $(this).attr('name')] = value;
          student_homework_manager.update($(this).attr('homework'), data, function(data) {
               if(data.result) {
                    if(callback)
                         callback(data);
               } else {
                    MessageBox_content(data.content);
               }
          });
     });
}

