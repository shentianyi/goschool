/**
 * Created with JetBrains RubyMine.
 * User: wayne
 * Date: 13-12-23
 * Time: 下午5:43
 * To change this template use File | Settings | File Templates.
 */
(function(){
    $('#accordion').accordion();
    $("body").on("keyup","#homework-post-right input[type='text']",function(event){
        var obj=adapt_event(event).target;
        integerOnly(obj);
    });
    $("body").on("click","#add-item",function(){
        $("#homework-post-add").css("left",0).css("right",0);
    });
    $("body").on("click",".homework-post-add>.inner>.remove",function(){
        $(".homework-post-add input,.homework-post-add textarea").val("");
        $(".homework-post-add").css("left","-999em").css("right","auto");
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