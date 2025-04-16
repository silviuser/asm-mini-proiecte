;Ghicește numărul
;Primului jucător i se cere de la tastatură o cifră zecimală de la 0 la 9 fără a fi afișată la ecran.
;Al doilea jucător trebuie să ghicească cifra la care s-a gîndit primul jucător prin introducerea ei la tastatură.
;După introducere, se va tipări mereu un mesaj care indică jucătorului dacă cifra este prea mare, prea mică sau cea corectă. Jucătorul trebuie să introducă cifre pînă cînd o ghicește pe cea corectă.
;În cazul în care cifra este corectă, se indică acest lucru și se oprește jocul.

.MODEL SMALL
.STACK 100H

.DATA
    NR_A       DB ?
    MESAJ_NR_A DB 'Introduceti un numar intre 0 si 9: ', 0DH, 0AH, '$'
    MESAJ      DB 'Cifra memorata',0AH,'GHICESTE CIFRA INTRODUSA',0DH,0AH,'$'
    MESAJ_1    DB 0AH,'Cifra este prea mare!', 0DH, 0AH, '$'
    MESAJ_2    DB 0AH,'Cifra este prea mica!', 0DH, 0AH, '$'
    MESAJ_3    DB 0AH,'Cifra este corecta!', 0DH, 0AH, '$'
.CODE
    START:    
              MOV AX, @DATA
              MOV DS, AX

              MOV DX, OFFSET MESAJ_NR_A
              MOV AH, 09H                  ; afisare mesaj introducere numar
              INT 21H

              MOV AH, 08H                  ; citire primul numar intre 0 si 9
              INT 21H
              MOV NR_A, AL

              MOV DX, OFFSET MESAJ
              MOV AH, 09H                  ; afisare mesaj memorare numar
              INT 21H
    CITIRE:   
              MOV AH, 01H                  ; citire al doilea numar intre 0 si 9
              INT 21H

              CMP NR_A, AL                 ; comparare numere
              JE  AFISARE_3                ; daca sunt egale, jump la afisare_3
              JB  AFISARE_1                ; daca primul numar este mai mic, jump la afisare_1
              JA  AFISARE_2                ; daca primul numar este mai mare, jump la afisare_2
    AFISARE_1:
              MOV DX, OFFSET MESAJ_1
              MOV AH, 09H                  ; afisare mesaj 1
              INT 21H
              JMP CITIRE
    AFISARE_2:
              MOV DX, OFFSET MESAJ_2
              MOV AH, 09H                  ; afisare mesaj 2
              INT 21H
              JMP CITIRE
    AFISARE_3:
              MOV DX, OFFSET MESAJ_3
              MOV AH, 09H                  ; afisare mesaj 3
              INT 21H

              MOV AX, 4C00H
              INT 21H
END START