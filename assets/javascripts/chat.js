// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


	// All ajax requests will trigger the wants.js block
	// of +respond_to do |wants|+ declarations
	jQuery.ajaxSetup({
	  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")},
		});


  getText = function(){
  	    $.getJSON(chat_room + "/chat_texts.json", function(json){
	    	if(json != last_json)	//checking for set of messages being delivered twice
		    {
		    	for(x = 0; len = json.length; x++)
		    	{
			    	$("#messages").append("<span class = 'user'>" + json[x].chat_text.user + "</span>: <span class = 'message'>" + json[x].chat_text.body + "</span><br />");
			    	
			    	//scroll to bottom
		    		$("#messages").scrollTop($("#messages").attr("scrollHeight"));
						
					}
				}
				//save json, to compare for multiple batches being returned
				last_json = json;
				
				$("#last_id").attr("value", json[x-1].chat_text.id);  

	    });	
  };
  
  getUsers = function(){
  	    $.getJSON(chat_room + "/chat_users.json", function(json){

	    	$("#chat_users ul").html("");
	    	
	    	for(x = 0; len = json.length; x++)
	    	{
	    		if(json[x-1])
	    		{
		    		if(json[x].chat_user.name != json[x-1].chat_user.name) $("#chat_users ul").append("<li>" + json[x].chat_user.name + "</li>");
					}
					else $("#chat_users ul").append("<li>" + json[x].chat_user.name + "</li>");
				}

	    });	
  };

	$(document).ready(function() {
	
		last_json = "";

    getUsers();

		//chat poller
		$.timer(3500, function(timer){  getText();  });
		
		//user poller
		$.timer(10000, function(timer){  getUsers();	});
		
		
		//scroll to bottom
		$("#messages").scrollTop($("#messages").attr("scrollHeight"));
		
		//ajax for polling
		
	  // All non-GET requests will add the authenticity token
	  // if not already present in the data packet
	  $("body").bind("ajaxSend", function(elm, xhr, s) {
	    if (s.type == "GET") return;
	    if (s.data && s.data.match(new RegExp("\\b" + window._auth_token_name + "="))) return;
	    if (s.data) {
	      s.data = s.data + "&";
	    } else {
	      s.data = "";
	      // if there was no data, jQuery didn't set the content-type
	      xhr.setRequestHeader("Content-Type", s.contentType);
	    }
	    s.data = s.data + encodeURIComponent(window._auth_token_name)
	                    + "=" + encodeURIComponent(window._auth_token);
	  });

		//this is the chat input box AJAX submit
		$('form.jqpost').submit(function() {
			input = 'form.jqpost .chat_input';
	    $(this).ajaxSubmit({dataType: 'xml'});
	    $(input).attr('value', '');
	    
	    //disable the text input for a few seconds
	    $(input).attr('disabled', true);
	    
			$.timer(500, function (timer) {
 				$(input).removeAttr('disabled');
 				$(input).focus();
 				timer.stop();
			});
			
			getText();
			return false;
			
		});
	});

