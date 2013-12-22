/**
 * Created with JetBrains RubyMine.
 * User: wayne
 * Date: 13-12-10
 * Time: 上午10:20
 * To change this template use File | Settings | File Templates.
 */
(function(){
    $("#main-navigator-bottom i").popup();
    $("body").on("click","[name='upload-file']",function(event){
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
