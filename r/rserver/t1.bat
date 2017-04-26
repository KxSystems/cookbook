mkdir w32
gcc -D KXVER=3 -I. -I"\Progra~1\R\R-2.15.1"/include -L. -lR  -shared -Wl,--export-all-symbols -Wl,--enable-auto-import -o w32/rserver.dll base.c q.a
