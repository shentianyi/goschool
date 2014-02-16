

function init_course_edit() {
//     $(function() {
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
//          $("body").on("click", "#add-sub-course", function() {
//               var data = {
//                    counts : {
//                         count : BACKCOURSE.sub_teacher.count
//                    }
//               };
//               var render = Mustache.render(BACKCOURSE.sub_teacher.class.template, data);
//               $(this).before(render);
//               BACKCOURSE.sub_teacher.count++;
//               $(".labelForm").each(function() {
//                    var $input = $(this).find("input");
//                    var max_width = parseInt($(this).css("width")) * 0.45;
//                    $input.css("width", max_width).css("maxWidth", "999em").addClass('sub-course-teachers-input-complete');
//               });
//          });

//          $("body").on("click", ".sub-course-block-item>i", function() {
//               var msg = {
//                    result : true
//               };
//               $(this).trigger('click_remove', [msg]);
//               if(msg.result) {
//                    $(this).parent().remove();
//               }
//          });
//          $("body").on("click", "#choose-teacher-delivery div,#choose-teacher-course-delivery div", function() {
//               if(!$(this).hasClass('active') && !$(this).hasClass('or')) {
//                    $(this).siblings().removeClass("teal active");
//                    $(this).addClass("teal active");
//                    var id = $(this).attr("for");
//                    if($(this).parent().attr("name") == "class") {
//                         $("#choose-teacher-delivery").nextAll().css("display", "none");
//                    } else {
//                         $("#choose-teacher-course-delivery").nextAll().css("display", "none");
//                    }
//                    $("#" + id).css("display", "block");
//               }
//          });


          $.each($("input[type=text]"), function() {
               if($(this).attr('placeholder')) {
                    $(this).attr('title', $(this).attr('placeholder'));
               }
          });
//     });
}
