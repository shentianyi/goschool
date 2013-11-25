var BACKINDEX=BACKINDEX || {};
BACKINDEX.init=(function(){
    $("#main-navigator-bottom i").popup();
    $("body").on("click","#view-add",function(){
          $(".view-add").css("display","block");
    });
    $("body").on("click","#view-add-close",function(){
        $(".view-add").css("display","none");
    });
    $("#add-item").on("click",function(event){
        stop_propagation(event);
        if($(this).attr("state")=="close" || $(this).attr("state")==null){
            $("#back-index-add").css("right","0");
            $("#back-index-main").css("right","250px");
            $(this).attr("state","open");
        }
        else{
            $("#back-index-add").css("right","-260px");
            $("#back-index-main").css("right","0px");
            $(this).attr("state","close");
        }
    });
    $("body").on("click",function(event){
       var target=adapt_event(event).target;
       if(target!=document.getElementById("back-index-add")){
           $("#back-index-add").css("right","-260px");
           $("#back-index-main").css("right","0px");
           $("#add-item").attr("state","close");
       }
    });
    $("#back-index-add").on("click","input",function(event){
        stop_propagation(event);
    });
})();
