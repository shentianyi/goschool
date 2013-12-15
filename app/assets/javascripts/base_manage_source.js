var stopEvent = function(e) {
	e.stopPropagation();
	e.preventDefault();
}
var manager = {
     create:function(data, callback) {
          $.ajax({
               url : '/' +  this.source,
               data : data,
               type : 'POST',
               success : function(data) {
                    if (callback)
                         callback(data);
               }
          });
     },
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
			dataType : 'json',
			success : function(data) {
				if (callback)
					callback(data);
			}
		});
	},
	destroy : function( id, callback,async) {
	     if(async==null)
	      async=true;
		$.ajax({
			url : '/' +  this.source  + '/' + id,
			type : 'DELETE',
			async : async,
			success : function(data) {
				if (callback)
					callback(data);
			}
		});
	}
}
