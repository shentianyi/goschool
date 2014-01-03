/**
 * Created by wayne on 13-12-22.
 */
(function() {
     $("#homework-post-right .attachments a").popup();
     //上传我的作业人
     $("body").on("click", "#upload-homework", function(event) {
          if($(this).attr('resub')) {
               student_homework_manager.edit($(this).attr('sh'), function(data) {
                    $("#edit-sh-div").html(data);
                    $("#upload-my-home-work").css("left", 0).css("right", 0);
               });
          } else {
               $("#upload-my-home-work").css("left", 0).css("right", 0);
          }
     });
})()
