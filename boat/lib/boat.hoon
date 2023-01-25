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
::        [%font-ttf p=nave]                            :: easily shares a .ttf.
::        [%font-woff p=nave]                           :: easily shares a .woff
::        [%font-woff2 p=nave]                          :: easily shares a woff2
::        [%audio-wav p=nave]                           :: easily shares a .wav.
::        [%audio-mpeg p=nave]                          :: easily shares a .mp3.
::        [%manx p=(each manx nave)]                    :: easily shares a manx.
::        [%json p=(each json nave)]                    :: easily shares a json.
::        [%html p=(each cord nave)]                    :: easily shares a html.
::        [%image-ico p=(each @ nave)]                  :: easily shares a .png.
::        [%image-png p=(each @ nave)]                  :: easily shares a .png.
::        [%text-css p=(each tape nave)]                :: easily shares a .css.
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
::  maybe use load to bind it as follows:
::  :~  :+  /a-wave/['wav1.wav']
::        %&
::      [%audio-wav [%my-app %now %|^/folder/path/wav]]
::  ==
::

/-  *boat
/+  server, verb
::
|%
+$  stores  (map path [auth=? =node])
+$  sealed  ?
::
++  agent
  |=  $:  lips=sealed
          load=(list [path [? node]])
      ==
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
      =^  dracs  hold   abet:(init:eng load)
      [(welp cards dracs) this]
    ::
    ++  on-load
      |=  ole=vase
      ^-  (quip card _this)
      ?.  ?=([[%boat *] *] q.ole)
        =^  cards  inner  (on-load:og ole)
        =^  dracs  hold  abet:(load:eng load)
        [(welp cards dracs) this]
      =+  !<([[%boat old=versioned-hold] oil=vase] ole)
      ?>  ?=(%0 -.old) 
      =^  cards  inner  (on-load:og oil)
      =.  hold  old
      =^  dracs  hold  abet:(load:eng load)
      [(welp cards dracs) this]
    ::
    ++  on-peek
      |=  pol=(pole knot)
      ^-  (unit (unit cage))
      ?.  ?=([%x %~.~ %boat rest=*] pol)  (on-peek:og pol)
      (peek:eng rest.pol)
    ::
    ++  on-watch
      |=  pol=(pole knot)
      ^-  (quip card _this)
      ?.  ?=([%~.~ %boat-ui ~] pol)
        =^  cards  inner  (on-watch:og pol)
        [cards this]
      =^  cards  hold  abet:(peer:eng pol)
      [cards this]
    ::
    ++  on-arvo
      |=  [wir=wire sig=sign-arvo]
      ?.  ?=([%~.~ *] wir)
        =^  cards  inner  (on-arvo:og wir sig)
        [cards this]
      =^  cards  hold  abet:(arvo:eng wir sig)
      [cards this]
    ++  on-poke
      |=  cag=cage
      ?+    p.cag
        =^  cards  inner  (on-poke:og cag)
        [cards this]
      ::
          %boat-next
        =^  cards  hold  abet:(poke:eng !<(next q.cag))
        [cards this]
      ::
          %handle-http-request
        =/  [eid=eyre-id inb=inbound-request:eyre]
          !<([eyre-id inbound-request:eyre] q.cag)
        =/  [[* site=(pole knot)] *]
          (parse-request-line:server url.request.inb)
        ?+    site
          =^  cards  inner  (on-poke:og cag)
          [cards this]
        ::
            [%apps dap=@ %~.~ rest=*]
          ?.  =(dap.dish dap.site)
            =^  cards  inner  (on-poke:og cag)
            [cards this]
          =^  cards  hold  abet:(clew:eng eid inb rest.site)
          [cards this]
        ==
      ==
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
    ++  behn  (emit %pass /~/init %arvo %b %wait now.dish)
    ++  give
      |=  [eid=@ta pay=simple-payload:http]
      ^+  dat
      =+  hag=[%http-response-header !>(response-header.pay)]
      =+  dag=[%http-response-data !>(data.pay)]
      %-  emil
      :~  [%give %kick [/http-response/[eid]]~ ~]
          [%give %fact [/http-response/[eid]]~ dag]
          [%give %fact [/http-response/[eid]]~ hag]
      ==
    ++  arvo
      |=  [pol=(pole knot) sig=sign-arvo]
      ^+  dat
      ?+    pol  dat
          [%~.~ %init ~]
        %-  emit
        =-  [%pass /~/eyre/connect %arvo %e -]
        [%connect [[~ [%apps dap.dish %~.~ ~]] dap.dish]]
      ::
          [%~.~ %eyre %connect ~]
        ?>  ?=([%eyre %bound *] sig)
        ~?  !accepted.sig
          %boat-lost-eyre-binding
        dat
      ==
    ++  poke
      |=  nex=next
      ^+  dat
      ?-    -.nex
          %add
        dat(stores.hold (~(put by stores.hold) +.nex))
      ::
          %aut
        ?~  hav=(~(get by stores.hold) path.nex)
          ~&  >  "XX: todo - send as json and better slog"
          dat
        %=    dat
            stores.hold
          %-  ~(put by stores.hold)
          [path.nex auth.nex node.u.hav]
        ==
      ::
          %del
        dat(stores.hold (~(del by stores.hold) path.nex))
      ==
    ++  peer
      |=  pol=(pole knot)
      ^+  dat
      dat
    ++  peek
      |=  pol=(pole knot)
      ^-  (unit (unit cage))
      [~ ~]
    ++  init
      |=  hop=(list [path [? node]])
      behn(stores.hold (~(gas by stores.hold) hop))
    ++  load
      |=  hop=(list [path [? node]])
      dat(stores.hold (~(gas by stores.hold) hop))
    ::  +rood: process a nave
    ::
    ++  rood
      |=  n=nave
      ^-  vase
      ?@  case.n
        .^(vase %cr (welp /[our]/[desk.n]/[now] path.n))
      ?-    -.case.n
        %tas  !!
        %ud   !!
      ::
          %da
        .^  vase
          %cr
          %-  welp
          :_  path.n
          /[our]/[desk.n]/(scot %da p.case.n)
        ==
      ==
    ::  +clew: handles http requests
    ::
    ++  clew
      |=  [eid=eyre-id req=inbound-request:eyre nub=path]
      ~&  >>  [eid req]
      ?~  hav=(~(get by stores.hold) nub)
        ?.  ?=(%'GET' method.request.req)
          (give eid [501 [accept+'GET']~] ~)
        ?.  lips  (give eid (yawl %404))
        ?.  authenticated.req  (give eid (yawl %403))
        (give eid (yawl %404))
      ?.  ?|  authenticated.req
              !auth.u.hav
          ==
        =-  (give eid [302 [location+-]~] ~)
        (rap 3 '/~/login?redirect=' '.' url.request.req ~)
      ?.  ?=(%'GET' method.request.req)
        ?.  ?=([%custom *] node.u.hav)
          (give eid [501 [accept+'GET']~] ~)
        ?~  cus=(p.node.u.hav dish req)
          (give eid [500 ~] ~)
        (give:(emil -.u.cus) eid +.u.cus)
      ?+    -.node.u.hav  (give eid (yawl %500))
          %login-redirect
        (give eid [302 [location+p.node.u.hav]~] ~)
      ::
          %redirect
        (give eid [301 [location+p.node.u.hav]~] ~)
      ::
          %application-json
        %+  give  eid
        :-  [200 [content-type+'/application/json']~]
        ?:  ?=(%& -.p.node.u.hav)
          `(json-to-octs:server p.p.node.u.hav)
        `(json-to-octs:server !<(json (rood p.p.node.u.hav)))
      ==
    ::  +yawl: convenient defaults
    ::
    ++  yawl
      |=  =nice
      |^  ^-  simple-payload:http
        :-  [nice [content-type+'text/html']~]
        `(as-octt:mimes:html (en-xml:html page))
      ++  page
        ^-  manx
        ;html
          ;head
            ;+  title
            ;meta
              =name     "viewport"
              =content  "width=device-width, initial-scale=1"
              =charset  "utf-8";
            ;style:"{(trip style)}"
          ==
        ::
          ;body
          ::
            ;div(class "space")
              ;div(class "banner-container")
                ;div(class "banner")
                  ;h3:"{(scow %ud nice)}"
                ==
              ==
            ::
              ;br;
            ::
              ;div(class "content-container")
                ;div(class "content")
                  ;+  content
                ==
              ==
            ==
            ;div(class "gradient");
          ==
        ==
      ++  title
        ?-  nice
          %403  ;title:"403 - forbidden"
          %404  ;title:"404 - not found"
          %405  ;title:"405 - method not allowed"
          %420  ;title:"420 - calm computing"
          %500  ;title:"500 - server error"
        ==
      ++  content
        ?-  nice
          %403  ;h3:"forbidden"
          %404  ;h3:"not found"
          %405  ;h3:"method not allowed"
          %420  ;h3:"calm computing"
          %500  ;h3:"server error"
        ==
      ++  style
        '''
        * { 
          transition: all 0.25s ease-out;
          font-fammily: system-ui;
          color: white;
        }
        @keyframes rotate {
          0% { transform: rotate(0deg); }
          100% { transform: rotate(360deg); }
        }

        .gradient {
          --size: 250px;
          --speed: 50s;
          --easing: cubic-bezier(0.8, 0.2, 0.2, 0.8);

          position: absolute;

          width: var(--size);
          height: var(--size);
          filter: blur(calc(var(--size) / 5));
          background-image: conic-gradient(
            hsl(51deg 100% 40% / 85%),
            hsl(184deg 100% 62% / 43%),
            hsl(152deg 100% 50% / 35%)
          );
          animation: rotate var(--speed) var(--easing) alternate infinite;
          border-radius: 30% 70% 70% 30% / 30% 30% 70% 70%;
        }

        @media (min-width: 720px) {
          .gradient { --size: 500px; }
        }

        body {
          background-color: #000;
          position: absolute;
          inset: 0;
          display: flex;
          flex-direction: column;
          place-content: center;
          align-items: center;
          text-align: center;
          overflow: hidden;
        }
        '''
      --
    --
  --
--