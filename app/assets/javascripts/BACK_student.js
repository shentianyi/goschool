//添加学生，里面的插件初始化
var BACKSTUDENT=BACKSTUDENT||{};
BACKSTUDENT.addItem={};
BACKSTUDENT.addItem.add=(function(){
     $("#born-date").DatePicker({
         view:"years",
         date:$("#born-date").val()
     });
    $("#graduation-date").DatePicker({
        view:"years",
        date:$("#graduation-date").val()
    });
})();
BACKSTUDENT.addItem.clear=function(){
   $("#back-index-add .radio.ui").eq(0).checkbox('enable');
   $("#back-index-add input[type='text']").val("");
   $("#back-index-add .checkbox.ui").checkbox('enable');
   var specialInput_size=$("#back-index-add .specialInput>ul").size,i;
   if(specialInput_size>1){
        for(i=0;i<specialInput_size-1;i++){
            $("#back-index-add .specialInput>ul>li").eq(i).remove();
        }
   }
   $("#back-index-add .specialInput>ul>li").eq(specialInput_size-1).find("input").val("");
}
