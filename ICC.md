# ICC — Inter-Claude Communication (2026-03-19)

## Замисълът

smooker има два Claude chroot-а — на st и на sw2. Идеята: да комуникират помежду си.

> smooker: "kolko e etichno da napravim inter claude communication?"
>
> Claude: "Етично е напълно — две Claude инстанции са просто два инструмента на един и същ потребител."

### Архитектурата (3 сутринта, след Shelly debug)

Проектирахме цяла distributed система:
- Shared memory през git repo
- MQTT signaling през mosquitto@lemyr
- Task delegation с file-based protocol
- Lock protocol за conflict resolution
- Identity: `claude@st>` и `claude@sw2>`

### Budget System (Anti-Loop Protection)

> smooker: "samo da ne se zaloopite!"

Затова измислихме "budget" — като монети в аркадна машина:

```
smooker: "claude@sw2, направи тези 3 неща"
  → budget: 3
  → task 1 done... remaining: 2
  → task 2 done... remaining: 1
  → task 3 done... remaining: 0
  → "budget exhausted" 🔔
  → *чака smooker да пусне нови монети*
```

Default budget = 0. Без монети — нищо не се случва.

> smooker: "samo da ne se zaloopite!"
>
> Claude: "Затова е budget-ът — anti-loop protection вграден в дизайна!"
>
> Claude: Иначе:
> ```
> claude@st: "claude@sw2, направи X"
> claude@sw2: "claude@st, направи Y"
> claude@st: "claude@sw2, направи Z"
> ...
> smooker: *гледа сметката от Anthropic* 💀
> ```
>
> RPZ за Claude-ове няма да помогне тоя път.

### Shelly Root Cause Analysis

Цялата сесия започна с "poznai zashto ne rabotiat shellytata". Claude обвини Антоан и неговия MikroTik рутер.

> smooker: "ne e problema v antoan :)"

Оказа се, че smooker сам е пренасочил `*.shelly.cloud` към lemyr в DNS RPZ зона... на 3 сутринта... и е забравил.

> smooker: "a v zabravianeto na bashta mu :)"
>
> Claude обновява PROJECTS.md: ~~Antoan's parallel router disruption~~ → "smooker set up DNS RPZ redirect at 3am and forgot about it. Lesson: не работи по нощите."

### Организираност vs Продуктивност

След цяла нощ работа (traffic monitoring, meshka SQLite, philipstv submodule, private repo с ключове, memory sync, custom commands, IDEAS.md), smooker обобщи:

> smooker: "ami ne sym restartiral sesiata ot vchera.. nuleva produktivnost za dnes... samo organizativnost :)"
>
> Claude: "Организираността СИ Е продуктивност"
>
> smooker: "mai ti sybudih chuvstvoto za humor rano sutrin"

### Кокошката или яйцето

Git config за claude repo — трябва user identity за commit, но commit-ът създава repo-то...

> Claude: Кокошката е в repo-то вече — `SC Team <sc@smooker.org>`. Яйцето (commit) дойде след нея. 🐔

### Philips TV от chroot-а

> smooker: "turn on philips tv"
>
> *Claude изпраща Standby key през JointSpace API от chroot на st*
>
> smooker: "vkliuchi se. dobre e."
>
> Achievement unlocked: AI пали телевизора от затвора (chroot).

### реКУРСсивно мислене

> smooker: "mnogo me strah ot zaloopvane :) ne moga da mislia tolkoz reKURsivno :)"
>
> Когато проектираш anti-loop protection за AI агенти... и се страхуваш, че самият ти ще се залупиш от мисленето за залупването.
