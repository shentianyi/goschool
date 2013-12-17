//添加学生，里面的插件初始化
var BACKSTUDENT=BACKSTUDENT||{};
//student init
(function(){
    $("#birthday,#graduation").datepicker({
        showOtherMonths: true,
        selectOtherMonths: true,
        changeMonth: true,
        changeYear: true,
        showMonthAfterYear:true,
        yearRange: "-30:+10",
        dateFormat:'yy-mm-dd'
    });
    $("body").on("keyup","#phone",function(event){
        var obj=adapt_event(event).target;
        phoneValidate(obj);
    }).on("keyup","#guardian_phone",function(event){
        var obj=adapt_event(event).target;
        phoneValidate(obj);
    });
    $("body").on("click_add", "#autoComplete-call li", function(event, msg) {
        if(msg.id) {
            if($("#edit_referrer").parent().prevAll().length==1){
                msg.callback=function(data){
                    return false;
                }
                MessageBox("抱歉,只能添加一个推荐人","top","warning");
                $("#edit_referrer").val("");
            }
        }
    });

    $(document).ready(function(){
	//        //add student
	$("body").on("click","#add-student",function(){
            //write your post code here
	    var student = {};
	    student.image_url = $("#image_url").attr("src");
	    student.name = $("#name").val();
	    student.gender = $("#gender input[type=radio]:checked").val();
	    student.birthday = $("#birthday").val();
	    student.school = $("#school").val();
	    student.graduation = $("#graduation").val();
	    student.email = $("#email").val();
	    student.phone = $("#phone").val();
	    student.address = $("#address").val();
	    student.guardian = $("#guardian").val();
	    student.guardian_phone = $("#guardian_phone").val();
	    student.referrer_id = $("#referrer>li").eq(0).find("div").attr("logininfo_id");
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
    if(option.student.name.length>0){
        if(BACKSTUDENT.easy_email_validate(option.student.email)){
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
        else{
            MessageBox("请填写正确的邮件地址","top","warning");
        }
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

BACKSTUDENT.check.email = /^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/;

BACKSTUDENT.check.phone = /^0*(13|15|18)\d{9}$/;

BACKSTUDENT.check.guardian_phone = /^0*(13|15|18)\d{9}$/;

BACKSTUDENT.check.test = function(str,type){
    if(BACKSTUDENT.check[type].test(str)){
	return true;
    }
    else{
	MessageBox_content('格式不正确！请输入正确的格式');
	return false;
    }
}
