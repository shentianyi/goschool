var course_manager = $.extend({
     source : 'courses',
     add_teacher : function(params, callback, async) {
          if(async == null)
               async = true;
          $.ajax({
               url : '/courses/add_teacher',
               data : {
                    id : params.id,
                    teacher_id : params.teacher_id
               },
               type:'POST',
               async:async,
               dataType : 'json',
               success : function(data) {
                    if(callback){
                         callback(data);
                    }
               }
          });

     }
}, manager);


var sub_course_manager = $.extend({
     source : 'sub_courses'
}, manager);

var teacher_course_manager = $.extend({
     source : 'teacher_courses'
}, manager);
