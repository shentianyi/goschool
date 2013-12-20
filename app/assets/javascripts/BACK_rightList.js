//type name
//should be
//student teacher course

var BACKINDEX=BACKINDEX || {};
BACKINDEX.right_list=BACKINDEX.right_list||{};
BACKINDEX.right_list.student={};
BACKINDEX.right_list.teacher={};
BACKINDEX.right_list.course={};
BACKINDEX.right_list.student.info={
     href:""
};
BACKINDEX.right_list.teacher.info={
    href:""
};
BACKINDEX.right_list.course.info={
    href:""
};
(function(){
    BACKINDEX.right_list.type=$("#back-index-main").attr("name");
    $(document).ready(function(){
         $("#back-index-main").scroll(function(){
             BACKINDEX.right_list.observeScroll();
         })
    });
})();
//////////////////////////////////////////////////////////////////////////////////////////////////// 列表的呈现
BACKINDEX.right_list.currentPage;
BACKINDEX.right_list.loadCheck=0;
BACKINDEX.right_list.stillHave=false;
BACKINDEX.right_list.threshold=50;
BACKINDEX.right_list.temp_object;
//BACKINDEX.right_list.id;
BACKINDEX.right_list.generateResult=function(data_to_sent){
//    BACKINDEX.right_list.id=parameter;
    BACKINDEX.right_list.currentPage=0;
    BACKINDEX.right_list.stillHave=true;
    $("#search-result").empty();
    var p=data_to_sent,c={};
    BACKINDEX.right_list.temp_object=deepCopy(p,c);
    BACKINDEX.right_list.loadData();
}
BACKINDEX.right_list.loadData=function(){
    if(BACKINDEX.right_list.loadCheck!=0) return;
    BACKINDEX.right_list.loadCheck++;
    loader("search-result","auto","auto","0","50%");
    window.setTimeout(function(){
        //post
        $.ajax({
            type:"GET",
            async:false,
            data:{
                search_type:BACKINDEX.right_list.temp_object.search_type,
                entity_type:BACKINDEX.right_list.temp_object.entity_type,
                q:$.trim(BACKINDEX.right_list.temp_object.search_queries),
                page:BACKINDEX.right_list.temp_object.page
            },
            success:function(data){
                if(data.result){
                    remove_loader();
                    if(data.content.length==0){
                        BACKINDEX.right_list.stillHave=false;
                        return
                    }
                    $("#search-result").append(data.content);
                    BACKINDEX.right_list.temp_object.page++;
                }
                else{
                    MessageBox_content(data.content);
                }
            }
        }).always(function(){
                BACKINDEX.right_list.loadCheck--;
        });

//        $.getJSON(BACKINDEX.right_list.nextPage(),{},function(data){
//            remove_loader();
//            if(data.length==0){
//                BACKINDEX.right_list.stillHave=false;
//                return
//            }
//            var render_data={},type=BACKINDEX.right_list.type;
//            render_data[type]=data;
//            var render=Mustache.render(BACKINDEX.right_list[type].template,render_data);
//            $("#search-result").append(render);
//        }).always(function(){
//                BACKINDEX.right_list.loadCheck--;
//        });
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
//////////////////////////////////////////////////////////////////////////////////////////////////// 模板
BACKINDEX.right_list.student.template="\
    {{#student}}\
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
{{/student}}"

BACKINDEX.right_list.course.template='\
    {{#course}}\
    <li>\
    <table class="ui table segment">\
    <tr>\
        <td colspan="3" class="fourteen wide">\
            <p class="course-name">{{name}}</p>\
            <div class="ui blue labels small">\
                {{#tag}}\
                <a class="ui label">\
                   {{title}}\
                </a>\
                {{/tag}}\
            </div>\
        </td>\
        <td rowspan="2" class="course-status">\
            <p>状态</p>\
            <p>{{status}}</p>\
        </td>\
    </tr>\
    <tr>\
    <td>\
        <p>授课时间:<span>{{course-time}}</span></p>\
        <p class="course-teachers">授课老师:\
        {{#teachers}}\
        <span>{{teacher}}</span>\
        {{/teachers}}\
        </p>\
        <p>已报班: <span class="class-size">{{course-student}}</span> 人</p>\
    </td>\
    <td class="course-desc">\
    <p ><span>简介:</span><span>{{desc}}</span></p>\
    </td>\
    <td class="three wide">\
    <div class="ui mini button teal">\
    详情\
    </div>\
</td>\
</tr>\
</table>\
</li>\
{{/course}}'

BACKINDEX.right_list.teacher.template='\
    {{#teacher}}\
    <li>\
    <table class="ui table segment">\
    <tr>\
        <td class="three wide">{{name}}</td>\
        <td class="four wide">{{mail}}</td>\
        <td class="four wide">{{phone}}</td>\
    </table>\
</li>\
{{/teacher}}'


