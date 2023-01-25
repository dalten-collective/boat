::  this is being depricated actively - do not use
::
::  schooner is a hoon library intended to de-clutter raw http handling
::  in gall agents.
::
::  It expets to receive a [=eyre-id =http-status =headers =resource]
::  which are conveniently defined below. 
::
/+  server
::
|%
::
+$  eyre-id  @ta
+$  header  [key=@t value=@t]
+$  headers  (list header)
::  $node: what exists at that node?
::
+$  node
  $%  
    [%manx p=manx]
    [%json p=json]
    [%html p=cord]
    [%image-png p=@]
    [%audio-wav p=@]
    [%redirect o=cord]
    [%text-plain p=tape]
    [%login-redirect l=cord]
    [%text-javascript p=tape]
  ==
::  $nice: conveninently included fail
::
+$  nice  ?(%500 %405 %404 %403 %420)
::
+$  http-status
  $?  %100  %101  %102  %103
    ::
      %200  %201  %202  %203
      %204  %205  %206  %207
      %208  %226
    ::
      %300  %301  %302  %303
      %304  %305  %306  %307
      %308
    ::
      %401  %402  %403  %404
      %405  %406  %407  %408
      %409  %410  %411  %412
      %413  %414  %415  %416
      %417  %418  %421  %422
      %423  %424  %425  %426
      %428  %429  %431  %451
    ::
      %500  %501  %502  %503
      %504  %505  %506  %507
      %508  %510  %511
    ::
      %420
  --
::
::
++  boat
  |_  $:  eid=eyre-id
          hat=http-status
          hed=headers 
          bod=(unit node)
      ==
  +*  bo  .
  ++  bo-open  |=(e=eyre-id bo(eid e))
  ++  bo-nice  |=(h=nice bo(hat h, bod ~))
  ++  bo-abet
    ?:  &(?=(nice hat) =(~ bod))
      bo-stock
    =*  gib  (cury give-simple-payload eid)
    =+  fal  bo-stock(hat 500, bod ~)
    ?~  bod   (gib [[hat hed] bod])
    ^-  simple-payload:http
    =+  body=(need bod)
    ?-    -.body
      %redirect  [[hat location+p.body^hed] ~]
    ::
        %manx
      %-  gib
      :-  [hat content-type+'text/html'^hed]
      `(as-octt:mimes:html (en-xml:html p.body))
    ::
        %json
      %-  gib
      :-  [hat content-type+'application/json'^hed]
      `(as-octt:mimes:html (en-json:html p.body))
    ::
        %html
      %-  gib
      :-  [hat content-type+'text/html'^hed]
      `(as-octs:mimes:html p.body)
    ::
        %image-png
      :-  [hat content-type+'image/png'^hed]
      `(as-octs:mimes:html p.body)
    ::
        %audio-wav
      :-  [hat content-type+'audio/wav'^hed]
      `(as-octs:mimes:html p.body)
    ::
        %text-plain
      :-  [hat content-type+'text/plain']
      `(as-octt:mimes:html p.body)
    ::
        %login-redirect
      =-  [[hat location+-^hed] ~]
      (cat 3 '/~/login?redirect=' p.body)
    ::
        %text-javascript
      :-  [hat content-type+'text/javascript']
      `(as-octt:mimes:)
    ==
    
      

  ^-  (list card:agent:gall)
  %+  give-simple-payload:app:server
    eyre-id
  ^-  simple-payload:http
  ?-  -.resource
      %manx
    :-  :-  http-status
      (weld headers ['content-type'^'text/html']~)
    `(as-octt:mimes:html (en-xml:html m.resource))
    ::
      %json
    :-  :-  http-status
        %+  weld  headers
        ['content-type'^'application/json']~
    `(as-octt:mimes:html (en-json:html j.resource))
    ::
      %login-redirect
    =+  %^  cat  3
      '/~/login?redirect='
    l.resource
    :_  ~
    :-  http-status
    (weld headers [['location' -]]~)
    
    ::
      %redirect
    :_  ~
    :-  http-status
    (weld headers ['location'^o.resource]~)
    ::
      %plain
    :_  `(as-octt:mimes:html p.resource)
    :-  http-status
    (weld headers ['content-type'^'text/html']~)
    ::
      %none
    [[http-status headers] ~]
    ::
      %stock
    (stock-error headers http-status)
    ::
  ==
::
++  stock-error
  |=  [=headers code=@ud]
  ^-  simple-payload:http
  :-  :-  code
  (weld headers ['content-type'^'text/html']~)
  :-  ~
  =+  (title-content code)
  %-  as-octt:mimes:html
    %-  en-xml:html
  ;html
    ;head
      ;title:"{-.-}"
      ;meta(name "viewport", content "width=device-width, initial-scale=1", charset "utf-8");
      ;style:"{(trip style)}"
    ==
    ;body
      ;span(class "blur-banner")
        ;h2:"{-.-}"
        ;p:"{+.-}"
      ==
    ==
  ==
::
++  title-content
  |=  status=@ud
  ~&  status
  ?+  status
    :-  "500 Error - Internal Server Error" 
    ;:  weld  "This urbit is experiencing presence. "
      "You might try back later, or ask again. "
      "Sorry for the inconvenience."
    ==
    ::
      %403
    :-  "403 Error - FORBIDDEN!"
    ;:  weld  "Another one of them new worlds. "
      "No beer, no women, no pool partners, nothin'. "
      "Nothin' to do but throw rocks at tin cans, and we have to bring our own tin cans."
    ==
    ::
      %404
    :-  "404 Error - Page Not Found"
    %+  weld  "You've attempted to access absence. "
    "Impossible. Try a different path. Sorry for the inconvenience."
    ::
      %405
    :-  "405 Error - Method Not Allowed"
    %+  weld  "Something went wrong with your request. "
    "You should probably just go back. Sorry for the inconvenience."
    ::
  ==
::
++  style
  '''
  .blur-banner { 
    position: relative; 
    top: 60%; 
    left: 0%; 
    right: 0%; 
    bottom: 0%; 
    height: auto; 
    width: 80%; 
    padding: 15px 15px 15px 15px; 
    margin: 0px auto 0px auto; 
    display: block; 
    background: rgba(255, 255, 255, 1.0); 
    font-size: 14pt; 
    color: #997300; 
    font-family: Menlo, Consolas, Monaco, "Lucida Console", monospace; 
    border: 6px #997300 dashed; 
    border-radius: 20px; 
    filter: blur(2px) sepia(25%) brightness(100%) saturate(173%); 
    -webkit-filter: blur(1.5px) sepia(25%) brightness(100%) saturate(175%); 
    -moz-filter: blur(1.5px) sepia(25%) brightness(100%) saturate(175%); 
    -ms-filter: blur(1.5px) sepia(25%) brightness(100%) saturate(175%); 
    -o-filter: blur(1.5px) sepia(25%) brightness(100%) saturate(175%); 
  }
  '''
--