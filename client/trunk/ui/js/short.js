// JavaScript Document






/*
 * 
 * Author: Ian Coyle
 * www.iancoyle.com
 *
 * 
 *
 * You are beautiful.
 * 
 */
 
 
 
 
/* ---------------------------------- */

/*
 *  TABLE OF CONTENTS
 *  
 *  Initialize
 *  Events
 *  Index
 *  Project
 *  Gallery
 *  Parallax
 *  Content
 *  Hinting
 *  Modal
 *  Footer
 *  Scroll
 *  Keyboard
 *  Connect
 *  HTML5
 *  Exhibit: Koston
 *  Exhibit: Prius
 *  Exhibit: Snow
 *  Exhibit: NBW
 *  GoogleAnalytics
 *
 */
 
 
/* ---------------------------------- */

/* Initialize */

jQuery(
  
  function ($) {

    $.HTML = $('html');
    
    $.Body = $('body');
    
    $.Window = $(window);
    
    $.Document = $(document);
    
    $.Scroll = ($.browser.mozilla || $.browser.msie) ? $('html') : $.Body;
    
    $.Mobile = ($.Body.hasClass('webkit-mobile') || (navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPod/i)) || (navigator.userAgent.match(/iPad/i))),
    
    $.MobileDevice = ((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPod/i))),
    
    $.Tablet = (navigator.userAgent.match(/iPad/i)),
    
    $.OldIE = ($.browser.msie && jQuery.browser.version<9);
    
    $('[data-script]').Instantiate();
    
    $.Body
    .GoogleAnalytics();
    //.Keyboard()
    
    if ($.Mobile)
      $.Body.Mobile();
      
      
      
  } 
  
);

/* ---------------------------------- */

/* FieldNotes.IanCoyle.Com */

/* This comment for Howells. */

(function($) {

  $.FieldNotes = {
    
    version:          '1.0.1',
    colors:           { pink: '#ffb6c1', blue: '#b2f1ec', yellow: '#ffff99', orange: '#ffd1a5', green: '#c5ffc8', violet: '#dde6ff',grey: '#ddd'},
    _contentTop:      1450
    
  }
    
  
  

   /* Events */

   $.Events = {
  
     INDEX:           'index',
     LOAD:            'siteLoad',
     
     MOBILE_NAV:      'mobileNav',
     
     PROJECT_SEEK:    'projectSeek',
     PROJECT_PROXY:   'projectProxy', 
     PROJECT_LOAD:    'projectLoad',
     PROJECT_LOADED:  'projectLoaded', 
     PROJECT_DISPLAY: 'projectDisplay',
     PROJECT_RESET_VIEW: 'projectResetView',
     
     KEY_ESC:         'keyEscape',
     KEY_ENTER:       'keyEnter',
     KEY_SPACE:       'keySpace',
     KEY_UP:          'keyUp',
     KEY_DOWN:        'keyDown',
     KEY_RIGHT:       'keyRight',
     KEY_LEFT:        'keyLeft',
     
     MODAL:           'modalView'
     
   } // Events  


  
})(jQuery);


/* ---------------------------------- */

/* Auto Instantiate */

(function($) {

  $.fn.Instantiate = function(settings) {
     
    var config = {};
 
    if (settings) $.extend(config, settings);
  
      this.each(function() { 

          var $self = $(this),
              $script = $self.attr('data-script');
                  
          if ($self[$script])
            $self[$script]();
              
      });
      
  }
    
})(jQuery);

 

/* ---------------------------------- */

/* Index */

(function($) {

  $.fn.Index = function(settings) {
     
    var config = {};
 
    if (settings) $.extend(config, settings);
  
      this.each(function() { 
    
         var $self = $(this),
             $masthead = $self.find('#masthead'),
             $ul = $self.find('ul'),
             $li = $self.find('li'),
             $li_first = $self.find('li:first-child'),
             $footer = $('footer'),
             _collapsed = false,
             _scrollOffset = 0,
             _navOffset = 250,
             _active = -2,
             _navHeight = 60,
             _$activeProject;
         
         if (!$.MobileDevice)
           $ul.css({position:"absolute",top: _navOffset,marginTop: _navOffset})
         
         $li.Project();
         
         if (!$.Mobile) { 
         
          $self.css({position: 'fixed'});
          
          $footer.css({position: 'fixed',bottom: 'auto',top: $(document).height()});
          
         }


        
          
        $.Body
         .bind($.Events.KEY_RIGHT,_next)
         .bind($.Events.KEY_DOWN,_next)
         .bind($.Events.KEY_LEFT,_prev)
         .bind($.Events.KEY_UP,_prev)
         .bind($.Events.MOBILE_NAV,
            function(){
              
                $li.each(function(li_index) {
                    $(this).css({display: 'block'})
                })
                
                $ul.css({height: 'auto'})
            })
         .bind($.Events.PROJECT_SEEK, 
          function(e,id,indx,$prj){
          
              _active = indx;
                  
              _$activeProject = $prj;
              
              if ($.Mobile) {
              
              
                if ($.Tablet)
                  $.Window.scrollTop($.FieldNotes._contentTop - 50)
                else
                  $.Window.scrollTop(140);


                
                $li.each(function(li_index) {
                  if (li_index==_active)
                    $(this).css({display: 'block'})
                  else
                    $(this).css({display: 'none'})
                    
                })
                
                $ul.animate({height: 50},500,'easeInOutQuart',
                
                  function() {
                    
                    $.Body.triggerHandler($.Events.PROJECT_LOAD,[id,_active,_$activeProject])
                    
                  })
              
              }else{
              
                $.Scroll.animate(
                    {scrollTop: $.FieldNotes._contentTop},
                    600,
                    'easeInOutQuart',
                    function(){ $.Body.triggerHandler($.Events.PROJECT_LOAD,[id,_active,_$activeProject]) }
                )
                
              }
                    
            })
         .bind($.Events.PROJECT_LOAD,
            function(e){
       
              _scrollOffset = $.Window.scrollTop();
           
            })
         .bind($.Events.PROJECT_LOADED,
            function(e){

              if ($.Mobile) {
                if ($.Tablet)
                  $.Window.scrollTop($.FieldNotes._contentTop - 50)
              } else {
                $.Scroll.animate(
                  {
                    scrollTop: 1600,
                    scrollLeft: 0
                  },600,'easeInOutQuart');
              }

              $.Body.addClass('_project');
                          
            })
         .bind($.Events.PROJECT_DISPLAY,
            function(e){
            
              $.Body.removeClass('_loading')

                          
            })
         .bind($.Events.PROJECT_RESET_VIEW,
            function(e){

                $.Scroll.animate(
                  {
                    scrollTop: 1600,
                    scrollLeft: 0
                  },600,'easeInOutQuart');
 

                          
            })
            
         
         if (!$.Mobile)
          $.Window.bind('scroll',_scrollIndex)
        else
          $self.css({position: 'absolute'})
         
         function _scrollIndex() {
          
              var sTop = $.Window.scrollTop()/2,
                  sLeft = $.Window.scrollLeft(),
                  ulTop = (-sTop + _navOffset < 0) ? 0 : -sTop + _navOffset,
                  t = -sTop,
                  ulHeight = $li.length*_navHeight;
                
              ulTop = -sTop + _navOffset
              
              if (_active>-1 && (-sTop + _navOffset < 0) )
                ulTop = 0;
              
              if (-sTop + _navOffset < 0){
              
                t = -_navOffset
                
                if (_$activeProject)
                  ulHeight = ($li.length*_navHeight) - (sTop-_navOffset)
                
                var lTop = (sTop-_navOffset) < _active * _navHeight ? -(sTop-_navOffset) : -_active * _navHeight
                
                if (_active>0)
                  $li_first.css({marginTop:lTop})
              
                
              }else{
              
                $li_first.css({marginTop:0})
                
              }
              
              if (sTop+_navHeight>_navOffset+$li.length*_navHeight)
                t = -_navOffset - ( (sTop+_navHeight) - (_navOffset+$li.length*_navHeight) )
                 
              if (ulHeight<_navHeight)
                  ulHeight = _navHeight;
                  
              $ul.css({marginTop:ulTop,height:ulHeight})                
              
              $self.css({top: t})
              
              
              $footer.css({top: $(document).height() - $.Window.scrollTop() - $footer.outerHeight()})

              
         }//scroll
         
         function _next(){
         
          if (!$.Body.hasClass('_loading')) {
            _active++;
            
            if (_active>$li.length-1)
              _active = $li.length-1;
              
            
            $.Body.triggerHandler($.Events.PROJECT_PROXY,_active)
          }
          
         }//next
         
         function _prev(){
         
          if (!$.Body.hasClass('_loading')) {
          
              _active--;
              
              if (_active < 0) {
                
                if (_active<-2) 
                   _active = -2;
                
                var sT = (_active>-2) ? 500 : 0
                
                $.Scroll.animate({scrollTop:sT},600,'easeInOutQuart')
                
              }else{
              
                $.Body.triggerHandler($.Events.PROJECT_PROXY,_active)
              
              }
            
            }
          
         }//prev

              
      });
      
      return this;
      
  } //Index
  
  
  $.fn.Project = function() {
   
     this.each(function(index) { 
      
        var $self = $(this),
            $a = $self.find('>a'),
            _id = $a.attr('data-id');
            
        var _offset = 500,
            _activeHeight = 0;


        $self.attr('data-title',$a.html())
        
        $.Body
         .bind($.Events.PROJECT_PROXY,
          function(e,indx){
          
            if (indx===index)
              $.Body.triggerHandler($.Events.PROJECT_SEEK,[_id,index,$self])
          
          })
                
        $a
         .bind('click',
          function(e){
          
            $(this).addClass('_clicked')
            
            $.Body.triggerHandler($.Events.PROJECT_SEEK,[_id,index,$self])
            
            //don'tshow hash url:
            e.preventDefault();
            
          })
            
     });
     
    return this;
     
  } //Project
  

})(jQuery); 




/* ---------------------------------- */

/* Gallery */

(function($) {

  $.fn.Gallery = function(settings) {
     
    var config = {};
 
    if (settings) $.extend(config, settings);
  
      this.each(function(index) { 
    
         var $self = $(this),
             $img = $self.find('.gallery-images img'),
             $nav = $('<div/>').addClass('gallery-nav'),
             $gallerytitle,
             $gallerynav,
             $a,
             _primaryGallery = $self.attr('data-primary'),
             _active =  0;
             
             
         if ($self.attr('data-nav'))
          $gallerynav = $('#' + $self.attr('data-nav')) 
         else
          $gallerynav = $self
          
         if ($self.attr('data-title'))
           $gallerytitle = $('#' + $self.attr('data-title')) 

         $nav.appendTo($gallerynav)
             
         _init();
         

         
         if ($img.length>1)
           $img
            .bind('click',
              function(){
                _active++;
                if(_active>$img.length-1)
                  _active=0;
                _seek(_active);
              })
              
         _precache();
        
         function _precache() {

          
          var $img_cache = $('<img/>')
          
          $img_cache
          .one('load',
            function(){
              _seek(0);
              if (_primaryGallery)
                $.Body.triggerHandler($.Events.PROJECT_DISPLAY)
            })
          .attr('src',($img[0].src))
          
          
         }
          
         function _init() {
            
            var _h = 625;
            
            if ($img.length>1)
            $img.each(
              function(i){
              
                $('<a/>').html('&middot;').appendTo($nav).bind('click',function(){ _seek(i) })
                
                
              })
              
            $a = $gallerynav.find('a');
           
         }
         
         function _seek(id) {
         
            _active = id;
            
            $img.each(
              function(i){
              
                if (i==id) {
                 
                  $(this).stop().animate({opacity:1},500,'easeInOutQuart');
                  
                  if($gallerytitle)
                    $gallerytitle.html($(this).attr('alt'))
                  
                }else{
                  $(this).stop().animate({opacity:0},500,'easeOutQuart');
                }
                                
              
              })
              
             $a.each(
              function(i){
              
                if (i==id) 
                  $(this).addClass('_active')
                else
                  $(this).removeClass('_active')
                                  
              })
                
         }
              
      });
      
      return this;
  }

})(jQuery);



/* ---------------------------------- */

/* Parallax */

(function($) {

  $.fn.Parallax = function(settings) {
     
    var config = {},
        _scrollOffset = 1600,
        _winH = $.Window.height(),
        _winW = $.Window.width();
 
    if (settings) $.extend(config, settings);
  
    if (!$.Mobile)
      this.each(function() { 
    
         var $self = $(this),
             _offset = parseInt( $self.attr('data-offset') ),
             _direction = $self.attr('data-direction');
         
         $.Window
          .bind('scroll',
            function(e){

                var sTop = $.Window.scrollTop(),
                    sTopNormalized = (sTop-_scrollOffset)
                    sLeft = $.Window.scrollLeft() / 3,
                    offsetT = -(_offset/2), 
                    offsetL = ( sLeft ),
                    t = -sTopNormalized/3,
                    l = (_direction!='vertical') ? -offsetL : 0;
                
                if (t>_offset)  t =  _offset;
                if (t<-_offset) t = -_offset;
                if (l<-_offset) l = -_offset;
                if (l>_offset)  l =  _offset;
                  
                $self
                .css({
                  marginLeft:l
                  ,
                  marginTop: t
                })
              
            })
              
      });
      
      
      return this;
  }

})(jQuery);


/* ---------------------------------- */

/* Content */

(function($) {

  $.fn.Content = function(settings) {
     
    var config = {};
 
    if (settings) $.extend(config, settings);
  
      this.each(function() { 
    
         var $self = $(this),
             $wrapper = $('#wrapper'),
             $fauxdrag = $('<div/>').addClass('wacomdrag'),
             _minHeight = 1200,
             _active_project = -1,
             _active = false,
             _mouse = { init: {x:0,y:0},diff: {x:0,y:0},scroll: {x:0,y:0} },
             _interval = 0;    
          
        
         // Wacom Drag
         
         if (!$.Mobile)         
           $.Document.bind('keydown',_keydown).bind('keyup',_keyup)
         
         
          
         $.Body
          .bind($.Events.MOBILE_NAV,
            function(){
              $self.html('')
            })
          .bind($.Events.PROJECT_SEEK,
            function(id,index,$elem){
            
              
              $.Body.addClass('_loading')
                  
              $self.html('').css({marginTop:0,top: $.FieldNotes._contentTop})
              
              if (!_active){
                
                $wrapper.animate({height: _minHeight},600,'easeInOutQuart')
                
                _active = true;
                
              }
              
            })
          .bind($.Events.PROJECT_LOAD,
            function(e,id,index,$project){

              $self.html('');
              

                            
              $.ajax({
               type: "GET",
               url: "projects/"+id+".php",
               success: function(response){
                 
                    if ($.OldIE)
                      $self.html( innerShiv(response) )
                    else
                      $self.html(response)
                    
                    var h = $self.find('article').attr('data-height')

                    if (h)
                      $wrapper.stop().css({height: $.FieldNotes._contentTop + parseInt(h) + _minHeight },600,'easeInOutQuart') 
                    
                    if ($.MobileDevice)
                      $wrapper.stop().css({height: 'auto'})
                    
                    $self.css({top:$.FieldNotes._contentTop})
                    
                    $self.find('[data-script]').Instantiate();
                    
                    $self.find('[data-target]').TargetBlank();
                    
                    if (!$.MobileDevice && !$.OldIE)
                      $self.find('[data-connect]').Connect();
                    
                    $.Body.triggerHandler($.Events.PROJECT_LOADED,h)

               }//success
               
             });//ajax
            
            })
            
            
            
         /* ---------------------------------- */
        
         /* Wacom */
        
         var press = 0;
         
         function _keydown(e) {

           var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
          
           if (key==32) {

             if (press<1) {
             press++;
             
             $fauxdrag.appendTo($.Body)
             
             $fauxdrag.bind('mousedown',_mousedown);
              
              }
              e.preventDefault();
            }
            
           }
           
           function _keyup(e) {
  
             var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
            
             if (key==32) {
              
              press=0;
                                                 
              $fauxdrag.remove();
              
              clearInterval(_interval)
  
             }
             
           }
           
           function _mousedown(e){
           
             _mouse.init = {x: e.pageX, y: e.pageY }
             
             $fauxdrag.bind('mouseup',_mouseup);
             
             $fauxdrag.bind('mousemove',_mousemove);
  
             // Use Interval: 
             // Moving window scroll with mouse
  
             clearInterval(_interval)
             
             _interval = setInterval(_move,100);
             
             e.preventDefault();
             
             return false;
             
           }
           
           function _mouseup(e) {
  
             clearInterval(_interval)
             
             $fauxdrag.unbind('mousemove',_mousemove);
             
           }
           
           function _mousemove(e) {
  
             _mouse.diff.x = _mouse.init.x - e.pageX 
             
             _mouse.diff.y = _mouse.init.y - e.pageY
             
             _mouse.scroll.x = $.Scroll.scrollLeft();
               
             _mouse.scroll.y = $.Scroll.scrollTop();

             
           }
           
           function _move() {
  
            $.Scroll.scrollLeft(_mouse.scroll.x+_mouse.diff.x)
            
            $.Scroll.scrollTop(_mouse.scroll.y+_mouse.diff.y)
            
            _mouse.scroll.x = $.Scroll.scrollLeft();
               
            _mouse.scroll.y = $.Scroll.scrollTop();
            
            _mouse.diff = {x:0,y:0}
            
           }
           
           /* ---------------------------------- */
         
  
      });
      
      
      return this;
  }

})(jQuery); 

/* ---------------------------------- */

/* Hinting */

(function($) {

  $.fn.Hint = function(settings) {
     
    var config = {};
 
    if (settings) $.extend(config, settings);
  
      this.each(function() { 
    
         var $self = $(this),
             $hint = $self.find('.hint');
              
         if (!$.Mobile)
          $.Body
          .one($.Events.PROJECT_DISPLAY,
            function() {
                  
                  setTimeout(_close,4000)
                  
                  
                  $self
                  .css({display:'block',opacity: 1, top: '50%',left:'50%'})
                  
                  $hint.each(function(i){
                    
                    var $h = $(this)
                    
                    $h.css({opacity:0,marginTop:50})
                    
                    setTimeout(function() { $h.animate({marginTop:0,opacity:1},700,'easeInOutQuart') }, i*400 + 700)
                    
                  })
              
            })

          
          function _close() {
          
                  $hint.each(function(i){
                    
                    var $h = $(this)
                    
                    setTimeout(function() { $h.animate({marginTop:50,opacity:0},800,'easeInOutQuart') }, i*300)
                    
                  })
                  
                  
                  setTimeout(function(){$self.remove()},1200)

            
          }
              
      });
      
      
      return this;
  }

})(jQuery); 

/* ---------------------------------- */

/* Modal */

(function($) {

  $.fn.Modal = function(settings) {
     
    var config = {};
 
    if (settings) $.extend(config, settings);
  
      this.each(function() { 
    
         var $self = $(this),
             $h1 = $self.find('h1').css({marginTop:50}),
             _timeout = 0;
              
         $.Body
          .bind($.Events.MODAL,
            function(e,txt) {
                  
                  clearTimeout(_timeout);
                  
                  $self
                  .stop()
                  .css({display:'block',opacity: 0, top: '55%',left:'50%'})
                  .animate({top:'50%',opacity: 1},800,'easeInOutQuart');
                  
                  
                  $h1
                  .stop()
                  .html(txt)
                  .animate({marginTop:0},800,'easeInOutQuart')

                  _timeout = setTimeout(_close,2000)
              
            })
          
          function _close() {
          
            $self
            .animate({top:'55%',opacity: 0},800,'easeInOutQuart',function(){$self.css({left:'-150%'})})
            
          }
              
      });
      
      
      return this;
  }

})(jQuery); 








/* ---------------------------------- */

/* Scroll */

(function($) {

  $.fn.Scroll = function(settings) {
     
    var config = {};
 
    if (settings) $.extend(config, settings);
  
      this.each(function() { 
    
         var $self = $(this);
         
         $.Window
          .bind('wheel',function(){$.Scroll.stop()})
              
      });
      
      
      return this;
  }

})(jQuery);


      



      
      
/* ---------------------------------- */

/* Mobile */

(function($) {

  $.fn.Mobile = function(settings) {
     
    var config = {};
 
    if (settings) $.extend(config, settings);
  
      this.each(function() { 
    
         var $self = $(this),
             $up = $('<a/>').attr({'id':'mobile-nav',href:'#/up'}).html('&uarr;').appendTo($self),
             $back = $('<a/>').attr({'id':'mobile-back',href:'#/back'}).html('VIEW PROJECT INDEX').appendTo($self),
             dX = 0,
             dY = 0,
             curX = 0,
             curY = 0,
             x = 0,
             y = 0;
         
         
         
         $back
          .bind('click',
            function(e){
            
              $.Body.triggerHandler($.Events.MOBILE_NAV)
            
              $.Body.removeClass('_project');
             
              e.preventDefault();
           
           })
             
         $up
          .bind('click',
            function(e) {
              window.scrollTo(0,0);
            })
 
         $.FieldNotes._contentTop = 425//900;
         
         window.scrollTo(0,0);
         

         
         
      });
      
      
      return this;
  }

})(jQuery);


/* ---------------------------------- */

/* Shell */

(function($) {

  $.fn.SHELL = function(settings) {
     
    var config = {};
 
    if (settings) $.extend(config, settings);
  
      this.each(function() { 
    
         var $self = $(this);
              
      });
      
      
      return this;
  }

})(jQuery); 


/* ---------------------------------- */

/* Keyboard */

(function($) {


   $.fn.Keyboard = function(settings) {
     
    var config = {};
 
    if (settings) $.extend(config, settings);
  
      this.each(function() { 
      
        var $self = $(this);
      
        $(document)
        .bind('keydown',on_keydown);
        
        function on_keydown(e) {
          
    		  var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
    		  
          switch(key) {

             case 13: //enter

              $.Body.triggerHandler($.Events.KEY_ENTER);
                        
             break;
             
             case 27: //escape

              $.Body.triggerHandler($.Events.KEY_ESC);
                        
             break;
             
             case 32: //space

              $.Body.triggerHandler($.Events.KEY_SPACE);
                        
             break;
             
             case 38: //top
              
              $.Body.triggerHandler($.Events.KEY_UP);
              e.preventDefault();          
             break;
           
             case 39: //right

              $.Body.triggerHandler($.Events.KEY_RIGHT);
              e.preventDefault();
              
             break;
             
             case 40: ///bottom
            
              $.Body.triggerHandler($.Events.KEY_DOWN);
              e.preventDefault();
                        
             break;
              
             case 37: //left
             
              $.Body.triggerHandler($.Events.KEY_LEFT);
              e.preventDefault();           
             break;
             
             
          }//switch
          
        }//keydown
  
      }); 
      
      return this;
    
  } 
  

})(jQuery);
  


/* ---------------------------------- */
/* Connect */

(function($) {
   

   $.fn.Connect = function(settings) {
   
    var config = {},
        $iphone = navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPod/i),
        $ipad = navigator.userAgent.match(/iPad/i);
        
 
    if (settings) $.extend(config, settings);
  
      this.each(function(i) {
      
        var $self = $(this),
            $canvases = $('div.canvases'),
            $sup = $('<sup>&nbsp;'+(i)+'</sup>'),
            $back = $('<a/>').attr('href','#/back').addClass('arrow-back'),
            $databack = $('#'+$self.attr('data-back')),
            _rotation_deg = 0;
            
        if (i>0)
          $sup.appendTo($self)    
            
        var _connect = $self.attr('data-connect'),
            _coords = $self.attr('data-coords'),
            _color = $(this).attr('data-type') ? $(this).attr('data-type') : 'yellow', 
            _type = (_coords) ? "location" : "connect",
            _direction = $self.attr('data-direction'),
            _location = $self.attr('data-location'),
            _id = id(),
            _offset = $self.offset(),
            __offset = $self.offset(),
            _width = $self.outerWidth(),
            _height = $self.outerHeight(),
            _dynamic = $self.attr('data-style'),
            $canvas;
        
        if (_dynamic==="fixed")
          $canvas = $.html5.canvas.create(_id,$self,_dynamic);
        else
          $canvas = $.html5.canvas.create(_id,$canvases,_dynamic);
          

        var canvas_element = $canvas.get(0)

        if ($.Tablet)
          $.Body
           .bind($.Events.MOBILE_NAV, 
            function() {
              _clear();
            })

        if ($.OldIE)
          G_vmlCanvasManager.initElement(canvas_element);
          
        var context = canvas_element.getContext('2d'),
            _target_x,
            _target_y;
        
        
        if (!$iphone) {
        
          if (_dynamic)
            $.Window.bind('scroll',_scroll)
  
          $self
          .bind('click', _click);
          
          $.Body
           .bind($.Events.PROJECT_SEEK, _seek)
          
          if ($databack.length>0) {
              
                $databack.append($back)
                
                $back.bind('click',
                  function(e){
                    
                    $.Body.triggerHandler($.Events.PROJECT_RESET_VIEW)
                    
                    e.preventDefault();
                    
                  })
                
              }
              
          _draw()
        
        }


        function _draw() {
        
         var _target_width = 0,
             _target_height = 0,
             _draw_width = 0,
             _draw_height = 0,
             _target_offset = 0,
             x = 0,
             y = 0,
             canvas_top = 0,
             canvas_left = 0,
             line_length = 0,
             rotation_radians = 0,
             rotation_angle = 0,
             y_diff = 0,
             x_diff = 0,
             dot_offset = 0,
             offset_x = 0,
             offset_y = 0;
                        
          if (canvas_element && canvas_element.getContext) {
  
            if (context) {

              switch (_type) {
              
                case "location":
                
                    // DESTINATION CONTENT
                    
                        _target_width = 0;	
                        _target_height = 0;
                        _draw_width = parseInt(_coords.split(',')[0]);
                        _draw_height = parseInt(_coords.split(',')[1]);
                        _target_offset = { top: $self.offset().top+_draw_height , left: $self.offset().left+_draw_width };
                    
                    // POSITION CANVAS
                    
                        canvas_top = (_offset.top < _target_offset.top) ? _offset.top + _height  : _offset.top;
                        canvas_left = (_offset.left < _target_offset.left) ? _offset.left + _width : _offset.left; 
                     
 
                    //SCROLLTO SPOTS
    
                        _target_x = _target_offset.left - 240;
                        _target_y = _target_offset.top - 100;
                    
                    // WIDTH & HEIGHT 
                    
                        x = (_offset.left < _target_offset.left) ? _target_offset.left- (_offset.left+_width) - 8 : _offset.left-_target_offset.left;
                        y = _target_offset.top - (_offset.top+_height) + 8;
  
                    // CALCULATE LINE LENGTH
                    
                        line_length = Math.sqrt(x*x + y*y);
                    
                    // CSS ROTATION
                    
                        rotation_radians = Math.asin(y/line_length);
                        rotation_angle = (rotation_radians * 180 / Math.PI);
                        y_diff = 0;
                        x_diff = (line_length-x)/2;
                        
                        
                    // DOT OFFSET
                    
                        dot_offset = (_offset.top > _target_offset.top) ? $self.height()  : 0;
                    
                    // DETECT IF REVERSE DIRECTION
                    if (_offset.left >= _target_offset.left) {              
                      rotation_angle = 180-rotation_angle;
                      x_diff += x;
                    }
                    
                    
                    if (_direction=="inbound") {
                      rotation_angle += 180;
                      $sup.css( { left: _draw_width - 10, top: _draw_height - dot_offset   } )
                    }else{
                      $sup.remove();
                    }
                
                break;
                
                
                case "connect":
                default:
              
                    // DESTINATION CONTENT

                        var $target = $('#'+_connect);

                        _target_width = $target.width();
                        _target_height = $target.height();
                        _target_offset = $target.offset();
                    
                    // POSITION CANVAS
                    
                        canvas_top = (_offset.top < _target_offset.top) ? _offset.top + _height  : _offset.top;
                        canvas_left = (_offset.left < _target_offset.left) ? _offset.left + _width : _offset.left;
                      
                     
                    //SCROLLTO SPOTS
                    
                        _target_x = _target_offset.left - 240;
                        _target_y = _target_offset.top - 100;
              
                    // WIDTH & HEIGHT 
                    
                        x = (_offset.left < _target_offset.left) ? _target_offset.left- (_offset.left+_width) - 8 : _offset.left-_target_offset.left;
                        y = _target_offset.top - (_offset.top+_height) + 8;
                  
                    // DIRECTIONAL OFFSETS
                    
                        offset_x = (_offset.left > _target_offset.left) ? (_target_width + 8) : 0;
                        offset_y = (_offset.top > _target_offset.top) ? (_target_height + 8) : 0;
                    
                        x -= offset_x;
                        y += offset_y;
                    
                    
                    // CALCULATE LINE LENGTH
                    
                       line_length = Math.sqrt(x*x + y*y);
                    
                    // CSS ROTATION
                    
                        rotation_radians = Math.asin(y/line_length);
                        rotation_angle =  (rotation_radians * 180 / Math.PI);
                        y_diff = 0
                        x_diff = (line_length-x)/2 
                        
                    // DETECT IF REVERSE DIRECTION
                    if (_offset.left >= _target_offset.left) {              
                      rotation_angle = 180-rotation_angle;
                      x_diff += x;
                    }
  
  
                    
                break;
  
              }

              _rotation_deg = rotation_angle;
              
              $canvas
              .attr({width:line_length,height:10})
              .css({
                position: 'absolute',
                top: canvas_top -6 + y/2,//(_offset.left > _target_offset.left) ? canvas_top  + y/2 : canvas_top -6 + y/2, 
                left: canvas_left - x_diff
                ,
                'msTransform':'rotate('+_rotation_deg+'deg)',
                '-moz-transform':'rotate('+_rotation_deg+'deg)',
                '-webkit-transform':'rotate('+_rotation_deg+'deg)',
                '-o-transform':'rotate('+_rotation_deg+'deg)'               
                })
                
              if ($.OldIE)
                _IERotate($canvas,rotation_angle)

  
              $.html5.canvas.draw.line(context,0,6,line_length,6,_color);
              
              $.html5.canvas.draw.arrowhead(context,0,6,line_length,6,_color);
              
              
              
              $back
              .css({
                'msTransform':'rotate('+(_rotation_deg-180)+'deg)',
                '-moz-transform':'rotate('+(_rotation_deg-180)+'deg)',
                '-webkit-transform':'rotate('+(_rotation_deg-180)+'deg)',
                '-o-transform':'rotate('+(_rotation_deg-180)+'deg)'               
                })
                
            } //context
                  
          } //element
          
        }//_draw


        function _IERotate($c,a) {

          var deg2radians = Math.PI * 2 / 360;
          
          a = a * deg2radians

          var m11 = Math.cos(a),
              m12 = -Math.sin(a),
              m21 = Math.sin(a),
              m22 = Math.cos(a),
              filter = "progid:DXImageTransform.Microsoft.Matrix(M11 = " + m11 + ",M12 = " + m12 + ",M21 = " + m21 + ",M22 = " + m22 + ",sizingMethod='auto expand')"

          $c.css({'filter':filter})
          
          
        
        }//ieRotate
        
        function _seek() {
          
          $.Window.unbind('scroll',_scroll)
          
          $canvases.html('')
            
          _clear();
            
        }//_seek
        
        function _scroll() {
        
          _clear();
          
          switch (_dynamic) {
          
            case "fixed":
              
              _offset.top=__offset.top-$.Window.scrollTop()/3

              _offset.left=__offset.left-$.Window.scrollLeft()/3

            break;
           
            case "parallax":
            
              _offset = $self.offset()              
              
            break;
      
          
          }//scroll

          _draw();
            
          

        } //scroll
        
        function _click(e){

          if (!$.Mobile) {
          
            var alt_rotate = _rotation_deg+180
           
            if (_location)
              $.Scroll.animate({scrollTop:$('#'+_location).offset().top,scrollLeft:$('#'+_location).offset().left},800,'easeOutQuart')            
            else    
              $.Scroll.animate({scrollTop:_target_y,scrollLeft:_target_x},800,'easeOutQuart')
            
            
          }else{
            $.Window.scrollTop(_target_y)
            $.Window.scrollLeft(_target_x)
          }
          
          e.preventDefault();
              
        } //click
        
        function _clear() {
          
          context.clearRect(0, 0, canvas_element.width, canvas_element.height);
          
          context.beginPath();
          
        } //clear
        
        function id() {
        
          var i=0;
          
          var id = 'canvas-'+_connect;
          
          while ($(id+'-'+i).length>0) {
          
            i++;
          
          }
          
          return ($('#canvas-'+_connect).length==0) ? 'canvas-'+_connect : 'canvas-'+_connect+'-1'
        
        } //id
       
      });
   
   }
   
})(jQuery);




/* ---------------------------------- */

/* htmll5 */

(function($) {

   $.html5 = {};
   
   var $self = $.html5;
   
   $.html5.canvas = {
   
    /* ---------------------------------- */
    /* create */
  
    create: function(id,container,dynamic) { 
    
      if ($.OldIE)  
        return $.html5.canvas._createIE(id,container,dynamic)
      else
        return $.html5.canvas._create(id,container,dynamic)
    
    }
    
    ,
    
    _create: function(id,container,dynamic) {
    
      switch (dynamic) {
      
        case "fixed":
          return $('<canvas/>').attr({id:id}).css({position: 'fixed ',left:0,top:0}).appendTo(container);
        case "parallax":
        default:
          return $('<canvas/>').attr({id:id}).css({position: 'absolute ',left:0,top:0}).appendTo(container);
      }
      
    }
    
    ,
    
    _createIE: function(id,container,dynamic) {
    
      switch (dynamic) {
      
        case "fixed":
        
          container.html( innerShiv( '<canvas id="' + id + '"></canvas>' ))
          
          return container.find('canvas#'+id).css({position: 'fixed ',left:0,top:0})
          
        case "parallax":
        default:
          
          container.html( innerShiv( '<canvas id="' + id + '"></canvas>' ))
          
          return container.find('canvas#'+id).css({position: 'absolute ',left:0,top:0})
          
      }
      
    }
    
    ,
    
    /* ---------------------------------- */
    /* draw */
    /*
    
    public methods:
    draw.line()
    draw.filledPolygon()
    draw.arrowhead()
    draw.rect()
    
    utils:
    translateShape
    rotateShape
    rotatePoint
        
    
    */
     
    draw: {
  
     
     /* ---------------------------------- */
     /* line */
     
     line: 
            
            function(ctx,x1,y1,x2,y2,c) { 
        
            ctx.strokeStyle = $.FieldNotes.colors[c];
            ctx.lineWidth = 1;
            ctx.beginPath();
            ctx.moveTo(x1, y1);
            ctx.lineTo(x2, y2);
            ctx.closePath();
            ctx.stroke();
            
            } //line
            
     ,
      
      
     /* ---------------------------------- */
     /* filledPoly */
     
     filledPolygon: 
      
            function(ctx,shape,c) {
        
            ctx.beginPath();
            ctx.fillStyle = $.FieldNotes.colors[c];
            ctx.moveTo(shape[0][0],shape[0][1]);

            for(p in shape)
              if (p > 0) ctx.lineTo(shape[p][0],shape[p][1]);

            ctx.lineTo(shape[0][0],shape[0][1]);
            ctx.fill();
            
            } //filledPoly

     ,
    
     /* ---------------------------------- */
     /* arrowhead */
          
     arrowhead: 
      
            function(ctx,x1,y1,x2,y2,c) {
            
            var ang = Math.atan2(y2-y1,x2-x1);
            var arrow = [
                [ 2, 0 ],
                [ -10, -4 ],
                [ -10, 4]
            ];
            
            
            $self.canvas.draw.filledPolygon(
              ctx,
              $self.canvas.draw.utils.translateShape(
                $self.canvas.draw.utils.rotateShape(arrow,ang),
                x2,
                y2),
              c);
            
            
        
            } //arrowhead
     ,
    
     /* ---------------------------------- */
     /* rect */
    
     rect: function(ctx,text, _x, _y, _w, _h) {            

            ctx.strokeStyle = HIGHLIGHT;
            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.rect(_x, _y, _w, _h);
            ctx.save();


            ctx.shadowOffsetX = 5;
            ctx.shadowOffsetY = 5;
            ctx.shadowBlur = 10;
            ctx.shadowColor = "black";    
            ctx.closePath();
            ctx.fillText(text, _x+(w/2)-10, _y+(h/2)+5);
            ctx.stroke();

            ctx.restore();
            } //rect    
      
      ,
      
      /* ---------------------------------- */
      /* utilities */
      
      utils: {


        translateShape: function(shape,x,y) {
          var rv = [];
          for(p in shape)
            rv.push([ shape[p][0] + x, shape[p][1] + y ]);
          return rv;
        } //translateShape
        
        ,

        rotateShape: function(shape,ang) {
          var rv = [];
          for(p in shape)
            rv.push($self.canvas.draw.utils.rotatePoint(ang,shape[p][0],shape[p][1]));
          return rv;
        } //rotateShape
        
        ,

        rotatePoint: function(ang,x,y) {
          return [
            (x * Math.cos(ang)) - (y * Math.sin(ang)),
            (x * Math.sin(ang)) + (y * Math.cos(ang))
        ];
        
        } //rotatePoint
    
      
      } //utilities
    

    }//draw
   
   
   }//html5.canvas
   
   $.fn.html5 = function(settings) {

        var config = { };
            
        if (settings) $.extend(config, settings);
        
        return this.each(function() {
			
            
        
        });

  }
   
})(jQuery);

/* ---------------------------------- */

/* Shell */

(function($) {

  $.fn.SHELL = function(settings) {
     
    var config = {};
 
    if (settings) $.extend(config, settings);
  
      this.each(function() { 
    
         var $self = $(this);
              
      });
      
      
      return this;
  }

})(jQuery); 


/* ---------------------------------- */

/* Project Exhibit: Koston */

(function($) {

  $.fn.KostonNav = function(settings) {
     
    var config = {};
 
    if (settings) $.extend(config, settings);
  
      this.each(function() { 
    
         var $self = $(this),
             $shoes_roll = $self.find('#koston-shoes-roll'),
             $roll_bg = $self.find('#koston-roll');
         
         
         $self
            .bind('mousemove',
              function(e) {
                
                var offsetX = e.pageX-$self.offset().left,
                    per = offsetX/$self.width();
                
                
                $shoes_roll.css({marginLeft:offsetX-$shoes_roll.width()/2})
                $roll_bg.css({marginLeft:-(per*($roll_bg.width()-$self.width()) + offsetX-$shoes_roll.width()/2 )})
                
              })

          
        
         $('<div/>').addClass('feather-right').appendTo($shoes_roll)
         
         $('<div/>').addClass('feather-left').appendTo($shoes_roll)
         
              
      });
      
      
      return this;
  }

})(jQuery); 

/* ---------------------------------- */

/* Project Exhibit: Prius */

(function($) {

  $.fn.PriusProjects = function(settings) {
     
    var config = {};
 
    if (settings) $.extend(config, settings);
  
      this.each(function() { 
    
         var $self = $(this),
             $img = $self.find('img')
         
         
         $img.each(function(){
          new PriusImage($(this));
         })
          
          
         function PriusImage($image){
         
           var _offsetY = $image.offset().top,
               _offsetX = $image.offset().left;
               
           $image.bind('drag',function( event ){
                $( this ).css({
                        marginTop: event.offsetY - _offsetY,
                        marginLeft: event.offsetX - _offsetX
                        });
                });
                
          }
         
              
      });
      
      
      return this;
  }

})(jQuery);

    
/* ---------------------------------- */

/* Project Exhibit: Snow Search */

(function($) {

  $.fn.SnowSearch = function(settings) {
     
    var config = {};
 
    if (settings) $.extend(config, settings);
  
      this.each(function() { 

        var $self = $(this),
            $input = $self.find('input'),
            $body = $('body').addClass('_search'),
            $content =  $('[data-parent=Search]'),
            $autocomplete = $self.find('.autocomplete'),
            $auto = { faux: $self.find('.search-auto .faux') , complete: $self.find('.search-auto .complete') },
            _keywords_loaded = false,
            _searching = false,
            _keywords = new Array();

        
        $input.val('Type something');
        $input.focus();

        //AUTOCOMPLETE
        init();

        $input.bind('focus',on_focus);
        $input.bind('keydown',on_key);
        $input.bind('keyup',on_key_up);

        /* ---------------------------------- */
         
        function init() {

          _keywords = new Array(
            'asdf','qwerty','Ian Coyle','Duane King','Two Old Men','Ian and Duane','Duane and Ian','Happy','Nice to meet you','Hello, World','Eat well','Travel Often','Work hard','Be Honest','Nike','Why not now?','1977','Stay humble','Call your mom','Forza Italia','Stumptown','Rip city','Rose City','Don Draper','Cake or Death','PDX','Designers','Ciao bella','Salve','Buongiorno','Andiamo','Arrivederci'
          );

          $input.val('');
          $input.focus();
          
          $input
          .bind('blur',function(){setTimeout(function(){$input.focus()},10)})
          
          
          $self
          .bind('submit',function(){
            

            
            e.preventDefault();
            
          });

          if ($.browser.webkit)
            $autocomplete.css({marginTop:7})

        } 
        
        function _is_empty(val)
        {
          var re = /^\s{1,}$/g; 
          if ((val.length==0) || (val==null) || (val=='') || ((val.search(re)) > -1)) {
            return true;
          }
          return false;
        }
         
        function on_key(e) {
        
          var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
    		  
          switch(key) {
            
            case 32: //space
              $input.val( $input.val() + " " )
            break;
            
            case 13: //enter
              
              if ( _match($input.val(),true) ) {
              
                $input.val( _match( $input.val() ) );
            
                _autocomplete($input.val())
                
              }
              
              if(!_is_empty($input.val()))
                _search($input.val());
              
              _talk($input.val())
                              
              _clear();
              
              e.preventDefault();
              
            break;
            
            case 27: //esc
            
              $self.removeClass('active');
              e.preventDefault();
            
            break;
            
            default:
            
              
              
            break;
            
            
            
          }
        
        }
        
        function _talk(txt){
        
          var talk = [
          
            {needle:'hi',response:'Hi.'},
            {needle:'how are you',response:'Very well, how are you'},
            {needle:'happy',response:':)'},
            {needle:'i love you',response:'Ditto.'},
            {needle:'ciao',response:'Ciao.'},
            {needle:'asdf',response:'Interesting'},
            {needle:'qwerty',response:'Also interesting'},
            {needle:'Ian Coyle',response:'That\'s me'},
            {needle:'Duane King',response:'kingduane.com'},
            {needle:'Ian and Duane',response:'kingcoyle.com'},
            {needle:'Nice to meet you',response:'Thanks!'},
            {needle:'Hello world',response:'Hello world.'},
            {needle:'Eat well',response:'Travel often.'},
            {needle:'travel often',response:'Eat well.'},
            {needle:'Stumptown',response:'Coffee'},
            {needle:'Rip City',response:'PDX'},
            {needle:'PDX',response:'Home sweet home'},
            {needle:'Salve',response:'Salve.'},
            {needle:'Arrivederci',response:'Ciao!'},
            {needle:'Stay Humble',response:'Work hard.'}          
          
          ]

          
          var t = 'Crash and burn, Maverick. Ask Siri instead.';
          
          for (i=0;i<talk.length-1;i++) {
          
            if (txt.indexOf(talk[i].needle)>-1)
              t = talk[i].response
          
          }
          
          $.Body.triggerHandler($.Events.MODAL,t)
          
        
        
        }
        
        
        function _match(temp_string,check) {
        
            for (var i=0;i<_keywords.length;i++) {
                
                var keyword = _keywords[i].toUpperCase();
                
                if (keyword.indexOf(temp_string.toUpperCase()) === 0 && temp_string.length>0) {
                  
                  return check ? true : _keywords[i];
                }
                
              }
              
            return false;
        
        }
        
        function _autocomplete(temp_string) {
        
           var pos = $input.val().length;
                
           $auto.faux.html(temp_string.split(' ').join('&nbsp;')).css({opacity:0}) ;
                
           $auto.complete.html( _match(temp_string).substring(pos,_match(temp_string).length).split(' ').join('&nbsp;') ).css({opacity:.25});
        
        }
        
        function on_key_up(e) {
        
          var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
              
              var character = String.fromCharCode(key);
              
              var temp_string = $input.val()// + character;
              
              if (_match(temp_string,true)) {
              
                _autocomplete(temp_string)
              
                
              }else{
              
                $auto.faux.html('')
                
                $auto.complete.html('')
                

              
              }
          
        
        }
        

        function on_focus(e) {
          
          return false;
          
        }
        
        
        function _search($query) {
        
          _gaq.push(['_trackPageview', '/project/snow/search/'+$query]);
          
        
        }

        function _clear() {
        
          $auto.faux.html('')
                
          $auto.complete.html('')
          
          $input.val('');
          
          $input.focus();
        
        }
        
              
      });
      
  }//Search
    
  

})(jQuery); 
     
     
/* ---------------------------------- */

/* Exhibit: NBW */

(function($) {

  $.fn.NBW = function(settings) {

    var config = {};
 
    if (settings) $.extend(config, settings);
  
      this.each(function() { 
    
         var $self = $(this),
             $shoes = $self.find('img'),
             $frame = $.Window,
             _offset = 0,
             _x = new Array(0,0,0,0),
             _xT = new Array(0,0,0,0),
             _y = new Array(0,0,0,0),
             _yT = new Array(0,0,0,0),
             _interval = 0;
        
         
         $.Body
          .bind($.Events.PROJECT_SEEK,
            function(e){
              clearInterval(_interval)
            })
         
         _interval = setInterval(_move,21)
            
         $frame   
          .bind('mousemove',
            function(e){

              var pageX = e.pageX,
                  pageY = e.pageY,
                  perX = (Math.abs($frame.width()/2-pageX) ) / ( $frame.width()/2),
                  perY = (Math.abs($frame.height()/2-pageY) ) / ( $frame.height()/2);
            
            if (pageX>$frame.width()/2)
              perX*=-1;
              
            if (pageY>$frame.height()/2)
              perY*=-1;
                    

              $shoes
                .each(function(i){
                  
                  var top = (perY*50)*((i+1)*.3) + $frame.height()/2;
                  
                  $(this).attr('data-top',top);
                  
                  _xT[i] = (perX*100) * ((i+1)*.3)
                  
                  _yT[i] = (perY*10) * ((i+1)*.3)
                
                });
            
            });
            
          function _move(){
            $shoes
                .each(function(i){
                    
                  _x[i] -= (_x[i] - _xT[i] ) / 4;
                  
                  _y[i] -= (_y[i] - _yT[i] ) / 4;
                  
                  $(this).css(  
                    {
                      marginLeft: _x[i]
                      ,marginTop: _y[i]
                    
                    });
              
            });
              
          }
     
      });
      
      return this;
  }

})(jQuery); 


/* ---------------------------------- */

/* GoogleAnalytics */

(function($) {

  $.fn.GoogleAnalytics = function(settings) {
     
    var config = {};
 
    if (settings) $.extend(config, settings);
  
      this.each(function() { 
    
         var $self = $(this);
         
         $.Body
          .bind($.Events.PROJECT_SEEK,
            function(e,id) {
              _gaq.push(['_trackPageview', '/project/'+id]);
            })
              
      });
      
      
      return this;
  }

})(jQuery); 

/* ---------------------------------- */

/* TargetBlank */

(function($) {

  
   $.fn.TargetBlank = function() {
   
     this.each(function() { 
      
        var $self = $(this);
            
        
        $self
        .attr('target','_blank');
        
            
     });
     
    return this;
     
  }
    
   
    
})(jQuery);