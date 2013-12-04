/**
 * Created with JetBrains RubyMine.
 * User: wayne
 * Date: 13-12-4
 * Time: 下午12:36
 * To change this template use File | Settings | File Templates.
 */
(function(){
    var width=$("#back-index-main").width()-$("#detail-navigation").width()-parseInt($("#detail-navigation").css("padding-left"));
    $("#detail-content").width(width-60);
    $(window).on("resize",function(){
        var width=$("#back-index-main").width()-$("#detail-navigation").width()-parseInt($("#detail-navigation").css("padding-left"));
        $("#detail-content").width(width-60);
    });
    $(document).ready(function(){

    });
})()
