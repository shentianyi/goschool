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
	$("body").on("click","#add-student",function(){
            //write your post code here
	    var student = {};
	    student.image_url = $("#image_url").attr("src");
	    student.name = $("#name").val();
	    student.gender = $("#gender input[type=radio]:checked").val();
	    student.birthday = $("#born-date").val();
	    student.school = $("#school").val();
	    student.graduation = $("#graduation-date").val();
	    student.email = $("#email").val();
	    student.phone = $("#phone").val();
	    student.address = $("#address").val();
	    student.guardian = $("#guardian").val();
	    student.guardian_phone = $("#guardian_phone").val();
	    student.referrer_id = $("#referrer").val();
	    
	    var is_active_account = $("#is_active_account input[type='checkbox']").prop("checked")

	    student.tags = [];
	    var $target = $(".back-index-add[name='student']")
	    var length = $target.find("[id='tags']").children().length,tag,tags=[]
	    for(var i =0;i<length-1;i++){
		tag = $target.find("[id='tags']>li").eq(i).find("div").text();
		tags.push(tag);
	    }
	    student.tags = tags;
	    
	    BACKSTUDENT.post_add_student({student:student,is_active_account:is_active_account})
        });
    })
})();

BACKSTUDENT.post_add_student = function(option){
    console.log(option)
    $.post("/students",{
	student:option.student,
	is_active_account:option.is_active_account
    },function(data){
	if(data.result){
	    $(".back-index-add .remove").click();
	    MessageBox("添加成功","top","success");
	}
	else{
	    MessageBox_content(data.content);
	}
    })
}
