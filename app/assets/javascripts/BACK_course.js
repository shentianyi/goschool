var BACKCOURSE=BACKCOURSE || {};
//init
(function(){
    $("body").on("click","#add-course-tab>.tab-item",function(){
        if(!$(this).hasClass("active")){
            $(this).siblings().removeClass("active");
            $(this).addClass("active");
        }
    });
})()