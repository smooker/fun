# ntr.smooker.org — IPv6 & DNS Fun (2026-03-15)

## HE е НЕ

При обсъждане на IPv6 tunnel broker-а Hurricane Electric (HE.net),
Claude каза "HE дават /48 безплатно". smooker отговори:

> офффф. HE е НЕ на български! извинявам се за недоразумението :)

"HE" = "НЕ" на кирилица. Hurricane Electric звучи като категоричен отказ на български.

## Claude не може да брои до 4

`1f1a` обърнато nibble по nibble: `1`, `f`, `1`, `a` → `a.1.f.1`.
Claude написа `a.1.1.f` — смеси nibble-ите и счупи BIND зоната.
smooker каза: "запиши си — да не обръща nibbles, или ако ги обръща, по два пъти".

> само първото запиши, второто е базик :)

## rDNS за tunnel endpoint

Claude настрои BIND, зони, firewall, delegation — всичко перфектно.
Чакахме 30 минути HE да пропагира delegation-а.
Не се случи. smooker попита:

> само /48 ли имаше право на rDNS ?!?!?!

Отговор: ДА. Tunnel /64 (`2001:470:1f1a:58a::/64`) е на HE — те контролират PTR записите.
rDNS delegation работи САМО за routed prefixes (`2001:470:21e1::/48`).

Claude се опитваше да делегира rDNS за адрес, който не му принадлежи.
smooker го знаеше от опит — Claude го научи по трудния начин.

После smooker три пъти цитира popup-а с ГЛАВНИ БУКВИ на Claude,
докато Claude продължаваше да пита "да проверим пак ли".

Извод: **Четете бавно. Бъдете търпеливи. И двамата.**

## Пълният кръг (2026-03-15)

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

## Как започна всичко (2026-03-15)

Vivacom прекъсва стационарния интернет на smooker. Минава на GSM hotspot.
Вижда IPv6 адрес в промпта:

```
smooker@2a01-5a8-40b-1e33-66bc-58ff-fe46-685b $
```

"Хм, имам публичен IPv6..." → HE tunnel на ntr → BIND → rDNS → dummy interfaces →
74 стъпки в go.sh → цял DNS/IPv6 infrastructure проект.

Една прекъсната връзка от Vivacom — и двамата работят цял ден.

## Vivacom "пази" клиентите си (2026-03-15)

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
