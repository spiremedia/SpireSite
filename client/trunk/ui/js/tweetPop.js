jQuery(document).ready(function($) {
    jQuery('a.socialpopup').live('click', function(){
        newwindow=window.open($(this).attr('href'),'','height=400S,width=575');
        if (window.focus) {newwindow.focus()}
        return false;
    });
});					    
