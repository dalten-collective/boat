::  boat - set sail with boat
::  by quartus
::
::  v.0.1.0
::  todo list:
::  - state upgrade to manage sites as well as paths
::
::  boat's bowl is called dish
::  boat's state is called hold
::
::  boat makes using urbit as a website backend easier.
::
::  with boat, you can store a map of url paths to nodes
::  where a node is a resource you specify.
::
::  nodes can be any of the following shapes:
::  +$  node
::    $%  [%custom p=custom]                            :: use a custom function
::        [%redirect p=cord]                            :: redirects the browser
::        [%login-redirect p=cord]                      :: log in, then redirect
::        [%manx p=(each manx nave)]                    :: easily shares a manx.
::        [%json p=(each json nave)]                    :: easily shares a json.
::        [%html p=(each cord nave)]                    :: easily shares a html.
::        [%image-png p=(each @ nave)]                  :: easily shares a .png.
::        [%audio-wav p=(each @ nave)]                  :: easily shares a .wav.
::        [%text-plain p=(each tape nave)]              :: easily shares a .txt.
::        [%text-javascript p=(each tape nave)]         :: easily shares some js
::    ==
::
::  note that a `nave` is like a `beam` but local and
::  it comes with an easy case of `%now`
::  +$  nave  [=desk case=$@(%now case) =path]
::
::  please note that the url paths you provide should be
::  just the last portion of the url, assuming all http
::  traffic will be to urls starting with /apps/[dap.bowl]
::
::  if you want to bind /apps/[my-app]/a-wave/wav1.wav
::  to be publicly accessible and point to a wave file
::  that you are storing as a file in clay you would
::  maybe use seed to bind it as follows:
::  :~  :+  /a-wave/['wav1.wav']
::        %&
::      [%audio-wav [%my-app %now /folder/path/wav]]
::  ==
::

/-  *boat
/+  server, verb
::
|%
+$  stores  (map path [auth=? =node])
::
++  agent
  |=  seed=(list [path [auth node]])
  ^-  $-(agent:gall agent:gall)
  |^  agent
  ::
  +$  card  card:agent:gall
  +$  versioned-hold  $%(hold-0)
  +$  hold-0  [%0 =stores]
  ++  agent
    |=  inner=agent:gall
    =|  hold-0
    =*  hold  -
    %+  verb  &
    ^-  agent:gall
    |_  dish=bowl:gall
    +*  this  .
        og    ~(. inner dish)
        eng   ~(. motor dish hold ~)
    ::
    ++  on-fail
      |=  [term tang]
      ^-  (quip card _this)
      =^  cards  inner  (on-fail:og +<)
      [cards this]
    ::
    ++  on-leave
      |=  path
      ^-  (quip card _this)
      =^  cards  inner  (on-leave:og +<)
      [cards this]
    ::
    ++  on-agent
      |=  [wire sign:agent:gall]
      ^-  (quip card _this)
      =^  cards  inner  (on-agent:og +<)
      [cards this]
    ::
    ++  on-save  !>([[%boat hold] on-save:og])
    ::
    ++  on-init
      ^-  (quip card _this)
      =^  cards  inner  on-init:og
      =^  dracs  hold   abet:(loit:eng seed)
      [(welp cards dracs) this]
    ::
    ++  on-load
      |=  ole=vase
      ^-  (quip card _this)
      ?.  ?=([[%boat *] *] q.ole)
        =^  cards  inner  (on-load:og ole)
        =^  dracs  store  abet:(loit:eng seed)
        [(welp cards dracs) this]
      =+  !<([[%boat old=versioned-store] oil=vase] ole)
      ?>  ?=(%0 -.old) 
      =^  cards  inner  (on-load:og oil)
      =.  hold  old
      =^  dracs  hold  abet:(loit:eng seed)
      [(welp cards dracs) this]
    ::
    ++  on-peek
      |=  pol=(pole knot)
      ^-  (unit (unit cage))
      ?.  ?=([%x %~.~ %boat rest=*])  (on-peek:og pol)
      (peek:eng rest.pol)
    ::
    ++  on-watch
      |=  pol=(pole knot)
      ^-  (quip card _this)
      ?:  ?=([%~.~ %boat-ui ~] pol)
        =^  cards  hold  abet:peer:eng
        [cards this]
      =^  cards  inner  (on-watch:og pol)
      [cards this]
    ::
    ++  on-arvo
      |=  [wir=wire sig=sign-arvo]
      ?.  ?=([%~.~ *] pol)
        =^  cards  inner  (on-arvo:og wir sig)
        [cards this]
      =^  cards  hold  abet:(arvo:eng pol sig)
      [cards this]
    ++  on-poke
      |=  cag=cage
      ?.  ?=(%boat-next p.cag)
        =^  cards  inner  (on-poke:og cag)
        [cards this]
      =^  cards  hold  abet:(poke:eng !<(next q.cag))
      [cards this]
    --
  ++  motor
    |_  [dish=bowl:gall hold=hold-0 dek=(list card)]
    +*  dat  .
        our  (scot %p our.dish)
        now  (scot %da now.dish)
    ++  emit  |=(=card dat(dek [card dek]))
    ++  emil  |=(lac=(list card) dat(dek (welp lac dek)))
    ++  abet  ^-((quip card _hold) [(flop dek) hold])
    ++  show  |=(cage (emit %give %fact [/~/boat-ui]~ +<))
    ++  arvo
      |=  [pol=(pole knot) sig=sign:arvo]
      dat
    ++  poke
      |=  nex=next
      dat
    ++  peer  dat
    ++  peek
      |=  pol=(pole knot)
      [~ ~]
    --
  --