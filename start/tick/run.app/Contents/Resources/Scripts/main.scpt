FasdUAS 1.101.10   ��   ��    k             l     ��  ��      runs kdb+ real time demo     � 	 	 2   r u n s   k d b +   r e a l   t i m e   d e m o   
  
 l     ��  ��    A ; assumes install in default location, otherwise change Q, T     �   v   a s s u m e s   i n s t a l l   i n   d e f a u l t   l o c a t i o n ,   o t h e r w i s e   c h a n g e   Q ,   T      l     ��  ��    P J Terminal|Preferences|New tabs open with must be set to "Default Settings"     �   �   T e r m i n a l | P r e f e r e n c e s | N e w   t a b s   o p e n   w i t h   m u s t   b e   s e t   t o   " D e f a u l t   S e t t i n g s "      l     ��������  ��  ��        p         �� �� 0 q Q  �� �� 0 r R  ������ 0 t T��        l     ��������  ��  ��        l     ����  r        !   m      " " � # #   ! o      ���� 0 r R��  ��     $ % $ l    &���� & O    ' ( ' Z    ) *���� ) I   �� +��
�� .coredoexbool        obj  + c     , - , m    	 . . � / / * / o p t / l o c a l / b i n / r l w r a p - m   	 
��
�� 
psxf��   * r     0 1 0 m     2 2 � 3 3  r l w r a p   1 o      ���� 0 r R��  ��   ( m     4 4�                                                                                  MACS  alis    t  Macintosh HD               �u�H+     /
Finder.app                                                      %{�a6        ����  	                CoreServices    �u�      �a'�       /   ,   +  6Macintosh HD:System: Library: CoreServices: Finder.app   
 F i n d e r . a p p    M a c i n t o s h   H D  &System/Library/CoreServices/Finder.app  / ��  ��  ��   %  5 6 5 l     7���� 7 r      8 9 8 b     : ; : o    ���� 0 r R ; m     < < � = =  ~ / q / m 3 2 / q 9 o      ���� 0 q Q��  ��   6  > ? > l  ! $ @���� @ r   ! $ A B A m   ! " C C � D D  ~ / q / s t a r t / t i c k / B o      ���� 0 t T��  ��   ?  E F E l     ��������  ��  ��   F  G H G i      I J I I      �� K���� 	0 newdb   K  L M L 1      ��
�� 
pnam M  N�� N 1      ��
�� 
ppor��  ��   J I     �� O���� 
0 newtab   O  P Q P 1    ��
�� 
pnam Q  R�� R b     S T S b     U V U b     W X W b    	 Y Z Y b     [ \ [ b     ] ^ ] o    ���� 0 q Q ^ m     _ _ � ` `    \ o    ���� 0 t T Z m     a a � b b 
 c x . q   X 1   	 
��
�� 
pnam V m     c c � d d    - p   T l    e���� e c     f g f 1    ��
�� 
ppor g m    ��
�� 
ctxt��  ��  ��  ��   H  h i h l     ��������  ��  ��   i  j k j i     l m l I      �� n���� 
0 newtab   n  o p o 1      ��
�� 
pnam p  q�� q o      ���� 0 cmd  ��  ��   m k     1 r r  s t s O     u v u O    w x w I   �� y z
�� .prcskprsnull���     ctxt y m     { { � | |  t z �� }��
�� 
faal } m    ��
�� eMdsKcmd��   x 4    �� ~
�� 
prcs ~ m       � � �  T e r m i n a l . a p p v m      � ��                                                                                  sevs  alis    �  Macintosh HD               �u�H+     /System Events.app                                               �m�X�        ����  	                CoreServices    �u�      �X�       /   ,   +  =Macintosh HD:System: Library: CoreServices: System Events.app   $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��   t  � � � O   $ � � � I   #�� � �
�� .coredoscnull��� ��� ctxt � o    ���� 0 cmd   � �� ���
�� 
kfil � 4   �� �
�� 
cwin � m    ���� ��   � m     � ��                                                                                      @ alis    l  Macintosh HD               �u�H+     RTerminal.app                                                     (��Xt        ����  	                	Utilities     �u�      �Xd       R   Q  2Macintosh HD:Applications: Utilities: Terminal.app    T e r m i n a l . a p p    M a c i n t o s h   H D  #Applications/Utilities/Terminal.app   / ��   �  � � � I   % +�� ����� 0 setname   �  ��� � 1   & '��
�� 
pnam��  ��   �  ��� � I  , 1�� ���
�� .sysodelanull��� ��� nmbr � l  , - ����� � m   , - � � ?�      ��  ��  ��  ��   k  � � � l     ��������  ��  ��   �  � � � i     � � � I      �� ����� 0 setname   �  ��� � 1      ��
�� 
pnam��  ��   � O     2 � � � O    1 � � � k    0 � �  � � � r     � � � m    ��
�� boovfals � 1    ��
�� 
tddn �  � � � r     � � � m    ��
�� boovfals � 1    ��
�� 
tdfn �  � � � r     � � � m    ��
�� boovfals � 1    ��
�� 
tdsp �  � � � r    $ � � � m     ��
�� boovfals � 1     #��
�� 
tdws �  � � � r   % * � � � m   % &��
�� boovtrue � 1   & )��
�� 
tdct �  ��� � r   + 0 � � � 1   + ,��
�� 
pnam � 1   , /��
�� 
titl��   � 1    
��
�� 
tcnt � n      � � � 4   �� �
�� 
cwin � m    ����  � m      � ��                                                                                      @ alis    l  Macintosh HD               �u�H+     RTerminal.app                                                     (��Xt        ����  	                	Utilities     �u�      �Xd       R   Q  2Macintosh HD:Applications: Utilities: Terminal.app    T e r m i n a l . a p p    M a c i n t o s h   H D  #Applications/Utilities/Terminal.app   / ��   �  � � � l     ��������  ��  ��   �  � � � i     � � � I      �������� 0 netstat  ��  ��   � I    �� ���
�� .sysoexecTEXT���     TEXT � m      � � � � � P n e t s t a t   - a n   |   g r e p   - i   l i s t e n   |   g r e p   5 0 1 0��   �  � � � l     ��������  ��  ��   �  � � � i     � � � I      �������� 0 	hasticker  ��  ��   � k      � �  � � � Q      � ��� � k     � �  � � � I    �������� 0 netstat  ��  ��   �  � � � I  	 �� ���
�� .sysodlogaskr        TEXT � m   	 
 � � � � � 6 T i c k e r p l a n t   a l r e a d y   r u n n i n g��   �  ��� � L     � � m    ��
�� boovtrue��   � R      ������
�� .ascrerr ****      � ****��  ��  ��   �  ��� � L     � � m    �
� boovfals��   �  � � � l     �~�}�|�~  �}  �|   �  � � � i     � � � I      �{�z�y�{ 0 wait4ticker  �z  �y   � k     / � �  � � � U     & � � � Q    ! � ��x � k   
  � �  � � � I  
 �w ��v
�w .sysodelanull��� ��� nmbr � m   
  � � ?��������v   �  � � � I    �u�t�s�u 0 netstat  �t  �s   �  ��r � L     � � m    �q
�q boovtrue�r   � R      �p�o�n
�p .ascrerr ****      � ****�o  �n  �x   � m    �m�m  �  � � � I  ' ,�l ��k
�l .sysodlogaskr        TEXT � m   ' ( � � � � � 6 C o u l d   n o t   s t a r t   t i c k e r p l a n t�k   �  ��j � L   - / � � m   - .�i
�i boovfals�j   �  � � � l     �h�g�f�h  �g  �f   �  � � � l  %& ��e�d � O   %& � � � k   )% � �    I  ) .�c�b�a
�c .miscactvnull��� ��� null�b  �a    Z  / ?�`�_ l  / 6�^�] =   / 6 m   / 0�\
�\ boovtrue n  0 5	
	 I   1 5�[�Z�Y�[ 0 	hasticker  �Z  �Y  
  f   0 1�^  �]   L   9 ;�X�X  �`  �_    I  @ U�W�V
�W .coredoscnull��� ��� ctxt b   @ Q b   @ M b   @ K b   @ G b   @ E b   @ C m   @ A �  c d   o   A B�U�U 0 t T m   C D �  ;   o   E F�T�T 0 q Q m   G J �    o   K L�S�S 0 t T m   M P   �!!  / t i c k . q   - p   5 0 1 0�V   "#" I  V ]�R$�Q
�R .sysodelanull��� ��� nmbr$ l  V Y%�P�O% m   V Y&& ?�      �P  �O  �Q  # '(' Z  ^ n)*�N�M) l  ^ e+�L�K+ =   ^ e,-, m   ^ _�J
�J boovfals- n  _ d./. I   ` d�I�H�G�I 0 wait4ticker  �H  �G  /  f   _ `�L  �K  * L   h j�F�F  �N  �M  ( 010 r   o }232 m   o r�E�E 3 n      454 1   x |�D
�D 
crow5 4  r x�C6
�C 
cwin6 m   v w�B�B 1 787 r   ~ �9:9 m   ~ ��A�A d: n      ;<; 1   � ��@
�@ 
ccol< 4  � ��?=
�? 
cwin= m   � ��>�> 8 >?> n  � �@A@ I   � ��=B�<�= 
0 newtab  B CDC m   � �EE �FF  r d bD G�;G b   � �HIH b   � �JKJ b   � �LML b   � �NON b   � �PQP b   � �RSR m   � �TT �UU  c d  S o   � ��:�: 0 t TQ m   � �VV �WW  ;  O o   � ��9�9 0 q QM m   � �XX �YY   K o   � ��8�8 0 t TI m   � �ZZ �[[ " / t i c k / r . q   - p   5 0 1 1�;  �<  A  f   � �? \]\ n  � �^_^ I   � ��7`�6�7 	0 newdb  ` aba m   � �cc �dd  h l c vb e�5e m   � ��4�4��5  �6  _  f   � �] fgf n  � �hih I   � ��3j�2�3 	0 newdb  j klk m   � �mm �nn  l a s tl o�1o m   � ��0�0��1  �2  i  f   � �g pqp n  � �rsr I   � ��/t�.�/ 	0 newdb  t uvu m   � �ww �xx  t qv y�-y m   � ��,�,��-  �.  s  f   � �q z{z n  � �|}| I   � ��+~�*�+ 	0 newdb  ~ � m   � ��� ���  v w a p� ��)� m   � ��(�(��)  �*  }  f   � �{ ��� n  � ���� I   � ��'��&�' 	0 newdb  � ��� m   � ��� ���  s h o w� ��%� m   � ��$�$  �%  �&  �  f   � �� ��� n  � ���� I   � ��#��"�# 
0 newtab  � ��� m   � ��� ���  f e e d� ��!� b   � ���� b   � ���� b   � ���� o   � �� �  0 q Q� m   � ��� ���   � o   � ��� 0 t T� m   � ��� ��� 8 f e e d . q   l o c a l h o s t : 5 0 1 0   - t   5 0 7�!  �"  �  f   � �� ��� r   �
��� m   � ��
� boovtrue� n      ��� 1  	�
� 
tbsl� n   ���� 4   ��
� 
ttab� m  �� � 4  � ��
� 
cwin� m   � ��� � ��� n ��� I  ���� 0 setname  � ��� m  �� ���  t i c k e r�  �  �  f  � ��� r  %��� m  �
� boovtrue� n      ��� 1   $�
� 
tbsl� n   ��� 4   ��
� 
ttab� m  �� � 4 ��
� 
cwin� m  �� �   � m   % &���                                                                                      @ alis    l  Macintosh HD               �u�H+     RTerminal.app                                                     (��Xt        ����  	                	Utilities     �u�      �Xd       R   Q  2Macintosh HD:Applications: Utilities: Terminal.app    T e r m i n a l . a p p    M a c i n t o s h   H D  #Applications/Utilities/Terminal.app   / ��  �e  �d   � ��� l     ����  �  �  �       �
�������� "� C�	����
  � ������ ����������������� 	0 newdb  � 
0 newtab  � 0 setname  � 0 netstat  � 0 	hasticker  �  0 wait4ticker  
�� .aevtoappnull  �   � ****�� 0 r R�� 0 q Q�� 0 t T��  ��  ��  ��  � �� J���������� 	0 newdb  �� ����� �  ����
�� 
pnam
�� 
ppor��  � ����
�� 
pnam
�� 
ppor� �� _�� a c������ 0 q Q�� 0 t T
�� 
ctxt�� 
0 newtab  �� *���%�%�%�%�%��&%l+ � �� m���������� 
0 newtab  �� ����� �  ����
�� 
pnam�� 0 cmd  ��  � ����
�� 
pnam�� 0 cmd  �  ���  {������ ��������� ���
�� 
prcs
�� 
faal
�� eMdsKcmd
�� .prcskprsnull���     ctxt
�� 
kfil
�� 
cwin
�� .coredoscnull��� ��� ctxt�� 0 setname  
�� .sysodelanull��� ��� nmbr�� 2� *��/ 	���l UUO� ��*�k/l 
UO*�k+ O�j � �� ����������� 0 setname  �� ����� �  ��
�� 
pnam��  � ��
�� 
pnam� 	 �����������������
�� 
cwin
�� 
tcnt
�� 
tddn
�� 
tdfn
�� 
tdsp
�� 
tdws
�� 
tdct
�� 
titl�� 3��k/ ,*�, %f*�,FOf*�,FOf*�,FOf*�,FOe*�,FO�*�,FUU� �� ����������� 0 netstat  ��  ��  �  �  ���
�� .sysoexecTEXT���     TEXT�� �j � �� ����������� 0 	hasticker  ��  ��  �  � �� ��������� 0 netstat  
�� .sysodlogaskr        TEXT��  ��  ��  *j+  O�j OeW X  hOf� �� ����������� 0 wait4ticker  ��  ��  �  � �� ��������� ����� 
�� .sysodelanull��� ��� nmbr�� 0 netstat  ��  ��  
�� .sysodlogaskr        TEXT�� 0 %�kh �j O*j+ OeW X  h[OY��O�j Of� �����������
�� .aevtoappnull  �   � ****� k    &��  ��  $��  5��  >��  �����  ��  ��  �  � 2 "�� 4 .���� 2 <�� C������� ��&��������������ETVXZ��c����m��w������������������ 0 r R
�� 
psxf
�� .coredoexbool        obj �� 0 q Q�� 0 t T
�� .miscactvnull��� ��� null�� 0 	hasticker  
�� .coredoscnull��� ��� ctxt
�� .sysodelanull��� ��� nmbr�� 0 wait4ticker  �� 
�� 
cwin
�� 
crow�� d
�� 
ccol�� 
0 newtab  ����� 	0 newdb  ���������
�� 
ttab
�� 
tbsl�� 0 setname  ��'�E�O� ��&j  �E�Y hUO��%E�O�E�O� �*j Oe)j+   hY hO��%�%�%a %�%a %j Oa j Of)j+   hY hOa *a k/a ,FOa *a k/a ,FO)a a �%a %�%a %�%a %l+  O)a !a "l+ #O)a $a %l+ #O)a &a 'l+ #O)a (a )l+ #O)a *jl+ #O)a +�a ,%�%a -%l+  Oe*a k/a .k/a /,FO)a 0k+ 1Oe*a k/a .l/a /,FU� ���  ~ / q / m 3 2 / q�	  �  �  �   ascr  ��ޭ