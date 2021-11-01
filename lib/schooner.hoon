::
::  schooner is a hoon library intended to de-clutter raw http handling
::  in gall agents.
::
::  It expets to receive a [=eyre-id =(list header) =http-status] all of
::  which are conveniently defined below
::
/+  server
|%
+$  eyre-id  @ta
+$  header  [key=@t value=@t]
+$  resource  $%([%manx m=manx] [%json j=json] [%plain p=tape] [%none ~])
+$  http-status
  $%  [%'200' head=(list header) return=resource]
      [%'201' head=(list header) return=resource]
      [%'204' head=(list header) ~]
      [%'301' head=(list header) return=resource]
      [%'302' head=(list header) return=resource]
      [%'307' head=(list header) type=?(%auth %move) redirect=cord]
      [%'401' head=(list header) ~]
      [%'404' head=(list header) error-msg=resource]
      [%'500' head=(list header) error-msg=resource]
  ==
++  response
  |=  [=eyre-id =http-status]
  ^-  (list card:agent:gall)
  %+  give-simple-payload:app:server
  eyre-id
  ^-  simple-payload:http
  ?+  -.http-status  !!
      %'200'
    (return-200 head.http-status return.http-status)
      %'307'
    (return-307 head.http-status type.http-status redirect.http-status)
      %'404'
    (return-404 head.http-status error-msg.http-status)
  ==
++  return-200
  |=  [head=(list header) data=resource]
  ^-  simple-payload:http
  ?+  -.data  !!
      %manx
    :-  :-  200  
      (weld ['content-type'^'text/html']~ head)
    `(as-octt:mimes:html (en-xml:html m.data))
      %json
    :-  :-  200
      (weld ['content-type'^'text/html']~ head)
    `(as-octt:mimes:html (en-json:html j.data))
  ==
++  return-307
  |=  [head=(list header) type=?(%auth %move) redirect=cord]
  =-  [[307 (weld ['location'^-]~ head)] ~]
  ?-  type
      %auth
    %^  cat  3
      '/~/login?redirect='
    redirect
      %move
    redirect
  ==
++  return-404
  |=  [head=(list header) data=resource]
  :-  [404 head]
  ?+  -.data  !!
      %manx
    `(as-octt:mimes:html (en-xml:html m.data))
      %plain
    `(as-octt:mimes:html p.data)
      %none
    ~
  ==
--



