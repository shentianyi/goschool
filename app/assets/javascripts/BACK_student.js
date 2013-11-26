//添加学生，里面的插件初始化
var BACKSTUDENT=BACKSTUDENT||{};
BACKSTUDENT.item_add=(function(){
     $("#born-date").DatePicker({
         view:"years",
         date:$("#born-date").val()
     });
    $("#graduation-date").DatePicker({
        view:"years",
        date:$("#graduation-date").val()
    });
})()