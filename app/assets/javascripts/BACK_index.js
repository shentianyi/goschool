var BACKINDEX=BACKINDEX || {};
BACKINDEX.init=(function(){
    $("#main-navigator-bottom i").popup();
    //添加view
    $("body").on("click","#view-add",function(){
          $(".view-add").css("display","block");
    });
    $("body").on("click","#view-add-close",function(){
        $(".view-add").css("display","none");
    });
    //添加学生或老师或课程
    $("#add-item").on("click",function(event){
        $("#back-index-add").css("left","0").css("right","0");
    });
    $(document).ready(function(){
        BACKINDEX.type=$("#back-index-add").attr("name");
        $("body").on("click","#back-index-add .remove",function(){
            if(BACKINDEX.type=="student"){
                $("#back-index-add .radio.ui").eq(0).checkbox('enable');
                $("#back-index-add .checkbox.ui").checkbox('enable');
            }
            else if(BACKINDEX.type=="course"){
                if(!$("#choose-teacher-delivery div").eq(0).hasClass("active")){
                    $("#choose-teacher-delivery div").eq(0).addClass("active teal");
                    $("#choose-teacher-delivery div").eq(2).removeClass("active teal");
                }
                $("#new-class").css("display","block");
                $("#new-course").css("display","none");
                $("#add-course-tab>div").eq(0).addClass("active");
                $("#add-course-tab>div").eq(1).removeClass("active");
            }
            BACKINDEX.addItem.clear();
            $("#back-index-add").css("left","-999em").css("right","auto");
        });
    });
})();
BACKINDEX.checkLog=function(){
    if($("#search-list").height()+60+$("#back-index-log").height()>$(window).height()){
        $("#back-index-log").css("position","relative");
    }
    else{
        $("#back-index-log").css("position","absolute");
    }
};
BACKINDEX.addItem={};
BACKINDEX.addItem.clear=function(){
    $("#back-index-add .radio.ui").eq(0).checkbox('enable');
    $("#back-index-add input[type='text']").val("");
    $("#back-index-add textarea").val("");
    $("#back-index-add .labelForm").each(function(){
        var length=$(this).find("ul li").length;
        if(length>1){
            $(this).find("ul li").eq(length-1).prevAll().remove();
        }
        $(this).find("ul li").eq(length-1).find("input").val("");
    });
}

