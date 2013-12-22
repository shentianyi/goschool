/**
 * Created by wayne on 13-12-22.
 */
(function(){
    $('#accordion').accordion();
    $(window).resize(function(){
        var width=$("#post-home").width()-$("#post-home .left").width()-80;
        $("#post-home .right").width(width);
    });
    $(document).ready(function(){
        var width=$("#post-home").width()-$("#post-home .left").width()-80;
        $("#post-home .right").width(width);
    })
})()
