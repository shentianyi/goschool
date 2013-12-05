/**
 * Created with JetBrains RubyMine.
 * User: wayne
 * Date: 13-12-4
 * Time: 下午12:36
 * To change this template use File | Settings | File Templates.
 */
var DETAIL=DETAIL || {};
DETAIL.course={};
(function(){
    $("body").on("click","#course-detail-new-student",function(event){
        DETAIL.course.join_student();
    });
    $(document).ready(function(){

    });
})();
DETAIL.course.join_student=function(){

};

