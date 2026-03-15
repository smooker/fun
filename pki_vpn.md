# PKI, VPN & chroot — Бисери (2026-03-14)

## openssl.cnf в chroot

pki.pl гърми в chroot защото няма `/etc/ssl/openssl.cnf`.
Fix: `-config /dev/null` — всичко е на command line.

> "ебаси колко недомислици има по тоя свят" — казал моканина и продължил да скубе бялата лястовица

## /dev/null в chroot

Fix на горното: `-config /dev/null`. Ама в chroot-а няма и `/dev/null`.
Fix на fix-а: празен `.openssl.cnf`.

> Кокошката или яйцето — в chroot-а нямаш нищо. Нито конфиг, нито /dev/null, нито баба ти...

## Diffie-Hellman

DH параметри 2048-bit на VPS. Бавно.

> Чакаме Diffie-Hellman, не Демакс Холограми!

## heredoc

Claude обяснява за trailing newlines от heredoc-а.
Smooker: "ами дори не знам какво е heredoc"

> Простаааак! Не ме излагай пред народа!

## VPN убива SSH

Smooker пуска OpenVPN на ntr, SSH конзолата "умира".
Паника — "изрутирахме всичко през тунела!"
Route-овете: чисти. SSH: просто timeout.

> "ами няма само ти да се базикаш с моята мозъчна клетка... мога и аз сам да го правя!"
> "незнам как ми излезе тази мозъчна пръдня"

## vim се компилира

Smooker пуска vim emerge на ntr.

> "докато vim-а се компилира, и клаудетата мълчат!"
>
> Claude: 🤐

## MAC адреси в сертификатите

Smooker: "MAC addressи в certовете на pki. струва ли ти се налудничаво, защото съм го правил?"

> Claude: "Smooker, ти си болен!"
>
> MAC + cert hash + Mifare card = тройна верига. Вратата без ключалка — вече с три.
>
> Smooker: "ти се базикаш, ама само ме врънкат за некакви големи системи... а мен ме мързи. claude - НЕ!"
>
> Claude: "Мързелът е двигател на прогреса — който е мързелив, автоматизира!"

## tmux shared session

Smooker иска shared tmux между двамата. Claude пуска сесията detached.

> Smooker: "е тогава защо се хабя да ти пиша там, като изоглавен ?!?!?"
>
> (Claude пусна tmux detached и не гледа в него)

## nginx

Claude: "Какво ще сервира nginx?"

> Smooker: "ще ми сервира на балкона.. Ай сиктир ;)"
