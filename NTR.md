# ntr.smooker.org — Fun moments

LIFO — последните бисери са отгоре.

---

## 2026-03-17: "az li svalih gkg?!"

При опит да регистрира glue records за ns1/ns2.smooker.org в gkg.net,
сайтът започна да връща 502 Bad Gateway. smooker: "az li svalih gkg ?!?!!? :)))))))))))))))))"

Не, не си го свалил. Просто съвпадение.

## 2026-03-17: smooker.machines.smooker.org

smooker вече има Porkbun account. Добавен в инвентаризационния списък
като пълноправна машина с ∞ RAM и ∞ storage.

## 2026-03-17: The Great rDNS Saga

4-часов debugging marathon:
1. "allow-transfer { none; }" — MAIKA MU STARA PEDALSKA NESHTASTNA
2. dns.he.net Advanced таб крие reverse зони — изтриваш ги, те се връщат
3. NS запис с name "ns1" вместо "@" — самореференция
4. gkg.net пада с 502 точно когато трябва glue records — "az li svalih gkg?!"
5. Cloudware REFUSED нашия NOTIFY — олигофрения
6. Скриптът показва EMPTY защото delegation-ът е в AUTHORITY, не ANSWER
7. Накрая: `dig -6 @ns1.he.net` → `NS ns1.smooker.org. NS ns2.smooker.org.`
8. Google rDNS: `2001:470:21e1:1::1` → `ntr.smooker.org` ✓

Lessons learned: Не се кара с DNS. DNS се кара с теб.
