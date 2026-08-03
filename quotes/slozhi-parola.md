# СЛОЖИ_ПАРОЛА

Claude дава SQL за копи/пейст:

```sql
CREATE USER IF NOT EXISTS 'docs'@'localhost' IDENTIFIED BY 'СЛОЖИ_ПАРОЛА';
```

smooker го пейства. Дословно.

```
MariaDB [(none)]> CREATE USER IF NOT EXISTS 'docs'@'localhost' IDENTIFIED BY 'СЛОЖИ_ПАРОЛА';
Query OK, 0 rows affected (0.014 sec)
```

> да си беше сложил парола ти!!! :) аз съм само копи/пейстировач :)

— smooker, 2026-08-03, при вдигането на docs.smooker.org на sf1

И така production база мина през период, в който паролата на docs user-а
буквално беше плейсхолдърът „СЛОЖИ_ПАРОЛА". Строго погледнато —
инструкцията Е изпълнена: парола беше сложена.

Поука за Claude: копи/пейстировачът пейства каквото му дадеш. Генерирай
паролата ТИ и я дай готова (което и стана след това, с ALTER USER).
