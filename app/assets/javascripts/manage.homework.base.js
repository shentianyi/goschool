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
}

function bind_menu_event() {
     $(".homework-menu-a").click(function() {
          var homework_list = $(this).next('div');
       var homework_type= $(this).attr('homework_type');
       var menu_type= $(this).attr('type');
          homework_manager.homeworks($("#teacher-course-hidden").val(), homework_type, menu_type, function(data) {
               homework_list.html(data);
          });
     });
}