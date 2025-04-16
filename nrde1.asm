;Număr de 1
;În zona de date se regăstește un șir de numere pe un octet fiecare.
;Pentru fiecare număr din listă, să se numere și să se tipărească numărul de biți de 1 conținuți de acesta.
;Ex: Pentru numerele zecimale din memorie 16, 17, 19 se va afisa 1 2 3"
.MODEL SMALL

.DATA
    numere_octet DB 16, 17, 19
    lungime_numere EQU $ - numere_octet
.CODE
START:
    MOV AX, @DATA ; Inițializare segment de date
    MOV DS, AX
    MOV SI, OFFSET numere_octet ; <=> LEA  SI, numere_octet 
    MOV CX, lungime_numere ; Număr de numere de verificat

parcurgere_numere:
    MOV AL, [SI] ; Încarcă numărul în AL
    MOV AH, 0  ; Resetare contor
numarare_biti:
    SHR AL, 1  ; Shiftare la dreapta pentru a verifica bitul cel mai din dreapta (bitul se află în CF)
    JNC bit_zero  ; Dacă bitul este 0, sări la eticheta bit_zero
    INC AH  ; Incrementare contor pentru fiecare bit de 1 întâlnit
bit_zero:
    CMP AL, 00h  ; Verificare dacă s-a ajuns la ultimul bit
    JNZ numarare_biti
afisare:
    MOV DL, AH ; Încarcă numărul de biți de 1 în DL
    ADD DL, 30H ; Convertire număr în caracter
    MOV AH, 02H ; Funcție de afișare caracter
    INT 21H
    MOV DL, ' ' ; Afișare spațiu între numere
    MOV AH, 02H
    INT 21H
    INC SI ; Incrementare index
    LOOP parcurgere_numere  ; Parcurgere numere (PANA CAND CX == 0)

    MOV AH, 4CH ; Terminare program
    INT 21H
END START