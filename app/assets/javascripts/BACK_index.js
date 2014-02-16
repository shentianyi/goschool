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
    $("#add-item").on("click",function(){
        var name=$(this).attr("type")
        $(".back-index-add[name='"+name+"']").css("left","0").css("right","0");
        if(name=="student"){
            var number=Math.floor(Math.random()*9);
            $("#image_url").attr("src","/assets/portrait/"+number+".jpg")
//            $("#image_url").attr("src","images/portrait/"+number+".jpg")
        }
    });
    $("body").on("click","#control-log",function(){
        if($(this).attr("state")=="close"){
            $("#back-index-log").css("left","100px");
            $(this).attr("state","open").find("i").removeClass("right").addClass("left");
        }
        else{
            $("#back-index-log").css("left","-210px");
            $(this).attr("state","close").find("i").removeClass("left").addClass("right");
        }
    });
    $("body").on("click","#back-index-main>.search-list>.search-input>i",function(){
        input_for_big_search();
    });



    $(document).ready(function(){
        $("body").on("click",".back-index-add>.inner>.remove",function(){
            var name=$(this).parents(".back-index-add").attr("name");
            if(name=="student"){
                $(".back-index-add[name='student'] .radio.ui").eq(0).checkbox('enable');
                $(".back-index-add[name='student'] .checkbox.ui").checkbox('enable');
            }
            else if(name=="course"){
                if(!$("#choose-teacher-delivery div").eq(0).hasClass("active")){
                    $("#choose-teacher-delivery div").eq(0).addClass("active teal");
                    $("#choose-teacher-delivery div").eq(2).removeClass("active teal");
                }
                if(!$("#choose-teacher-service-delivery div").eq(0).hasClass("active")){
                    $("#choose-teacher-service-delivery div").eq(0).addClass("active teal");
                    $("#choose-teacher-service-delivery div").eq(2).removeClass("active teal");
                }
                $("#new-class,#total-service-teachers,#total-teachers").css("display","block");
                $("#new-service,#sub-service-teachers,#sub-teachers").css("display","none");
                $("#add-course-tab>div").eq(0).addClass("active");
                $("#add-course-tab>div").eq(1).removeClass("active");
                var i,length_class=$("#sub-teachers>.sub-course-block-item").length,
                    length_service=$("#sub-service-teachers>.sub-course-block-item").length;
                for(i=0;i<length_class-1;i++){
                    $("#sub-teachers>.sub-course-block-item").eq(1).remove();
                }
                for(i=0;i<length_service-1;i++){
                    $("#sub-service-teachers>.sub-course-block-item").eq(1).remove();
                }
                var text=$("#add-class-choose-institution .item").eq(0).text();
                $("#add-class-choose-institution,#add-service-choose-institution").find(".text").text(text);
                $("#add-class-choose-institution,#add-service-choose-institution").find(".item").removeClass("active");
                $("#add-class-choose-institution,#add-service-choose-institution").find(".item").eq(0).addClass("active");
            }
            BACKINDEX.addItem.clear();
            $(this).parents(".back-index-add").css("left","-999em").css("right","auto");
        });
    });
})();
BACKINDEX.addItem={};
BACKINDEX.addItem.clear=function(){
    $(".back-index-add .radio.ui").eq(0).checkbox('enable');
    $(".back-index-add input[type='text']").val("");
    $(".back-index-add textarea").val("");
    $(".back-index-add .labelForm").each(function(){
        var length=$(this).find("ul li").length;
        if(length>1){
            $(this).find("ul li").eq(length-1).prevAll().remove();
        }
        $(this).find("ul li").eq(length-1).find("input").val("");
    });
}

