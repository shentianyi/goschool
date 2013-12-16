function init_teacher_homework() {
     init_date_picker("#homework-deadline");
     $("#create-homework-button").click(function(){
          var homework={};
         $.each( $(".homework-input"),function(){
              homework[$(this).attr('name')]=$(this).val();
         });
          homework_manager.create({homework:homework},function(data){
               if(!data.result){
                    MessageBox_content(data.content);
               }
          });
     });
}

function bind_menu_event() {

}