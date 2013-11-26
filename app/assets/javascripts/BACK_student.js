//添加学生，里面的插件初始化
var BACKSTUDENT=BACKSTUDENT||{};
BACKSTUDENT.item_add=(function(){
     $("#born-date").DatePicker({
         view:"years",
         date:$("#born-date").val(),
         onChange: function(formated, dates,date,view){
             console.log(formated,dates,date,view)
//             $('#born-date').val(formated);
//             if($(".datepickerViewDays").length>0){
//                 $('#born-date').DatePickerHide();
//             }
         }

     });
})()