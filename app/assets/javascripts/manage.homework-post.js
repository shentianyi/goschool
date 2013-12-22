/**
 * Created by wayne on 13-12-22.
 */
(function(){
    $('#accordion').accordion();
    $("body").on("click","#add-item",function(){
        $("#homework-post-add").css("left",0).css("right",0);
    });
    $("body").on("click","#homework-post-add .remove",function(){
        $("#homework-post-add input,#homework-post-add textarea").val("");
        $("#homework-post-add").css("left","-999em").css("right","auto");

    });
    $(window).resize(function(){
        var width=$("#post-home").width()-$("#post-home .left").width()-80;
        $("#post-home .right").width(width);
    });
    $(document).ready(function(){
        var width=$("#post-home").width()-$("#post-home .left").width()-80;
        $("#post-home .right").width(width);
    })
})()
