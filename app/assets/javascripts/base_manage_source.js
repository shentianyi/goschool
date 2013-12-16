var stopEvent = function(e) {
     e.stopPropagation();
     e.preventDefault();
}
var manager = {
     create : function(data, callback, async) {
          if(async == null)
               async = true;
          $.ajax({
               url : '/' + this.source,
               data : data,
               type : 'POST',
               async : async,
               success : function(data) {
                    if(callback)
                         callback(data);
               }
          });
     },
     edit : function(id, callback) {
          $.get('/' + this.source + '/' + id + '/edit', function(data) {
               if(callback)
                    callback(data);
          });
     },
     update : function(id, data, callback) {
          $.ajax({
               url : '/' + this.source + '/' + id,
               data : data,
               type : 'PUT',
               dataType : 'json',
               success : function(data) {
                    if(callback)
                         callback(data);
               }
          });
     },
     destroy : function(id, callback, async) {
          if(async == null)
               async = true;
          $.ajax({
               url : '/' + this.source + '/' + id,
               type : 'DELETE',
               async : async,
               success : function(data) {
                    if(callback)
                         callback(data);
               }
          });
     }
}

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
               type : 'POST',
               async : async,
               dataType : 'json',
               success : function(data) {
                    if(callback) {
                         callback(data);
                    }
               }
          });
     },
     detail : function(id, callback, async) {
          if(async == null)
               async = true;
          $.ajax({
               url : '/courses/detail',
               data : {
                    id : id
               },
               async : async,
               success : function(data) {
                    if(callback) {
                         callback(data);
                    }
               }
          });
     }
}, manager);

var student_manager = $.extend({
     source : 'students'
}, manager);

var consultation_manager = $.extern({
    source : 'consultations'
},manager);

var sub_course_manager = $.extend({
     source : 'sub_courses'
}, manager);

var teacher_course_manager = $.extend({
     source : 'teacher_courses'
}, manager);

var schedule_manager = $.extend({
     source : 'schedules',
     send_email : function(params, callback) {
          $.post('/schedules/send_email', params, function(data) {
               if(callback)
                    callback(data);
          }, 'json');
     }
}, manager); 
