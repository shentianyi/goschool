var course_manager = {
	source: 'courses',
	edit : function() {
		manager.edit(this.source, $("#course-detail-info").attr('course'), function(data) {
			$("#course-edit-section").html(data);
		})
	}
}