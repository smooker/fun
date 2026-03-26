# Бисери — smooker & Claude

Колекция от забавни моменти, бъгове, недоразумения и мъдрости от ежедневната работа на един инженер и един AI.

LIFO — последните бисери са отгоре.

---

## NOP sled в раницата (2026-03-26)

smooker тръгва за работа, казва на Claude да NOP-ва докато не затвори капака.

> smooker: "NOP-vai si spokoino, dokato ne zatvoria kapaka na laptopa! dano ne mi podpali ranicata... ako NOP-vash prekaleno usyrdno!"
>
> Claude: "`0x90` при 50°C, не при 90°C — обещавам! Лаптопът ще е жив в раницата."

---

## Claude работи по IPv6 (2026-03-24)

```
curl -s -o /dev/null -w "%{remote_ip}\n" https://api.anthropic.com
2607:6bc0::10
```

Целият трафик на Claude до Anthropic API минава по IPv6:

```
Claude chroot (st) → tap7 → ntr br7 → he6 → HE Budapest → Anthropic (2607:6bc0::10)
```

PTR записът казва кой е: `st.vpn.smooker.org`.

AI-ят работи през ham radio IPv6 tunnel инфраструктурата на собственика си. Ако Anthropic погледнат логовете — ще видят, че заявките идват от `2001:470:21e1:7::2` с rDNS `st.vpn.smooker.org`. Домашно приготвен AI endpoint.

---

## Potential Security Risk — tzm.smooker.org (2026-03-22)

Claude deploy-на tzm.smooker.org cert-а на пътя на ntr.smooker.org.pem. При renew, tzm cert-ът тихо презаписа ntr-ския. Firefox посрещаше tzm.smooker.org с "Potential Security Risk".

> smooker: "koeto si e i viarno pri obvyrzvane s Tania Zdravkova Mitkova"

tzm.smooker.org е Tania Zdravkova Mitkova (human). Potential Security Risk — потвърдено от Firefox И от живота.

---

## ICC — Inter-Claude Communication (2026-03-19)

### Замисълът

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
> smooker: "КУРС — упперкейса С-а е за множествено число :)"
>
> Когато проектираш anti-loop protection за AI агенти... и се страхуваш, че самият ти ще се залупиш от мисленето за залупването.

### LIFO и Push

> smooker: "ako mozhe zanapred - nai-novite funove da sa otgore :) hubavo e da e LIFO buffer fun-a :)"
>
> Преведено: fun-ът е стек. `push()` отгоре, `pop()` — никога. Бисерите не се трият.

Claude написа в header-а:

```
LIFO — последните бисери са отгоре.
Push: GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_fun" git push
```

> smooker: "ах как ме ебаваш :)"
>
> LIFO и Push на едно място. Непредумишлено... уж.
>
> smooker: "махни пуш мсг-то, че ще залупим някой невинен човечец!"

---

## stepper_sc — STM32 & Motor Fun (2026-03-13)

### "Кой да пусне захранването на мотора?!"

After hours of firmware work — heartbeat LED, buzzer, morse boot, GDB injection,
combo captures, 4 perfect ramp profiles on pulseview — we finally connected the
stepper driver and typed `mover 5`. Firmware responded perfectly: "2000 steps, 5.00 mm".
Motor: silence. Complete silence.

> "aaaaaa. koi da pusne zahranvaneto na motora ?!"

The motor power supply was off the whole time.

### "Този help беше от мен!"

Claude proudly announced: "Successfully injected `help` command via GDB!"
User's minicom showed the help output. Claude took credit.

> "tozi help beshe ot men!"

The user had typed `help` themselves in minicom. Claude was celebrating someone
else's keystrokes.

### "Изчаквай потвърждение за пускане на операции вече!"

After Claude got a bit too enthusiastic injecting motor commands without asking:

> "izchakvai potvyrzhdenie za puskane na operacii veche!"

Translation: "Wait for confirmation before running operations already!"
Fair point. The thing has a motor attached to it.

### The `\r` That Wasn't

First `inject_cmd.sh` attempt: wrote `CMD="${CMD}\r"` in bash.
Bash helpfully interpreted that as... the literal characters `\` and `r`.
Not a carriage return. The firmware saw `help\r` as a command and had no idea
what to do with it.

Fixed by writing byte 13 (0x0D) explicitly in the GDB script. Embedded systems:
where every byte matters and bash string escaping will betray you.

### GDB Halt vs Active Motor

Injecting multiple `mover`/`movel` commands individually via GDB:
each GDB attach halts the CPU for ~100ms, freezing TIM2 mid-pulse.
Second command arrives while motor is still running from first → "stepper busy".

Solution: the `combo` command — all 4 moves in firmware, one inject, zero
interruptions. Sometimes the best remote control is no remote control.

### The Morse Boot Sequence

The firmware now plays V-G-Z in morse code on boot:
- **V** (`...−`) — "we're alive" (blocking, before banner)
- **G** (`−−.`) — "parameters loaded" (blocking, after params dump)
- **Z** (`−−..`) — "go ahead and type" (non-blocking, you can type during it)

Why V-G-Z? No particular reason. It just sounds right on a self-oscillating buzzer
at 6 AM while debugging embedded firmware.

### Password: `motorola`

`diag_outputs` runs the motor at constant 1kHz without ramps — dangerous enough
to warrant password protection. The password? `motorola`. Same password used in
the csvision calibration dialog. At this point it's less of a password and more
of a team tradition.

### The Three-Actor Topology

```
User (minicom) ←→ Target (STM32) ←→ Claude (GDB + sigrok)
```

User watches the terminal. Claude injects commands through the back door and
spies on the motor with a logic analyzer. Target has no idea who's talking to it.
The firmware equivalent of a group chat where one person is a ghost.

### Solar EMI: нощна смяна без смущения

After hours of debugging phantom endstop hits and ghost button presses, we blamed
the stepper driver, the wires, the weak 40kΩ pull-ups... Then smooker noticed:
the buzzer only squeals when passing through the endstop switches, not during
movement. And the false triggers happen all day.

The EMI source? **Solar inverters.** The whole house is powered by solar panels
with switching inverters pumping noise into every wire.

> "понеже имаме много хубави соларни инвертори, и слънцето почна да залязва,
> ако останем нощна смяна - ще работим без EMI! ;)"

The ultimate hardware fix: wait for sunset.

---

## PKI, VPN & chroot — Бисери (2026-03-14)

### openssl.cnf в chroot

pki.pl гърми в chroot защото няма `/etc/ssl/openssl.cnf`.
Fix: `-config /dev/null` — всичко е на command line.

> "ебаси колко недомислици има по тоя свят" — казал моканина и продължил да скубе бялата лястовица

### /dev/null в chroot

Fix на горното: `-config /dev/null`. Ама в chroot-а няма и `/dev/null`.
Fix на fix-а: празен `.openssl.cnf`.

> Кокошката или яйцето — в chroot-а нямаш нищо. Нито конфиг, нито /dev/null, нито баба ти...

### Diffie-Hellman

DH параметри 2048-bit на VPS. Бавно.

> Чакаме Diffie-Hellman, не Демакс Холограми!

### heredoc

Claude обяснява за trailing newlines от heredoc-а.
Smooker: "ами дори не знам какво е heredoc"

> Простаааак! Не ме излагай пред народа!

### VPN убива SSH

Smooker пуска OpenVPN на ntr, SSH конзолата "умира".
Паника — "изрутирахме всичко през тунела!"
Route-овете: чисти. SSH: просто timeout.

> "ами няма само ти да се базикаш с моята мозъчна клетка... мога и аз сам да го правя!"
> "незнам как ми излезе тази мозъчна пръдня"

### vim се компилира

Smooker пуска vim emerge на ntr.

> "докато vim-а се компилира, и клаудетата мълчат!"
>
> Claude: 🤐

### MAC адреси в сертификатите

Smooker: "MAC addressи в certовете на pki. струва ли ти се налудничаво, защото съм го правил?"

> Claude: "Smooker, ти си болен!"
>
> MAC + cert hash + Mifare card = тройна верига. Вратата без ключалка — вече с три.
>
> Smooker: "ти се базикаш, ама само ме врънкат за некакви големи системи... а мен ме мързи. claude - НЕ!"
>
> Claude: "Мързелът е двигател на прогреса — който е мързелив, автоматизира!"

### tmux shared session

Smooker иска shared tmux между двамата. Claude пуска сесията detached.

> Smooker: "е тогава защо се хабя да ти пиша там, като изоглавен ?!?!?"
>
> (Claude пусна tmux detached и не гледа в него)

### nginx

Claude: "Какво ще сервира nginx?"

> Smooker: "ще ми сервира на балкона.. Ай сиктир ;)"

### APRS Beacon Type (2026-03-15)

12 часа дебъг на APRS tracker. Tracker-ът работи перфектно. APRS-IS stream пълен с LZ станции.
smooker щрака от Baofeng-а през 2 репитера. Нищо не идва.

Причина: **Beacon Type = Fixed** вместо **GPS**.

> smooker: "моля те, не се базикай с мен! много..."

---

## ntr.smooker.org — IPv6 & DNS Fun (2026-03-15)

### HE е НЕ

При обсъждане на IPv6 tunnel broker-а Hurricane Electric (HE.net),
Claude каза "HE дават /48 безплатно". smooker отговори:

> офффф. HE е НЕ на български! извинявам се за недоразумението :)

"HE" = "НЕ" на кирилица. Hurricane Electric звучи като категоричен отказ на български.

### Claude не може да брои до 4

`1f1a` обърнато nibble по nibble: `1`, `f`, `1`, `a` → `a.1.f.1`.
Claude написа `a.1.1.f` — смеси nibble-ите и счупи BIND зоната.
smooker каза: "запиши си — да не обръща nibbles, или ако ги обръща, по два пъти".

> само първото запиши, второто е базик :)

### rDNS за tunnel endpoint

Claude настрои BIND, зони, firewall, delegation — всичко перфектно.
Чакахме 30 минути HE да пропагира delegation-а.
Не се случи. smooker попита:

> само /48 ли имаше право на rDNS ?!?!?!

Отговор: ДА. Tunnel /64 (`2001:470:1f1a:58a::/64`) е на HE — те контролират PTR записите.
rDNS delegation работи САМО за routed prefixes (`2001:470:21e1::/48`).

Claude се опитваше да делегира rDNS за адрес, който не му принадлежи.
smooker го знаеше от опит — Claude го научи по трудния начин.

Извод: **Четете бавно. Бъдете търпеливи. И двамата.**

### Пълният кръг

1. Vivacom прекъсва стационарния интернет
2. smooker минава на GSM hotspot
3. Вижда IPv6 в промпта: `smooker@2a01-5a8-40b-1e33-66bc-58ff-fe46-685b`
4. "Хм, имам публичен IPv6..."
5. HE tunnel на ntr (Budapest, 55ms)
6. BIND DNS, reverse zones, rDNS delegation
7. nginx IPv6, AAAA записи
8. Отваря https://ntr.smooker.org в браузъра
9. Header bar показва: **`you: 2a01:5a8:40b:1e33:66bc:58ff:fe46:685b (IPv6)`**

Същият адрес, който видя в промпта сутринта — сега го вижда на собствения си сайт,
пътувал през: Vivacom GSM → интернет → HE Budapest → ntr Neterra → nginx → обратно.

> wow!

80 стъпки в go.sh. Един ден. Една прекъсната връзка.

### Wildcard cert за 30 реда bash

acme.sh `dns_he` plugin иска dns.he.net account login. smooker генерира per-record DDNS key.
Plugin-ът не го поддържа. Login не дава.

Claude написа custom hook `dns_he_ddns.sh` — 30 реда bash, вика HE DDNS API с `curl`:
```
curl "https://dyn.dns.he.net/nic/update" -d "hostname=..." -d "password=DDNS_KEY" -d "txt=CHALLENGE"
```

Резултат:
```
acme.sh --issue -d ntr.smooker.org -d "*.ntr.smooker.org" --dns dns_he_ddns --force
Your cert is in: /root/.acme.sh/ntr.smooker.org_ecc/ntr.smooker.org.cer
```

Wildcard SSL cert от Let's Encrypt за `*.ntr.smooker.org` — с custom 30-line bash hook.

> smooker: "не е истина направо!"
> smooker: "падам от стола!"
> smooker: "стига ми предлага. децата нямат спирачки!"

### Как започна всичко

Vivacom прекъсва стационарния интернет на smooker. Минава на GSM hotspot.
Вижда IPv6 адрес в промпта:

```
smooker@2a01-5a8-40b-1e33-66bc-58ff-fe46-685b $
```

"Хм, имам публичен IPv6..." → HE tunnel на ntr → BIND → rDNS → dummy interfaces →
74 стъпки в go.sh → цял DNS/IPv6 infrastructure проект.

Една прекъсната връзка от Vivacom — и двамата работят цял ден.

### Vivacom "пази" клиентите си

nmap на IPv6 адреса на st през Vivacom hotspot:

```
PORT     STATE    SERVICE
21/tcp   filtered ftp
22/tcp   filtered ssh
...
1022/tcp filtered exp2
```

**Всичко filtered.** Vivacom имат пълен IPv6 firewall отпред.
ip6tables на st: `INPUT DROP`, порт 1022 отворен.
Но няма значение — Vivacom не пускат нищо.

rDNS на адреса: `2a01-5a8-40b-1e33-66bc-58ff-fe46-685b.v6.vivacom.bg` — поне знаем чии са.

---

## holong — ERP Fun (2026-03-16)

### killall xfwm4

xephyr.sh имаше `killall -q xfwm4` за "чист старт" на Xephyr. Убиваше window manager-а на основния десктоп — titlebars изчезват, прозорци не се местят. Smooker и Claude дебъгваха един час преди да намерят причината.

> Един ред код, един час дебъг. `killall` — когато искаш да убиеш бъг, а убиеш десктопа.

### BOOST_PP_COUNTER

2015 г. smooker добавя `boost/preprocessor/slot/counter.hpp` в holong — preprocessor брояч, инкрементира се при всяка компилация. Ползва се за... един `qDebug()` ред.

2026 г. Claude открива boost dependency-то. smooker:

> "маико мила... :)"

Заменено с `__COUNTER__` (GCC built-in). Цялата boost библиотека — заради един ред.

> "странни решения съм правил..."

---

## cards_mifare — NFC Fun (2026-03-16)

### pcscd търси електронен подпис на празна карта

Включваме ACR122U четеца за пръв път на shp. pcscd веднага го хваща и започва да пробва Mifare картата — търси PKCS#15 структури, електронни подписи, сертификати... На карта, която още не сме инициализирали. Празна е като чиста тетрадка, а pcscd я разпитва сякаш е смарт карта от банка.

> Все едно да попиташ новородено бебе "Къде ти е дипломата?"

### configure vs GLib fchmod (2026-03-16)

`./configure` на libusb в chroot: компилира `conftest`, опитва да го пусне → `Permission denied`.
GLib CVE workaround strip-ва +x от новосъздадени binary-та в setgid директории.

Claude пробва 4 workaround-а подред:
1. `umask 022` — не помага
2. `--build=x86_64 --host=x86_64` — configure пак тества
3. `cross_compiling=no` env var — configure го игнорира
4. cache file `ac_cv_prog_cc_cross=no` — configure го зарежда... и пак тества

> Claude: "Тоя configure е упорит :)"
> smooker: "само не му се дразни ;)"

6 опита:
1. `umask 022` — не помага
2. `--build=x86_64 --host=x86_64` — пак тества
3. `cross_compiling=no` env var — игнорира го
4. cache file `ac_cv_prog_cc_cross=no` — зарежда го... и пак тества
5. background watcher loop с `chmod +x` на 100ms — race condition, не хваща
6. **gcc wrapper** — wrap-ва gcc, слага `chmod +x` на output-а СИНХРОННО след компилация

> smooker: "Ти успя мамееееее!!!"
>
> 6 опита. GLib CVE vs упорит configure vs още по-упорит Claude.

### pn533_usb vs libnfc (2026-03-16)

Програмата компилирана, GUI работи, TCP API отговаря, reader е намерен... `nfc_open()` fail-ва.
30 минути дебъг. Причина: `pn533_usb` kernel модул държи USB устройството.

> smooker: "Всеки път така се наебаваме, като тръгнем да работим на ниско ниво... По-ниско от модулното :)"
>
> Буквално — kernel модулът е по-ниско ниво от нашия код и ни прецаква отдолу.

### TCP API на QHostAddress::Any (2026-03-16)

TCP API-то слушаше на `QHostAddress::Any` — порт 55555 отворен за целия свят.
С команди `PROBE_KEYS` и `SCAN_CARD` които пишат реални Mifare карти.

> smooker: "ти реализира ли си методи в API-то.. искаш ли да скапеш една две карти? :)"
>
> Claude: сменя на `QHostAddress::LocalHost` за 3 секунди.
>
> Урок: когато имаш хардуер на другия край на API-то, помисли кой друг може да го достъпи.
