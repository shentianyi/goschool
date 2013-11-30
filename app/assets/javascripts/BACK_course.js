var BACKCOURSE=BACKCOURSE || {};
//init
(function(){
    $("#course-begin-date").datepicker({
        showOtherMonths: true,
        selectOtherMonths: true,
        changeMonth: true,
        changeYear: true,
        dateFormat:'yy-mm-dd',
        onClose: function( selectedDate ) {
            $( "#course-end-date" ).datepicker( "option", "minDate", selectedDate );
        }
    });
    $("#course-end-date").datepicker({
        showOtherMonths: true,
        selectOtherMonths: true,
        changeMonth: true,
        changeYear: true,
        dateFormat:'yy-mm-dd',
        onClose: function( selectedDate ) {
            $( "#course-begin-date" ).datepicker( "option", "maxDate", selectedDate );
        }
    });
    $("#service-begin-date").datepicker({
        showOtherMonths: true,
        selectOtherMonths: true,
        changeMonth: true,
        changeYear: true,
        dateFormat:'yy-mm-dd',
        onClose: function( selectedDate ) {
            $( "#service-end-date" ).datepicker( "option", "minDate", selectedDate );
        }
    });
    $("#service-end-date").datepicker({
        showOtherMonths: true,
        selectOtherMonths: true,
        changeMonth: true,
        changeYear: true,
        dateFormat:'yy-mm-dd',
        onClose: function( selectedDate ) {
            $( "#service-begin-date" ).datepicker( "option", "maxDate", selectedDate );
        }
    });
    $("body").on("click","#add-course-tab>.tab-item",function(){
        if(!$(this).hasClass("active")){
            $(this).siblings().removeClass("active");
            $(this).addClass("active");
            $(".tab-block").css("display","none");
            $(".tab-block[from='"+$(this).attr("for")+"']").css("display","block");
        }
    });
    $("body").on("click","#choose-teacher-delivery div",function(){
        if(!$(this).hasClass('active') && !$(this).hasClass('or')){
            $(this).siblings().removeClass("teal active");
            $(this).addClass("teal active");
        }
    });
})()