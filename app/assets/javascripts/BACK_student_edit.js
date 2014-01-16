/**
 * Created with JetBrains RubyMine.
 * User: tesla
 * Date: 12/14/13
 * Time: 9:32 AM
 * To change this template use File | Settings | File Templates.
 */

function init_student_edit() {
    $("#birthday").datepicker({
        showOtherMonths: true,
        selectOtherMonths: true,
        changeMonth: true,
        changeYear: true,
        showMonthAfterYear: true,
        yearRange: "-30:+10",
        dateFormat: 'yy-mm-dd'
    });
    $('#is_active_account').checkbox();
    $("#gender>.checkbox").checkbox();
    $("#gender>.checkbox").on("click", function () {
        var value = $("#gender input[type=radio]:checked").attr("value");
        var data = {
            id: '',
            student: {}
        };
        data.id = $("#student-detail-info").attr('student');
        //if(BACKSTUDENT.check.test(value,$(this).attr('id'))){
        data['student']['gender'] = value;
        student_manager.update($("#student-detail-info").attr('student'), data), function () {
            if (data.result) {
            }
            else {
            }
        };
        //}

    });
    $('#is_active_account').on("click", function () {
        var result = $("input", this).prop("checked");
        var data = {
            id: '',
            is_active_account: result
        };
        data.id = $("#student-detail-info").attr('student');
        student_manager.update($("#student-detail-info").attr('student'), data), function () {
            if (data.result) {
            }
            else {
            }
        };
    });
}
