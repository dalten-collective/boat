|%
::
+$  eyre-id  @ta
+$  header  [key=@t value=@t]
+$  headers  (list header)
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
  ==
::  $custom: roll your own response function
::
+$  custom
  $-  [bowl:gall inbound-request:eyre]
  (quip card:agent:gall (unit simple-payload:server))
::  $nave:
::
::    like a beam but local and easier
::    https://en.wikipedia.org/wiki/nave
::
+$  nave  [=desk case=$@(%now case) =path]
::  $node: what exists at that node?
::
+$  node
  $%  [%custom p=custom]                                :: use a custom function
      
    ::
      [%redirect p=cord]                                :: redirects the browser
      [%login-redirect p=cord]                          :: log in, then redirect
    ::
      [%manx-marl p=(each manx marl)]                   :: easily shares a manx.
    ::
      [%font-ttf p=nave]                                :: easily shares a .ttf.
      [%font-woff p=nave]                               :: easily shares a .woff
      [%font-woff2 p=nave]                              :: easily shares a woff2
    ::
      [%audio-wav p=nave]                               :: easily shares a .wav.
      [%audio-mpeg p=nave]                              :: easily shares a .mp3.
    ::
      [%image-ico p=(each @ nave)]                      :: easily shares a .png.
      [%image-png p=(each @ nave)]                      :: easily shares a .png.
      [%text-css p=(each cord nave)]                    :: easily shares a .css.
      [%text-html p=(each cord nave)]                   :: easily shares a html.
      [%text-plain p=(each cord nave)]                  :: easily shares a .txt.
      [%text-javascript p=(each cord nave)]             :: easily shares some js
      [%application-json p=(each json nave)]            :: easily shares a json.
  ==
::  $nice: conveninently included fail
::
+$  nice  ?(%500 %405 %404 %403 %420)
::  $next: commands for boat
::
+$  next
  $%  [%add =path auth=? =node]
      [%aut =path auth=?]
      [%del =path ~]
  ==
--