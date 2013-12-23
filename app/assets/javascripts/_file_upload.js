//init file upload page
function attach_upload() {
     var vali = true;
     var lock = false;
     var id;
     $(".task-attach-upload").fileupload({
          singleFileUploads : false,
          dataType : 'json',
          change : function(e, data) {
               vali = true;
               id = $(this).attr('id');
               $("#" + id + '-preview').show();
               var prev = $("#" + id + '-preview');
               $.each(data.files, function(index, file) {
                    if(file.size < 20000000) {
                         prev.append($("<p/>").addClass("lil-sign").addClass("vali-file").html(file.name).append($("<span/>").html("&nbsp;&nbsp;上传中....")));
                    } else {
                         vali = false;
                         $("#" + id + '-preview > .vali-file').remove();
                         prev.append($("<p/>").addClass("lil-sign").html(file.name + "&nbsp;&nbsp;" + (file.size / 1000000).toFixed(2) + "MB,超出最大值").append($("<i />").addClass('icon-remove').click(remove_block)));
                    }
               });
          },
          add : function(e, data) {
               if(vali)
                    if(data.submit != null)
                         data.submit();
          },
          success : function(data) {
               $("#" + id + '-preview > p').remove();
               var prev = $("#" + id + '-preview');
               if(data.result) {
                    for(var i = 0; i < data.object.length; i++) {
                         prev.append($("<div />").addClass("attachment-item inline-block").attr("title", data.object[i].oriName).attr("path-name", data.object[i].pathName).append($("<div />").addClass('attachment-sign').addClass("atta-" + data.object[i].type).append($("<div />").addClass("attachment-operate").attr("path-name", data.object[i].pathName).click(attachment_remove).append($("<i />").addClass("icon-remove icon-white pointer pull-left").attr("title", "删除").attr("path-name", data.object[i].pathName)))).append($("<p />").addClass("attachment-p").html(data.object[i].oriName)));
                    }
               } else {
                    alert(data.content);
               }
          }
     });
}

function attachment_remove(event) {
     var e = event ? event : (window.event ? window.event : null);
     var obj = e.srcElement || e.target;
     e.stopPropagation();
     $(".attachment-item[path-name='" + $(obj).attr("path-name") + "']").remove();
     if($("#task-attach-uploader-preview").children().length == 0) {
          $("#task-attach-uploader-preview").css("display", "none");
     }
}

function get_attach() {
     var attachs = [];
     var length = $("#task-attach-uploader-preview").children().length;
     for(var i = 0; i < length; i++) {
          attachs[i] = {};
          attachs[i].oriName = $("#task-attach-uploader-preview >div").eq(i).attr("title");
          attachs[i].pathName = $("#task-attach-uploader-preview >div").eq(i).attr("path-name")
     }
     return attachs;
}
