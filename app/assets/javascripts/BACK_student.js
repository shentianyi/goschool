//添加学生，里面的插件初始化
var BACKSTUDENT=BACKSTUDENT||{};
//student init
(function(){
    $("#birthday").datepicker({
        showOtherMonths: true,
        selectOtherMonths: true,
        changeMonth: true,
        changeYear: true,
        showMonthAfterYear:true,
        yearRange: "-30:+10",
        dateFormat:'yy-mm-dd'
    });
    $("#student-list-name i").popup();

    $("body").on("keyup","#phone",function(event){
        var obj=adapt_event(event).target;
        phoneValidate(obj);
    }).on("keyup","#guardian_phone",function(event){
        var obj=adapt_event(event).target;
        phoneValidate(obj);
    });
    $("body").on("click_add", "#autoComplete-call li", function(event, msg) {
        if(msg.id) {
            if($("#autoComplete-call").attr("target")=="edit_referrer"){
                if($("#edit_referrer").parent().prevAll().length==1){
                    msg.callback=function(data){
                        return false;
                    };
                    MessageBox("抱歉,只能添加一个推荐人","top","warning");
                    $("#edit_referrer").val("");
                }
            }

        }
    });
    if($('#is_active_account').hasClass("create")){
        $('#is_active_account').checkbox('disable');
    }
    $(document).ready(function(){
	//        //add student
	$("body").on("click","#add-student",function(){
            //write your post code here
	    var student = {};
//	    student.image_url = $("#image_url").attr("src");
	    student.name = $("#name").val();
        student.remark = $.trim($("#remark").val());
	    student.gender = $("#gender input[type=radio]:checked").attr("value");
	    student.birthday = $("#birthday").val();
	    student.school = $("#school").val();
	    student.graduation = $("#graduation").val();
	    student.email = $("#email").val();
	    student.phone = $("#phone").val();
	    student.address = $("#address").val();
	    student.guardian = $("#guardian").val();
	    student.guardian_phone = $("#guardian_phone").val();
	    student.referrer_id = $("#referrer>li").eq(0).find("div").attr("logininfo_id");
	    var is_active_account = $("#is_active_account input[type='checkbox']").prop("checked");

	    student.tags = [];
	    var $target = $(".back-index-add[name='student']");
	    var length = $target.find("[id='tags']").children().length,tag,tags=[];
	    for(var i =0;i<length-1;i++){
		tag = $target.find("[id='tags']>li").eq(i).find("div").text();
		tags.push(tag);
	    }
	    student.tags = tags;

	    BACKSTUDENT.post_add_student({student:student,is_active_account:is_active_account});
        });
    });
    search_obj = Search.instance();
    search_obj.init("full_text","Student",$("#container_for_input"),$("#container_for_list"));
})();

BACKSTUDENT.post_add_student = function(option){
    if(option.student.name.length>0){
        //if(BACKSTUDENT.check.test(option.student.email,"email")){
            $.post("/students",{
                student:option.student,
                is_active_account:option.is_active_account
            },function(data){
                if(data.result){
                    $(".back-index-add .remove").click();
                    MessageBox("添加成功","top","success");
                    location.reload();
                }
                else{
                    MessageBox_content(data.content);
                }
            });
        //}
        //else{
        //    MessageBox("请填写正确的邮件地址","top","warning");
        //}
    }
    else{
       MessageBox("请填写学生的姓名","top","warning");
    }

}
BACKSTUDENT.easy_email_validate=function(email){
    if(email.indexOf("@")!=-1 && email.length>0 && email.indexOf(".")!=-1 && email.indexOf(".")>email.indexOf("@")){
        return true
    }
    else{
        return false
    }
}

BACKSTUDENT.check = new Object();

BACKSTUDENT.check.email = /^([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22))*\x40([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d))*$/;

BACKSTUDENT.check.phone = /^0*(13|15|18)\d{9}$/;

BACKSTUDENT.check.guardian_phone = /^0*(13|15|18)\d{9}$/;

BACKSTUDENT.check.test = function(str,type){
    if(BACKSTUDENT.check[type] && BACKSTUDENT.check[type].test(str)){
	return true;
    }
    else{
	//MessageBox("格式不正确！请输入正确的格式!","top","warning")
	return false;
    }
}
