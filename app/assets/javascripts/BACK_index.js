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
                BACKSTUDENT.addItem.clear();
                $("#back-index-add .radio.ui").eq(0).checkbox('enable');
            }
            $("#back-index-add").css("left","-999em").css("right","auto");
        });
    });
})();

