/**
 * Created by wayne on 13-12-22.
 */
(function(){
    $("body").on("click","#upload-homework",function(event){
        stop_propagation(event);
        var top=$(this)[0].getBoundingClientRect().bottom;
        var left=$(this)[0].getBoundingClientRect().right-140;
        $("#upload-wrap").css("top",top).css("left",left).find("p").remove();
    }).on("click","#upload-wrap .remove",function(){
            $("#upload-wrap").css("top",0).css("left","-999em");
        }).on("click",function(){
            $("#upload-wrap .remove").click();
        }).on("click","#upload-wrap a,#upload-wrap,#upload-wrap p",function(event){
            stop_propagation(event);
        })
})()
