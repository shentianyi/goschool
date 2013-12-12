var manager = {
	edit : function(source, id, callback) {
		$.get('/' + source + '/' + id+'/edit', function(data) {
			if (callback)
				callback(data);
		});
	}
}
