.data
    nrCerinta: .space 4
    nrNoduri:  .space 4
    idNod:        .space 4
    vLegaturi: .space 400
    nr:   .space 4
    m1: .space 40000
    m2: .space 40000
    mres:.space 40000
    idLinie:   .space 4
    idColoana: .space 4
    x:           .space 4
    i:       .space 4
    j:       .space 4
    k:       .space 4
    aux:       .space 4
        index:     .space 4
    sCitire:   .asciz "%d"
    sAfisare:  .asciz "%d "
        sAfisare_drum: .asciz "%d\n"
    linieNoua: .asciz "\n"
.text
matrix_mult:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %edi
    pushl %esi
    
    movl 16(%ebp), %esi
    subl $20, %esp
    movl $0, -16(%ebp)
    movl $0, -20(%ebp)
        movl $0, -24(%ebp)
        movl $0, -28(%ebp)
        movl $0, -32(%ebp)

    for_lines_proc:
        movl -16(%ebp), %ecx
        cmp %ecx, 20(%ebp)
        je exitm_proc
        movl $0, -20(%ebp)
        for_columns_proc:
            movl -20(%ebp), %ecx
            cmp %ecx, 20(%ebp)
            je etimatrice_proc
            
            movl $0, -24(%ebp)
             
            for_aux_proc:
                movl -24(%ebp), %ecx
                cmp %ecx, 20(%ebp)
                je etimatrice1_proc
                
                movl $0, -28(%ebp)
                movl -16(%ebp), %eax
                mull 20(%ebp)
                addl -24(%ebp), %eax
                movl 8(%ebp), %edi
                movl (%edi, %eax, 4), %ebx
                movl %ebx, -28(%ebp)
                
                movl 12(%ebp), %edi
                movl -24(%ebp), %eax
                mull 20(%ebp)
                addl -20(%ebp), %eax
                movl (%edi, %eax, 4), %ebx
                movl -28(%ebp), %eax
                mull %ebx
                addl %eax, -32(%ebp)
                
                incl -24(%ebp)
                jmp for_aux_proc
                
        etimatrice1_proc:
                movl -16(%ebp), %eax
            mull 20(%ebp)
            addl -20(%ebp), %eax
            movl -32(%ebp), %ebx
            movl %ebx, (%esi, %eax,4)
            
            movl $0, -32(%ebp)
            incl -20(%ebp)
            jmp for_columns_proc
                
          etimatrice_proc:
          incl -16(%ebp)
          jmp for_lines_proc
        
    
exitm_proc:
    addl $20, %esp


    pop %esi
    pop %edi
    pop %ebx
    pop %ebp
    ret

.global main
main:

pushl $nrCerinta
pushl $sCitire
call scanf
popl %ebx
popl %ebx

pushl $nrNoduri
pushl $sCitire
call scanf
popl %ebx
popl %ebx


xorl %ecx, %ecx

# intializez cu 0 toate elementele din matrice
# si o stochez in %edi
movl $0, idLinie
lea m1, %edi
for1:
    movl idLinie, %ecx
    cmp %ecx, nrNoduri
    je et1
    movl $0, idColoana
    for2:
        movl idColoana, %ecx
        cmp %ecx, nrNoduri
        je et2
        movl idLinie, %eax
        mull nrNoduri
        addl idColoana, %eax
        movl $0, (%edi, %eax, 4)
        addl $1, idColoana
        jmp for2
    et2:
    addl $1, idLinie
    jmp for1
    
et1:
xorl %ecx, %ecx
# citesc vectorul cu nr de legaturi corespunzator fiecarui nod
# si il stochez in %esi
lea vLegaturi, %esi
loop1:
    cmp %ecx, nrNoduri
    je et3
    
    pushl %ecx
    pushl $nr
    pushl $sCitire
    call scanf
    popl %ebx
    popl %ebx
    popl %ecx
    
    movl nr, %ebx
    movl %ebx, (%esi, %ecx, 4)
    incl %ecx
    jmp loop1
    
et3:
xorl %ecx, %ecx
# parcurg vectorul cu nr de legaturi, iar, cat timp elementul din vector
# e diferit de 0, citesc vecinii corespunzator fiecarui nod.
# raportat la matrice, trebuie schimbata valoarea in 1 pe linia indexului
# din vector si pe coloana data de numarul vecinului citit
loop2:
    cmp %ecx, nrNoduri
    je eticheta
    loop3:
        movl (%esi, %ecx, 4), %ebx
        cmp $0, %ebx
        je ete
        
        pushl %ecx
        pushl $x
        pushl $sCitire
        call scanf
        popl %ebx
        popl %ebx
        popl %ecx
        
        movl %ecx, %eax
        mull nrNoduri
        addl x, %eax
                lea m1,%edi
        movl $1, (%edi, %eax, 4)
                lea m2,%edi
                movl $1, (%edi,%eax,4)
        decl (%esi, %ecx, 4)
        jmp loop3
    ete:
    incl %ecx
    jmp loop2

eticheta:
mov $1, %ecx
cmp %ecx, nrCerinta
je afisare_cerinta_1

#cerinta 2


pushl $k
pushl $sCitire
call scanf
popl %ebx
popl %ebx

pushl $i
pushl $sCitire
call scanf
popl %ebx
popl %ebx

pushl $j
pushl $sCitire
call scanf
popl %ebx
popl %ebx

movl $1, aux

inmultire_matrici:
mov aux,%ecx
cmp k, %ecx
je afisare_cerinta_2

pushl nrNoduri
pushl $mres
pushl $m2
pushl $m1
call matrix_mult
popl %ebx
popl %ebx
popl %ebx
popl %ebx


#copiez mres in m1
lea mres, %edi
lea m1, %esi
movl $0, idLinie
    forma1:
    movl idLinie, %ecx
    cmp %ecx, nrNoduri
    je eta
    movl $0, idColoana
    forma2:
        movl idColoana, %ecx
        cmp %ecx, nrNoduri
        je etma
        movl idLinie, %eax
        mull nrNoduri
        addl idColoana, %eax
        movl (%edi, %eax, 4), %ebx
        movl %ebx, (%esi, %eax, 4)

        addl $1, idColoana
        jmp forma2
    etma:
    addl $1, idLinie
    jmp forma1
eta:
incl aux
jmp inmultire_matrici



afisare_cerinta_1:
movl $0, idLinie
lea m1,%edi
for3:

    movl idLinie, %ecx
    cmp %ecx, nrNoduri
    je etexit
    movl $0, idColoana
    for4:
        movl idColoana, %ecx
        cmp %ecx, nrNoduri
        je et5
        movl idLinie, %eax
        mull nrNoduri
        addl idColoana, %eax
        movl (%edi, %eax, 4), %ebx
        
        pushl %ebx
        push $sAfisare
        call printf
        popl %ebx
        popl %ebx
        
        pushl $0
        call fflush
        popl %ebx
        
        addl $1, idColoana
        jmp for4
    et5:
    movl $4, %eax
    movl $1, %ebx
    movl $linieNoua, %ecx
    movl $1, %edx
    int $0x80
         
    incl idLinie
    jmp for3

afisare_cerinta_2:

lea mres, %edi
movl i, %eax
mull nrNoduri
addl j, %eax

pushl (%edi,%eax,4)
pushl $sAfisare_drum
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx


etexit:
movl $1, %eax
xorl %ebx, %ebx
int $0x80
