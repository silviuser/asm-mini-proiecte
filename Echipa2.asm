;Era Bizantină
;Ștind că în Țările Române se folosea pînă în sec XIX anul în forma erei bizantine, realizați un program care să afișeze anul curent în formatul erei bizantine.
;Ex: anul 2022 corespunde anului 7530 dacă data este înainte de 1 septembrie, respectiv anului 7531 dacă este după 1 septembrie.

.MODEL SMALL
.STACK 100h

.DATA
    TABELA DB "0123456789ABCDEF"    ;tabela de conversie din hexa in ascii pt XLAT

.CODE
    START:    
              MOV  AX, @DATA     ;initializare segment de date
              MOV  DS, AX

              MOV  AH, 2AH       ;CX = year (1980 to 2099)DH = month (1 to 12)DL = day of month(1 to 31)AL = day number in week (0 to 6 = Sunday to Saturday)
              INT  21H           ;citire data curenta
              CMP  DH, 8         ;daca luna este mai mare decat 8, adica suntem in septembrie sau dupa
              JA   DUPA          ;sarim la eticheta DUPA
              ADD  CX, 1584H     ;varianta in care luna este mai mica egal decat 8, adica suntem inainte de septembrie
    ;se adauga 1584H=5508d pt a obtine anul bizantin
              JMP  AFISARE
    DUPA:     
              ADD  CX, 1585H     ;varianta in care luna este mai mare decat 8, adica suntem in septembrie sau dupa
    ;se adauga 1585H=5509d pt a obtine anul bizantin
    AFISARE:  
              MOV  DI,CX         ;salvam anul bizantin in DI
              MOV  CX, 4         ;lungimea unui an in hexa(cate cifre sunt de parcurs si afisat)
              MOV  SI, 0         ;indexul de rotatie a anului pt ROL
              LEA  BX, TABELA    ;incarcam adresa tabelei de conversie in BX necesara instr XLAT
    CONVERSIE:
              MOV  AX, DI        ;incarcam anul bizantin in AX
              PUSH CX            ;salvam CX in stiva pt a nu fi modificat de instructiunea XLAT care foloseste CX
              ADD  SI, 4         ;incrementam indexul de rotatie cu 4 pt a trece la urmatoarea cifra
              MOV  CX,SI         ;incarcam indexul de rotatie in Cx pt a fi folosit de instructiunea ROL
              ROL  AX, CL        ;rotim anul bizantin cu CL pozitii la stanga
              AND  AL, 0FH       ;facem AND cu 0FH pt a extrage ultima cifra din anul bizantin
              XLAT               ;convertim cifra din hexa in ascii
              MOV  DL, AL        ;incarcam cifra convertita in DL pt a fi afisata
              MOV  AH, 02H       ;incarcam codul fct de afisare a unui singur caracter in AH
              INT  21H

              POP  CX            ;scoatem CX din stiva
              LOOP CONVERSIE     ;repetam instructiunile pana cand CX=0

              MOV  AX, 4C00H     ;sfarsit program
              INT  21h
END START
