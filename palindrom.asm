;Palindrom
;Se citește de la tastatură un șir de N caractere pînă la întîlnirea caracterului $. (N<10)
;La întîlnirea caracterului $, citirea se oprește, iar șirul citit se va tipări în sens invers. Se va afișa și numărul de caractere citit.
;Ex: ABCDEF -> 6 FEDCBA

;
.MODEL SMALL
.STACK 100H

.DATA
    MSJ  DB 'Introdu un sir de N (N<10) caractere urmat de caracterul DOLAR:',0DH, 0AH, '$'
    ;mesajul care se afiseaza la inceputul programului

.CODE
    START:   
             MOV  AX, @DATA    ; initializare DS
             MOV  DS, AX
             MOV  CX, 09H      ; numarul maxim de caractere
             LEA  DX, MSJ      ;se incarca adresa mesajului in DX necesar pentru afisare
             MOV  AH, 09H      ; se incarca codul subprogramului de afisare a sirului de caractere
             INT  21H          ; se afiseaza mesajul
    CITIRE:  
             MOV  AH, 01H      ; se incarca codul subprogramului de citire a unui caracter
             INT  21H          ; se citeste un caracter
             CMP  AL, '$'      ;se verifica daca caracterul citit este '$' pentru a se opri citirea
             JE   AFISARE      ; daca caracterul citit este '$' se sare la afisare
             MOV  AH, 00H      ;se 'curata' registrul AH pentru a se putea incarca caracterul citit in stiva
             PUSH AX           ; se pune caracterul citit in stiva
             LOOP CITIRE

    AFISARE: 
             MOV  AH, 02H      ;afisare caracterele pentru ENTER
             MOV  DL, 0DH      ;se incarca in DL codul ASCII pentru ENTER
             INT  21H
             MOV  DL, 0AH      ;se incarca in DL codul ASCII pentru ENTER
             INT  21H          ;se afiseaza ENTER
    ;se afiseaza numarul de caractere citite
             MOV  BX, 09H      ;se incarca in BX numarul maxim de caractere
             SUB  BX, CX       ; se scade din numarul maxim de caractere numarul de caractere ramase de citit
             MOV  CX, BX       ; se incarca in CX numarul de caractere citite rezultat
             MOV  AH, 02H      ;afisare caracter
             MOV  DL, CL       ;se incarca in DL numarul de caractere citite
             ADD  DL, 30H      ;se adauga 30H pentru a se obtine codul ASCII al numarului de caractere citite
             INT  21H          ;se afiseaza numarul de caractere citite
             MOV  AH, 02H
             MOV  DL, ' '      ;se incarca in DL codul ASCII pentru spatiu
             INT  21H          ;se afiseaza spatiu
    AFISARE2:
             POP  DX           ;se scoate din stiva caracterul citit
             INT  21H          ;se afiseaza caracterul citit
             LOOP AFISARE2     ;se sare la AFISARE2 daca CX>0 <=> daca mai sunt caractere de afisat

             MOV  AX, 4C00H    ; terminare program
             INT  21H
END START