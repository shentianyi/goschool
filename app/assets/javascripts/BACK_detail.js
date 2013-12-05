/**
 * Created with JetBrains RubyMine.
 * User: wayne
 * Date: 13-12-4
 * Time: 下午12:36
 * To change this template use File | Settings | File Templates.
 */
(function(){
    var width=$("#back-index-main").width()-$("#detail-navigation").width()-parseInt($("#detail-navigation").css("padding-left"));
    $("#detail-content").width(width-65);
    $(window).on("resize",function(){
        var width=$("#back-index-main").width()-$("#detail-navigation").width()-parseInt($("#detail-navigation").css("padding-left"));
        $("#detail-content").width(width-65);
    });
    $("#back-index-main").scroll(function(){
        var scroll_height=$("#back-index-main")[0].scrollTop;
        var origin_top=$("#detail-navigation").attr("origin_top");
        if(scroll_height>=origin_top){
            $("#detail-navigation").css("position","fixed").css("top","0");
        }
        else{
            $("#detail-navigation").css("position","static");
        }
        $("#accordion>div").each(function(){
            if(($(this)[0].getBoundingClientRect().top<10 && $(this)[0].getBoundingClientRect().top>-10) || ($(this)[0].getBoundingClientRect().top<0 && $(this)[0].getBoundingClientRect().bottom>$(window).height())){
                var href=$(this).attr("id");
                $("#detail-navigation-menu a").removeClass("active");
                $("#detail-navigation-menu").find("[href='#"+href+"']").addClass("active");
            }
        })
    });
    $('#accordion').accordion();
    $("body").on("click","#detail-navigation .item",function(){
        if(!$(this).hasClass("active")){
            $(this).siblings().removeClass("active");
            $(this).addClass("active");
            var target=$(this).attr("href");
            $(target).children().addClass("active");
        }
    });
    $("body").on("click","#course-detail-edit",function(){
        $("#back-index-add").css("left","0px").css("right","0px");
    })
    $(document).ready(function(){

    });
})()
