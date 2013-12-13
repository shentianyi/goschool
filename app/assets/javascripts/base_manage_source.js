var stopEvent = function(e) {
	e.stopPropagation();
	e.preventDefault();
}
var manager = {
	edit : function(  id, callback) {
		$.get('/' +this.source + '/' + id + '/edit', function(data) {
			if (callback)
				callback(data);
		});
	},
	update : function( id,data, callback) {
		$.ajax({
			url : '/' +  this.source +'/'+id,
			data : data,
			type : 'PUT',
			datType : 'json',
			success : function(data) {
				if (callback)
					callback(data);
			}
		});
	},
	destroy : function( id, callback) {
		$.ajax({
			url : '/' +  this.source  + '/' + id,
			type : 'DELETE',
			success : function(data) {
				if (callback)
					callback(data);
			}
		});
	}
}
