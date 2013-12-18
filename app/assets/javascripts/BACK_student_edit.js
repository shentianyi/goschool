/**
 * Created with JetBrains RubyMine.
 * User: tesla
 * Date: 12/14/13
 * Time: 9:32 AM
 * To change this template use File | Settings | File Templates.
 */

function init_student_edit() {
        $("#birthday,#graduation").datepicker({
            showOtherMonths: true,
            selectOtherMonths: true,
            changeMonth: true,
            changeYear: true,
            showMonthAfterYear:true,
            yearRange: "-30:+10",
            dateFormat:'yy-mm-dd'
        });
        $('#gender>.checkbox,#is_active_account').checkbox();
//        $("body").on("click","#edit-student",function(){
//            //write your post code here
//            var student = {};
//            student.image_url = $("#image-url").attr("src");
//            student.name = $("#name").val();
//            student.gender = $("#gender input[type=radio]:checked").val();
//            student.birthday = $("#birthday").val();
//            student.school = $("#school").val();
//            student.graduation = $("#graduation").val();
//            student.email = $("#email").val();
//            student.phone = $("#phone").val();
//            student.address = $("#address").val();
//            student.guardian = $("#guardian").val();
//            student.guardian_phone = $("#guardian_phone").val();
//            student.referrer_id = $("#referrer>li").eq(0).find("div").attr("logininfo_id");
//
//            var is_active_account = $("#is_active_account input[type='checkbox']").prop("checked")
//
//            student.tags = [];
//            var $target = $("#student-edit-section[name='student']")
//            var length = $target.find("[id='tags']").children().length,tag,tags=[]
//            for(var i =0;i<length-1;i++){
//                tag = $target.find("[id='tags']>li").eq(i).find("div").text();
//                tags.push(tag);
//            }
//            student.tags = tags;
//
//            console.log(student);
//        });

//        $(".update-input").change(function(){
//            var data = {
//                id: '',
//                student : {},
//                is_active_account : false
//            };
//            data.id =  $("#student-detail-info").attr('student');
//	        if(BACKSTUDENT.check.test($(this).val(),$(this).attr('id'))){
//		        data['student'][$(this).attr('id')] = $(this).val();
//		        student_manager.update($("#student-detail-info").attr('student'),data),function(){
//                     if(data.result){
//
//                     }
//                     else{
//
//                     }
//		        };
//	        }
//        });
}
