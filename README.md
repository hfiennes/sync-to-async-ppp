# sync-to-async-ppp
Bidirectional sync PPP to Async PPP converter, for a Dallas 80C320 MCU and a Zilog 85C30 SCC; this connects a 115,200bps async PPP device (in my case, a Sparcstation) to a 64kbit sync PPP device (in my case, an ISDN modem).

Why? One weekend in 1996, a friend offered me a free dial-back ISDN PPP connection to the internet (ping my IP address from the internet, and their system would dial my ISDN line and bring up PPP). My home machine directly accessible from the internet, pre-broadband! This was very exciting.

The problem was that my ISDN modem barfed on this, because it only did V110 ISDN framing, and my SparcStation 1 only had async serial. With bits lying around in our collective junk boxes myself & Patrick Arnold wire-wrapped an 8032 to an 85C30 and I knocked up some code to get something working over a weekend... but the 8032 was terribly slow. Dropping in an 80C320 made it fast enough to deal with 64kbit/s.

Presented as a curiousity, mainly, but maybe someone will find it useful.
