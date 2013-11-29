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
                BACKINDEX.addItem.clear.clear();
                $("#back-index-add .radio.ui").eq(0).checkbox('enable');
            }
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
    $("#back-index-add .checkbox.ui").checkbox('enable');
    $("#back-index-add .labelForm").each(function(){
        var length=$(this).find("ul li").length;
        if(length>1){
            $(this).find("ul li").eq(length-1).prevAll().remove();
        }
    });
    var specialInput_size=$("#back-index-add .specialInput>ul").size,i;
    if(specialInput_size>1){
        for(i=0;i<specialInput_size-1;i++){
            $("#back-index-add .specialInput>ul>li").eq(i).remove();
        }
    }
    $("#back-index-add .specialInput>ul>li").eq(specialInput_size-1).find("input").val("");
}

