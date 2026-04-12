# който грепва — файндва

> който грепва — файндва. въпросът е да не грепва `/dev/null`.

— smooker, 2026-04-12, след 12-часова сесия в която водомерът проговори
след 39 дни мълчание (`1075.333 → 1089.565 m³`), четири collector-а бяха
пренаписани, Thunderbird видя certificate, TV-то получи Chromecast,
PostfixAdmin заработи, Apache беше погребан, и `dhcpd.conf` беше
подреден.

Context: SCteam (smooker + claude@st) debugging wMBus RF capture.
The collector was receiving 3.2 MB/s of raw IQ data but decoding
zero frames. Turned out the antenna was fine all along — just needed
a DVB kernel module blacklist + USB power cycle + regex fix for
microsecond timestamps.

```
[03:01] RX | 579 MB raw | 0 frames decoded
RAW: T1;1;1;2026-04-12 11:31:49.136463;114;117;23355392;0x2b44...
[07:33] RX | 1450 MB raw | 3 frames decoded
```

grep worked. The file wasn't `/dev/null`.
