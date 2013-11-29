//type name
//should be
//Student teacher course

var BACKINDEX=BACKINDEX || {};
BACKINDEX.right_list=BACKINDEX.right_list||{};
BACKINDEX.right_list.student={};
BACKINDEX.right_list.teacher={};
BACKINDEX.right_list.course={};
BACKINDEX.right_list.student.info={
     href:""
};
BACKINDEX.right_list.initital=(function(){
    BACKINDEX.right_list.type=$("#back-index-main").attr("name");
    $(document).ready(function(){
        $("#back-index-main").scroll(BACKINDEX.right_list.observeScroll)
    });
})();
//////////////////////////////////////////////////////////////////////////////////////////////////// 列表的呈现
BACKINDEX.right_list.currentPage;
BACKINDEX.right_list.loadCheck=0;
BACKINDEX.right_list.stillHave=false;
BACKINDEX.right_list.threshold=50;
BACKINDEX.right_list.id;
BACKINDEX.right_list.generateResult=function(parameter){
    BACKINDEX.right_list.id=parameter;
    BACKINDEX.right_list.currentPage=0;
    BACKINDEX.right_list.stillHave=true;
    $("#search-result").empty();
    BACKINDEX.right_list.loadData();
}
BACKINDEX.right_list.loadData=function(){
    if(BACKINDEX.right_list.loadCheck!=0) return;
    BACKINDEX.right_list.loadCheck++;
    loader("search-result","auto","auto","0","50%");
    window.setTimeout(function(){
        //post
        $.getJSON(BACKINDEX.right_list.nextPage(),{},function(data){
            BACKINDEX.checkLog();
            remove_loader();
            if(data.length==0){
                BACKINDEX.right_list.stillHave=false;
                return
            }
            var render_data={},type=BACKINDEX.right_list.type;
            render_data[type]=data;
            var render=Mustache.render(BACKINDEX.right_list[type].template,render_data);
            $("#search-result").append(render);
        }).always(function(){
                BACKINDEX.right_list.loadCheck--;
        });
        window.setTimeout(function(){
            if($("#search-list").height()+parseInt($("#search-list>.search-input").css("margin-top"))<$(window).height()){
                BACKINDEX.right_list.loadData();
            }
        },100);
    },1000);
};
BACKINDEX.right_list.nextPage=function(){
    BACKINDEX.right_list.currentPage++;
    var type=BACKINDEX.right_list.type;
    var newURL=BACKINDEX.right_list[type].info.href+BACKINDEX.right_list.id+"/"+BACKINDEX.right_list.currentPage;
    return newURL;
};
BACKINDEX.right_list.observeScroll=function(){
   if($("#loader").is(":visible")) return;
   var bottomPosition=$(window).scrollTop()+$(window).height();
   var distanceFromBottom=$(document).height()-bottomPosition;
   if(distanceFromBottom<=BACKINDEX.right_list.threshold && $("#search-result").size()>0 && BACKINDEX.right_list.stillHave){
       BACKINDEX.right_list.loadData();
   }
};
BACKINDEX.right_list.student.template="\
    {{#Student}}\
    <li>\
    <table class='ui table segment'>\
        <tr>\
            <td class='two wide'>\
                <img class='circular ui image mini portrait' src='images/portrait/0.jpg' />\
                <p class='name'>{{name}}</p>\
            </td>\
            <td class='two wide'>\
                <p class='type'>{{type}}</p>\
                <p>{{school}}</p>\
                <p>{{grade}}</p>\
                <p>{{age}}岁</p>\
            </td>\
            <td class='five wide'>\
                <div class='ui blue labels small'>\
                    {{#tag}}\
                    <a class='ui label'>\
                      {{title}}\
                    </a>\
                    {{/tag}}\
                </div>\
                <p class='parent'><span>监护人:</span><span>{{parent}}</span></p>\
                <p class='phone'><span>联系电话:</span><span>{{phone}}</span></p>\
                <p class='consult-time'><span>上次咨询:</span><span>{{consult-time}}</span></p>\
            </td>\
            <td class='two wide'>\
                <p class='maybe-know'>推荐人</p>\
                <p>{{recommend}}</p>\
            </td>\
            <td class='three wide'>\
                <p class='recommend'>可能认识</p>\
                <p>\
                   {{#may_know}}\
                   <span>{{name}}</span>\
                   {{/may_know}}\
                </p>\
            </td>\
            <td class='three wide'>\
                <div class='ui mini button teal'>\
                详情\
                </div>\
            </td>\
        </tr>\
    </table>\
    </li>\
{{/Student}}"
//////////////////////////////////////////////////////////////////////////////////////////////////// 添加

