;Ziua săptămînii
;Să se afișeze la ecran ziua din săptămîna curentă în format numeric și literal (1=L, 2=M, 3=M, 4=J, 5=V, 6=S, 7=D).
;Ex: Azi este ziua 7 din săptămînă, adică D.
 
.MODEL SMALL
.STACK 100H
.DATA
    tes dw 10000000b
    MESAJ_1 DB 'Astazi este ziua $'
    MESAJ_2 DB ' din saptamana, adica $'
    ZILE    DB ' LMMJVSD$'                  ;sirul/tabelul cu zilele saptamanii pentru a putea fi accesat cu XLAT

.CODE
    START: 
           MOV  AX, @DATA             ;initializam segmentul de date
           MOV  DS, AX

           MOV  AH, 2AH               ;Functie de preluare data calendaristica
           INT  21H                   ;rezultatul functiei => CX = year  DH = month DL = day AL = day of week (00h=Sunday)
    ;vom folosi registrul CL pentru a salva ziua saptamanii din registrul AL
           MOV  CL, AL                ;salvam ziua saptamanii in registrul CL
           ADD  CL, 30H               ;convertim in caracter ASCII

           CMP  CL, 30H               ;verificam daca e duminica (00h(Sunday) + 30h = 30h)
           JNE  NU_E_D                ;daca nu e duminica sarim peste instructiunea de adaugare a 07h
           ADD  CL, 07H               ;se adauga 07h pentru a ajunge la 37h (37h = 7 in ASCII ,adica ziua 7 din saptamana)
    NU_E_D:

           LEA  DX, MESAJ_1           ;incarcam adresa mesajului in registrul DX
           MOV  AH, 09H               ;afisam prima parte a mesajului
           INT  21H

           MOV  DL, CL                ;incarcam ziua saptamanii in registrul DL
           MOV  AH, 02H               ;afisam ziua saptamanii
           INT  21H

           MOV  DX, OFFSET MESAJ_2
           MOV  AH, 09H               ;afisam a doua parte a mesajului
           INT  21H

           SUB  CL, 30H               ;convertim din caracter ASCII in numar
           MOV  AL, CL                ;incarcam ziua saptamanii in registrul AL
           MOV  BX, OFFSET ZILE       ;in BX punem adresa sirului/tabelului ZILE
           XLAT                       ;cautam ziua saptamanii in sirul/tabelul ZILE si o incarcam in registrul AL

           MOV  DL, AL
           MOV  AH, 02H               ;afisam litera corespunzatoare zilei saptamanii
           INT  21H

           MOV  DL, '.'
           MOV  AH, 02H               ;afisam punctul la final
           INT  21H

           MOV  AX, 4C00H             ;terminam programul
           INT  21H
END START