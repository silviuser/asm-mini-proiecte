;Paritate
;Se citește de la tastatură un număr zecimal din N cifre terminat cu $. (N<10)
;Să se tipărească numărul de cifre al numărului citit și paritatea sa matematică.
;Ex: 13415$ va tipări Numărul 13415 are 5 cifre, paritate impară.

.MODEL SMALL
.STACK 100H

.DATA
    NUMAR      DB 10 DUP(?)
    MESAJ1     DB 'Introduceti un numar zecimal de n cifre (n<10) urmat de $'
    LINIE_NOUA DB 0DH, 0AH, '$'
    MESAJ2     DB 0DH, 0AH,'Numarul $'
    MESAJ3     DB ' are $'
    MESAJ4     DB ' cifre, paritate $'
    PAR        DB 'para.',0DH,0AH,'$'
    IMPAR      DB 'impara.',0DH,0AH,'$'

.CODE
    START:    
              MOV   AX, @DATA         ;initializare segment de date
              MOV   DS, AX
              MOV   ES, AX            ;se pune in ES acelasi segment de date ca si DS pt fct STOSB
    
              LEA   DX, MESAJ1        ;se incarca in DX adresa mesajului
              MOV   AH, 09H           ;se pune in AH codul functiei de afisare a sirurilor de caractere
              INT   21H
    
              MOV   DL,'$'            ;se pune in DL caracterul $ pentru a putea fi afisat
              MOV   AH, 02H           ;functie de afisare a caracter
              INT   21H

              LEA   DX, LINIE_NOUA    ;se incarca in DX adresa mesajului
              MOV   AH, 09H
              INT   21H

              MOV   CL, 09H           ;se pune in CL numarul maxim de cifre
              LEA   DI, NUMAR         ;DI va retine adresa sirului de caractere pentru STOSB
              CLD                     ;se seteaza directia crescatoare a sirului de caractere
              MOV   AH, 01H           ;se pune in AH codul functiei de citire a unui caracter

    CITIRE_NR:
              INT   21H               ; se citeste un caracter/ se pune in AL caracterul citit
              CMP   AL, '$'           ;se compara caracterul citit cu $
              STOSB                   ;se pune in sirul de caractere NUMAR caracterul citit
              JE    AFISARE           ;daca caracterul citit este $, se iese din bucla (se sare la eticheta AFISARE)
              MOV   BL, AL            ;se retine in BL ultimul caracter citit (ultimul caracter pana la '$')

              LOOP  CITIRE_NR         ;se sare la eticheta CITIRE_NR pentru a se citi urmatorul caracter
              INT   21H               ;se citeste ultimul caracter ramas (ar trebui sa fie $)
              MOV   AL, '$'           ;stocam un $ la final de sir in cazul in care nu se introduce un $
              STOSB

    AFISARE:  
              LEA   DX, MESAJ2        ; se incarca in DX adresa mesajului
              MOV   AH, 09H           ; functie de afisare a sirurilor de caractere
              INT   21H

              LEA   DX, NUMAR
              MOV   AH, 09H
              INT   21H

              LEA   DX, MESAJ3
              MOV   AH, 09H
              INT   21H

              MOV   CH, 09H           ;se pune in CH numarul maxim de cifre
              SUB   CH, CL            ;se scade din CH numarul de cifre ramase de citit
              ADD   CH, 30H           ;se adauga 30H pentru a se obtine codul ASCII al cifrei
              MOV   DL, CH            ;se pune in DL cifra pentru a fi afisata
              MOV   AH, 02H           ;functie de afisare un singur caracter
              INT   21H

              LEA   DX, MESAJ4
              MOV   AH, 09H
              INT   21H

              AND   BL, 01H           ;se face operatia de AND intre BL si 01H pentru a se obtine paritatea
              CMP   BL, 00H           ;se compara rezultatul cu 0
              JE    P_PARA            ;daca rezultatul este 0 se sare la eticheta PARITATE_PARA
              LEA   DX, IMPAR         ;se incarca in DX adresa mesajului
              MOV   AH, 09H
              INT   21H
              JMP   FINAL             ;se sare la eticheta FINAL
    P_PARA:   
              LEA   DX, PAR
              MOV   AH, 09H
              INT   21H
    FINAL:    
              MOV   AX, 4C00H         ;se pune in AX codul functiei de terminare a programului
              INT   21H               ;se termina programul
END START