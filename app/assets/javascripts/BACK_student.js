//添加学生，里面的插件初始化
var BACKSTUDENT=BACKSTUDENT||{};
//student init
(function(){
    $("#born-date,#graduation-date").datepicker({
        showOtherMonths: true,
        selectOtherMonths: true,
        changeMonth: true,
        changeYear: true,
        showMonthAfterYear:true,
        yearRange: "-30:+10",
        dateFormat:'yy-mm-dd'
    });
    $(document).ready(function(){
//        //add student
//        $("body").on("click",id,function(){
//               //write your post code here
//        });
	
    })
})();

